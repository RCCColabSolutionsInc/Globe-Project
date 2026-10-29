# sp_Job_Memo_Postload Reverse Engineering

Reverse engineered on 2026-06-01 from the SQL scripts in this repository.

## Scope

This document describes the SQL ETL process whose standard Memo postload entry point
is:

```sql
[dswTDIR1].[dbo].[sp_Job_Memo_Postload]
```

The procedure has no runtime parameters. It runs as a weekday, global reconciliation
process after Memo preload output has been generated and sent for SAP posting. It
refreshes recent SAP upload logs, rebuilds a postload work table from preload-valid
rows, classifies SAP posting outcomes, routes unresolved rows into the Memo data
cleansing system, prepares SSRS caches, triggers Excel report subscriptions, emails
available reports, and asynchronously starts a final summary-notification job.

This document covers:

- SQL Agent context for standard and DCS postload jobs.
- The direct call chain from `sp_Job_Memo_Postload`.
- The SAP upload-log delta refresh through linked server `SAP_S4`.
- Global cleanup and reload behavior for `ttMEMOAPP_Postload`.
- SAP success and failure matching rules.
- The cross-database handoff into `DCSTDIR1.dbo.dcMemoApp`.
- Report-cache, SSRS export, email, and summary-notification behavior.
- The separately scheduled DCS postload workflow.
- Historical objects that exist in source but are not active in the reviewed chain.
- Source-grounded operational risks and validation checks.

## Executive Summary

The standard Memo postload is a reconciliation process, not a file-ingestion process.
It assumes the preload workflow has already populated `ttMEMOAPP_Preload`, exported
posting files, pushed those files toward SAP, and allowed enough time for SAP upload
logs to become available.

The weekday runtime flow is:

1. `Memo_Postload_P20_WkDays` runs `sp_Job_Memo_Postload` at `3:55 PM`.
2. The entry procedure refreshes recent SAP upload logs through
   `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`.
3. It globally deletes and rebuilds `dswTDIR1.dbo.ttMEMOAPP_Postload` from preload rows
   whose `zError_Counter = 0`.
4. It marks successful postings from SAP upload logs and writes SAP failure messages
   onto unresolved rows.
5. It inserts unresolved rows into the Memo data cleansing module exposed as
   `dswTDIR1.dbo.dcMemoApp`.
6. It refreshes global failed and successful report caches.
7. It deletes previous SSRS workbook files, triggers the two postload subscriptions,
   and emails nonempty reports.
8. It asynchronously starts `Memo_Postload_P25_Notif_Summary_AdHoc`, which emails the
   Process Stage 3 of 3 reconciliation summary.

The separately scheduled `Memo_Postload_DCS_P20_WkDays` job reconciles cleansing-page
records after operators approve them and the DCS preload workflow resubmits them.

## Source Files Reviewed

### Pipeline Metadata and Reference Documentation

- `rev_eng-prompt.txt`
- `etl_pipelines.txt`
- `sql-agent-jobs.txt`
- `Memo_Preload.md`
- `MyBSS_Innove_Bill_Cycles_Preload.md`
- `MyBSS_Innove_Bill_Cycles_Postload.md`
- `MyBSS_Globe_Bill_Cycles_Preload.md`
- `MyBSS_Globe_Bill_Cycles_Postload.md`

### Standard Postload Orchestration

- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Postload.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_LoadSapTables.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Transform.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Prepare.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Export.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Send.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Postload_Notif_Summary.StoredProcedure.sql`

### Standard Postload Transform Rules

- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_DeleteAllRecordsDel.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_Insert_from_PreloadValid_Ins.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_zLoaded_Pipe_Upd.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_zError_Message_Upd.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_Insert_Into_DcMemoApp_Ins.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_zError_Load_Counter_DCS_Upd.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_zLoaded_FromDCS_Upd.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_Postload_zErrorMessage_Load_DCS_Upd.StoredProcedure.sql`
- Matching `trMEMOAPP_Postload_*Sel` views under `dswTDIR1/views`

### Standard Postload Tables and Report Objects

- `dswTDIR1/tables/dbo.ttMEMOAPP_Postload.Table.sql`
- `dswTDIR1/tables/dbo.Memo_Postload_Line_Report_Prepare_Failed_Cache.Table.sql`
- `dswTDIR1/tables/dbo.Memo_Postload_Line_Report_Prepare_Success_Cache.Table.sql`
- `dswTDIR1/tables/dbo.MemoMigratePostloadTemp.Table.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Prepare_Failed.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Prepare_Success.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Prepare_Failed_SSRS.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Prepare_Success_SSRS.StoredProcedure.sql`

### SAP Upload-Log Refresh and Wrappers

- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZFFI_REPORT_ODBC_Delta.StoredProcedure.sql`
- `dgS4HANA_TDIR1/tables/dbo.ZFFI_REPORT_ODBC.Table.sql`
- `dgS4HANA_TDIR1/views/dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dswTDIR1/views/dbo.ZFFI_REPORT_ODBC.View.sql`
- `dswTDIR1/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`

### DCS Handoff and Related Postload Workflow

- `dswTDIR1/views/dbo.dcMemoApp.View.sql`
- `dswTDIR1/tables/dbo.ttMEMOAPP_DCS_Postload.Table.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_DCS_Transform.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.trMEMOAPP_DCS_Output_Insert_from_MemoAppErrorPage_ApprovedRecords_Ins.StoredProcedure.sql`
- `dswTDIR1/views/dbo.trMEMOAPP_DCS_Output_Insert_from_MemoAppErrorPage_ApprovedRecords_InsSel.View.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Postoad_DCS.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_DCS_LoadSapTables.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postoad_DCS_Transform.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postoad_DCS_Report_Prepare.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postoad_DCS_Report_Export.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postoad_DCS_Report_Send.StoredProcedure.sql`
- Matching DCS transform, report-cache, report-selector, and SSRS dataset objects

### Historical Reference Objects

- `ESTSS/programmability/stored_procedures/dbo.sp_MemoMigratePostload_SendMail.StoredProcedure.sql`
- `ESTSS/programmability/stored_procedures/dbo.sp_MemoMigratePostload_SendMail_DSP.StoredProcedure.sql`
- `ESTSS/programmability/stored_procedures/dbo.sp_MemoMigratePostload_SendMail_SQL.StoredProcedure.sql`
- `ESTSS/tables/dbo.MemoMigratePostloadTemp.Table.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Postload_Report_Send_02_DSP.StoredProcedure.sql`
- Inactive alternate standard `trMEMOAPP_Postload_zLoaded_*` procedures and views

## Databases and External Dependencies

| Dependency | Purpose |
| --- | --- |
| `dswTDIR1` | Standard and DCS orchestration, postload work tables, report caches, SAP wrapper views, and DCS integration views |
| `DCSTDIR1` | Physical Memo cleansing-page data behind `dswTDIR1.dbo.dcMemoApp` |
| `dgS4HANA_TDIR1` | Local copy of SAP upload logs and delta-refresh procedure |
| Linked server `SAP_S4` | Reads SAP table `SAPPRD.ZFFI_REPORT_ODBC` through `OPENQUERY` |
| `etl_db` | Procedure execution logging and latest-processed-date lookup |
| `msdb` | Starts the asynchronous summary SQL Agent job and sends Database Mail |
| `ReportServer$DACPRD` | Stores SSRS subscriptions and event queue; receives `AddEvent` calls |
| `F:\BOA\Transform\Report\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_SSRS` | Fixed SSRS workbook-output folder; deployed path contains `MEMEOAPP` |
| SQL Server `xp_cmdshell` | Deletes previous workbook files before subscriptions run |
| `sdbTDIR1_MemoApp` | Upstream MemoApp landing and source processing used by preload |
| `dswTDIR1_Cache` | Metadata-listed Memo cache database; contains postload-named cache table definitions not used by the active standard report-prepare procedures reviewed here |
| `ESTSS` | Contains older Memo postload summary and mail procedures retained as historical reference |

Important helper procedures:

| Procedure | Role |
| --- | --- |
| `etl_db.dbo.sp_ExecuteQueryAndLog` | Executes and logs each synchronous child procedure |
| `etl_db.dbo.fn_GetLatestProccessedDate` | Retrieves the logged completion time used by the summary email |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta` | Refreshes recent SAP posting logs from linked server `SAP_S4` |
| `ReportServer$DACPRD.dbo.AddEvent` | Triggers SSRS timed subscriptions |
| `msdb.dbo.sp_start_job` | Starts the asynchronous stage-summary job |
| `msdb.dbo.sp_send_dbmail` | Sends report and summary emails |

Important observed detail: no standard Memo postload SFTP procedure or postload SFTP SQL
Agent job appears in the reviewed source or metadata. File delivery occurs in the
preload workflow; postload reconciles SAP results and sends reports.

## SQL Agent Context

### Standard Postload Jobs

| Job | Step | Command | Schedule |
| --- | --- | --- | --- |
| `Memo_Postload_P20_WkDays` | `sp_Job_Memo_Postload` | `EXEC dbo.sp_Job_Memo_Postload` | Weekdays at `3:55 PM` |
| `Memo_Postload_P25_Notif_Summary_AdHoc` | `sp_Job_Memo_Postload_Notif_Summary` | `EXEC dbo.sp_Job_Memo_Postload_Notif_Summary` | No direct schedule |

`sp_Job_Memo_Postload` starts `Memo_Postload_P25_Notif_Summary_AdHoc` after the
synchronous postload work. The parent procedure does not wait for or verify the
summary-job result.

### Upstream Standard Preload Jobs

| Job | Command or package | Schedule |
| --- | --- | --- |
| `Memo_Preload_P01_Setup_Cleanup_WkDays` | `EXEC dbo.sp_MemoRFP_Job_Cleanup` | Weekdays at `2:30 PM` |
| `Memo_Preload_P02_Extract_WkDays_v2` | Batch preparation, `Memo_Format03_38Columns.dtsx`, and extraction summary | Weekdays at `2:40 PM` |
| `Memo_Preload_P10_WkDays` | `EXEC dbo.sp_Job_Memo_Preload` | Weekdays at `2:55 PM` |
| `Memo_Preload_P15_SFTP_AdHoc` | `EXEC dbo.sp_Job_Memo_Preload_SFTP` | No direct schedule |
| `Memo_Preload_P17_Notif_Summary_AdHoc` | `EXEC dbo.sp_Job_Memo_Preload_Notif_Summary` | No direct schedule |

The postload schedule assumes these upstream steps have already generated, delivered,
and posted the Memo SAP upload files.

### Related DCS Jobs

| Job | Step | Command | Schedule |
| --- | --- | --- | --- |
| `Memo_Preload_DCS_P10_WkDays` | `sp_Job_Memo_Preload_DCS` | `EXEC dbo.sp_Job_Memo_Preload_DCS` | Weekdays at `2:50 PM` and `6:01 PM` |
| `Memo_Postload_DCS_P20_WkDays` | `sp_Job_Memo_Postoad_DCS` | `EXEC dbo.sp_Job_Memo_Postoad_DCS` | Weekdays at `4:05 PM` and `7:35 PM` |

The DCS preload workflow resubmits approved cleansing-page records. The DCS postload
workflow reconciles their SAP outcomes. These are separately scheduled jobs and are not
called by `sp_Job_Memo_Postload`.

Important observed detail: the active DCS postload object names use `Postoad`, without
the second `l`, including `sp_Job_Memo_Postoad_DCS`, child procedures, and report-cache
tables. This typo is part of the deployed naming contract and is preserved throughout
this document.

### Logging Dimensions

The standard postload parent calls `etl_db.dbo.sp_ExecuteQueryAndLog` with:

```text
@Proccess     = Memo
@ProcessGroup = All
@Step         = Postload
@Others       = Daily
```

The related DCS parent uses:

```text
@Proccess     = Memo
@ProcessGroup = All
@Step         = Postload - DCS
@Others       = Daily
```

The source spelling `@Proccess` is preserved because it is part of the deployed logging
contract.

### Metadata Gap

`etl_pipelines.txt` lists `Memo Standard Template` and these databases:

```text
sdbTDIR1_MemoApp
dswTDIR1
dswTDIR1_Cache
```

Its `sql agent jobs` section is empty. The concrete job inventory is present in
`sql-agent-jobs.txt`. `DCSTDIR1`, `dgS4HANA_TDIR1`, `etl_db`, `msdb`,
`ReportServer$DACPRD`, and linked server `SAP_S4` are also required by the SQL but are
not listed in that pipeline metadata entry.

## Cleanup Process

There is no separately scheduled standard postload cleanup job in `sql-agent-jobs.txt`.
Cleanup occurs inside active transform and report procedures.

### Standard Postload Cleanup

`sp_Memo_Postload_Transform` first calls:

```sql
dbo.trMEMOAPP_Postload_DeleteAllRecordsDel
```

That procedure deletes through view `trMEMOAPP_Postload_DeleteAllRecordsDelSel`, which
selects all rows from:

```text
dswTDIR1.dbo.ttMEMOAPP_Postload
```

This is a global delete. It is not scoped by input file, date, scenario, counter, or
run identifier.

### Standard Report-Cache Cleanup

`sp_Memo_Postload_Report_Prepare` globally truncates:

```text
dswTDIR1.dbo.Memo_Postload_Line_Report_Prepare_Failed_Cache
dswTDIR1.dbo.Memo_Postload_Line_Report_Prepare_Success_Cache
```

### Summary Cleanup

`sp_Job_Memo_Postload_Notif_Summary` globally truncates:

```text
dswTDIR1.dbo.MemoMigratePostloadTemp
```

### Related DCS Cleanup

The upstream DCS preload transform globally deletes all rows from:

```text
dswTDIR1.dbo.ttMEMOAPP_DCS_Postload
```

before inserting currently approved cleansing-page records. The DCS postload report
prepare procedures also globally truncate their failed and success caches.

## Parameter Mapping

`sp_Job_Memo_Postload` has no runtime parameters. There is no cycle table, bill-cycle
argument, posting-date argument, company argument, or entity argument to resolve.

The process is globally scoped to the current contents of shared tables. Its effective
input mapping is status-driven:

| Layer | Included rows | Scope |
| --- | --- | --- |
| Standard postload input | `ttMEMOAPP_Preload` rows where `zError_Counter = 0` | Global preload target |
| Standard SAP success | Matching latest SAP log where message contains `SUCCES` or `Posted` | Match on `zDSP_Order` and `zDSP_UniqueKey` |
| Standard SAP failure text | Matching SAP log where message does not contain `SUCCES` or `Posted`, and program is `ZRFFI_UPLOAD_OPEN_BAL` | Exact `zDSP_UniqueKey` match |
| DCS handoff | Standard postload row where `zLoaded = 0` and no existing cleansing record has the same legacy key and source | Cross-database `dcMemoApp` insert |
| DCS preload resubmission | Approved cleansing rows with no DCS validation errors or disabled flags | Global `dcMemoApp` selection |
| DCS postload success | DCS row matching a latest SAP log whose message contains `SUCCES` or `Posted` | Match on `zDSP_Order` and `zDSP_UniqueKey` |

## Main Procedure Call Chain

`dswTDIR1.dbo.sp_Job_Memo_Postload` runs five synchronous children through
`etl_db.dbo.sp_ExecuteQueryAndLog`, then starts one asynchronous SQL Agent job.

| Order | Procedure or job | Execution mode | Role |
| --- | --- | --- | --- |
| 1 | `dswTDIR1.dbo.sp_Memo_Postload_LoadSapTables` | Synchronous logged procedure | Refresh recent SAP upload logs |
| 2 | `dswTDIR1.dbo.sp_Memo_Postload_Transform` | Synchronous logged procedure | Rebuild postload work rows, classify SAP outcomes, and route unresolved rows into DCS |
| 3 | `dswTDIR1.dbo.sp_Memo_Postload_Report_Prepare` | Synchronous logged procedure | Refresh standard failed and success report caches |
| 4 | `dswTDIR1.dbo.sp_Memo_Postload_Report_Export` | Synchronous logged procedure | Trigger SSRS workbook subscriptions |
| 5 | `dswTDIR1.dbo.sp_Memo_Postload_Report_Send` | Synchronous logged procedure | Email nonempty workbook reports |
| 6 | SQL Agent job `Memo_Postload_P25_Notif_Summary_AdHoc` | Asynchronous `msdb.dbo.sp_start_job` | Send Process Stage 3 of 3 summary |

## Step 1: Refresh SAP Upload Logs

Procedure:

```sql
[dswTDIR1].[dbo].[sp_Memo_Postload_LoadSapTables]
```

### Active Refresh

The active procedure calls:

```sql
EXEC [dgS4HANA_TDIR1].[dbo].[sp_ZFFI_REPORT_ODBC_Delta];
```

It then prints:

```text
TODO
```

### Delta-Refresh Behavior

`dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`:

1. Starts a SQL transaction.
2. Reads `SAPPRD.ZFFI_REPORT_ODBC` through linked server `SAP_S4`.
3. Restricts the linked query to SAP rows from the last one day:

```sql
WHERE CAST("Z_DATE" AS DATE) >= ADD_DAYS(CURRENT_DATE, -1)
```

4. Normalizes `ZDSP_UNIQUEKEY` by trimming and replacing tab, line-feed, and
   carriage-return characters with spaces.
5. Keeps the latest row per `ZDSP_UNIQUEKEY`, `Z_PROG_NAME`, and `Z_LINE_ITEM`.
6. Deletes matching local log rows by unique key, DSP order, and program name.
7. Inserts the refreshed rows into `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC`.
8. Commits the transaction or rolls it back and raises the SQL error.

### Local Wrappers

The standard transform reads:

| View | Behavior |
| --- | --- |
| `dswTDIR1.dbo.ZFFI_REPORT_ODBC` | Wraps `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` and filters `MANDT = '300'` |
| `dswTDIR1.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` | Uses optimized `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS`, which keeps the latest local row per unique-key/program/line-item tuple |

Important observed detail: the active optimized latest-log wrapper does not apply an
explicit `MANDT = '300'` predicate in the `dswTDIR1` view, while the raw wrapper does.

### Inactive Lookup Refreshes

Historical reference: `sp_Memo_Postload_LoadSapTables` contains commented calls for
general SAP lookup refreshes such as `sp_T007A`, `sp_SKB1`, `sp_SKA1`, `sp_SKAT`,
`sp_T030K`, `sp_T042Z`, `sp_T25A1`, `sp_T25A2`, `sp_T25A4`, `sp_T25A9`, and
`sp_TVZBT`. Only `sp_ZFFI_REPORT_ODBC_Delta` is active.

## Step 2: Rebuild and Reconcile Postload Rows

Procedure:

```sql
[dswTDIR1].[dbo].[sp_Memo_Postload_Transform]
```

The transform runs these children in order:

| Order | Procedure | Role |
| --- | --- | --- |
| 1 | `trMEMOAPP_Postload_DeleteAllRecordsDel` | Delete all previous standard postload rows |
| 2 | `trMEMOAPP_Postload_Insert_from_PreloadValid_Ins` | Copy preload-valid rows into postload |
| 3 | `trMEMOAPP_Postload_zLoaded_Pipe_Upd` | Mark successful SAP postings |
| 4 | `trMEMOAPP_Postload_zError_Message_Upd` | Store SAP failure text |
| 5 | `trMEMOAPP_Postload_Insert_Into_DcMemoApp_Ins` | Route unresolved rows into DCS |
| 6 | `trMEMOAPP_Postload_zError_Load_Counter_DCS_Upd` | Mark matching DCS records as load errors |
| 7 | `trMEMOAPP_Postload_zLoaded_FromDCS_Upd` | Mark existing DCS records loaded when SAP reports success |
| 8 | `trMEMOAPP_Postload_zErrorMessage_Load_DCS_Upd` | Copy DCS load-message state back into standard postload rows |

### Input and Target

`trMEMOAPP_Postload_Insert_from_PreloadValid_Ins` copies the full preload posting row
shape from:

```text
dswTDIR1.dbo.ttMEMOAPP_Preload
```

into:

```text
dswTDIR1.dbo.ttMEMOAPP_Postload
```

Its selector filters only:

```sql
WHERE zError_Counter = '0'
```

The target table primary key is:

```text
zLegacyzDSP_UniqueKey
zSource
```

Important observed detail: the postload selector does not add a current-date,
input-file, scenario, or run-identifier predicate. It also does not directly filter
`zError_LineItem`; it relies on the preload counter-error propagation performed by the
upstream workflow.

### SAP Success Matching

`trMEMOAPP_Postload_zLoaded_Pipe_Upd` updates `ttMEMOAPP_Postload.zLoaded` to `1`
when `ZFFI_REPORT_ODBC_LATESTLOGS` matches:

```text
ttMEMOAPP_Postload.zDSP_Order     = ZFFI_REPORT_ODBC_LATESTLOGS.zDSP_Order
ttMEMOAPP_Postload.zDSP_UniqueKey = ZFFI_REPORT_ODBC_LATESTLOGS.zDSP_UniqueKey
```

and the SAP message satisfies:

```sql
z_Message LIKE '%SUCCES%'
OR z_Message LIKE '%Posted%'
```

The `SUCCES` substring is intentionally broad enough to match common success spellings.

### SAP Failure Matching

`trMEMOAPP_Postload_zError_Message_Upd` sets:

```text
zErrorMessage_Load = SAP z_Message
zLoaded            = 0
```

when:

```text
ttMEMOAPP_Postload.zDSP_UniqueKey = ZFFI_REPORT_ODBC.zDSP_UniqueKey
```

and:

```sql
ZFFI_REPORT_ODBC.zDSP_UniqueKey <> ''
AND ZFFI_REPORT_ODBC.z_Message NOT LIKE '%SUCCES%'
AND ZFFI_REPORT_ODBC.z_Message NOT LIKE '%Posted%'
AND Z_PROG_NAME = 'ZRFFI_UPLOAD_OPEN_BAL'
```

Important observed detail: standard success matching reads the latest-log view and
matches DSP order plus unique key. Standard failure matching reads the raw wrapper and
matches only the unique key. These are different matching contracts.

### Route Unresolved Rows into DCS

`trMEMOAPP_Postload_Insert_Into_DcMemoApp_Ins` inserts unresolved rows into:

```text
dswTDIR1.dbo.dcMemoApp
```

That object is an insertable cross-database view over:

```text
DCSTDIR1.dbo.dcMemoApp
```

The selector inserts a row when:

```sql
ttMEMOAPP_Postload.zLoaded = 0
AND dcMEMOAPP.zLegacyzDSP_UniqueKey IS NULL
```

The duplicate check joins on:

```text
zLegacyzDSP_UniqueKey
zSource
```

Inserted rows receive:

```text
boaStatus       = 1
zApprovalStatus = Draft
```

The DCS row shape carries preload posting fields, original validation flags,
postload-load flags, cleansing status fields, approval fields, and the 2025 PPM and NTG
payload additions.

Important observed detail: a commented selector predicate would have required
`zErrorMessage_Load IS NOT NULL`, but that predicate is inactive. The active handoff
routes every unresolved and not-yet-present row, including rows without a captured SAP
failure message.

### Synchronize DCS Status

The remaining transform children maintain cross-system state:

| Procedure | Active behavior |
| --- | --- |
| `trMEMOAPP_Postload_zError_Load_Counter_DCS_Upd` | Updates `dcMemoApp.zError_Load_DCS = 1` where standard postload and DCS rows match on `zDSP_Order` and `zDSP_UniqueKey` |
| `trMEMOAPP_Postload_zLoaded_FromDCS_Upd` | Updates `dcMemoApp.zLoaded = 1` when raw SAP logs match on order and unique key and contain `SUCCESSFUL` |
| `trMEMOAPP_Postload_zErrorMessage_Load_DCS_Upd` | Copies `dcMemoApp.zErrorMessage_Load_DCS` into matching `ttMEMOAPP_Postload` rows by order and unique key |

Important observed detail: the standard transform writes into DCS immediately after
classifying standard SAP outcomes. The later DCS jobs operate on the same cleansing
store but are separately scheduled.

### Inactive Alternate Matchers

Historical reference: the repository retains inactive alternate procedures and views:

- `trMEMOAPP_Postload_zLoaded_Upd`
- `trMEMOAPP_Postload_zLoaded_NoPipe_Upd`
- `trMEMOAPP_Postload_zLoaded_NoPipe_UpdSel`
- `trMEMOAPP_Postload_zLoaded_NoPipe_UpdSel_010`

The no-pipe matcher compares shortened key suffixes. The active standard transform
calls only `trMEMOAPP_Postload_zLoaded_Pipe_Upd`.

## Step 3: Prepare Standard Report Caches

Procedure:

```sql
[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Prepare]
```

It runs:

| Order | Procedure | Cache | Selector |
| --- | --- | --- | --- |
| 1 | `sp_Memo_Postload_Report_Prepare_Failed` | `Memo_Postload_Line_Report_Prepare_Failed_Cache` | `ttMEMOAPP_Postload` rows where `zLoaded <> '1'` |
| 2 | `sp_Memo_Postload_Report_Prepare_Success` | `Memo_Postload_Line_Report_Prepare_Success_Cache` | `ttMEMOAPP_Postload` rows where `zLoaded = '1'` |

Both cache procedures truncate their target cache globally before inserting current
results.

### Failed Cache

The failed cache includes all postload columns for rows where:

```sql
zLoaded <> '1'
```

This means the report is a current unresolved-row report. Some rows may already have
been routed to DCS and may still be awaiting cleansing or approval.

### Success Cache

The success cache includes all successful postload rows. It left joins:

```text
dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC
```

on:

```text
ttMEMOAPP_Postload.zDSP_UniqueKey = ZFFI_REPORT_ODBC.zDSP_UniqueKey
```

and reports SAP `Z_MESSAGE` in the output column named `zErrorMessage_Load`. A source
comment explains that the posting document is being placed in the error-message column
for successful postings.

Important observed detail: the success-cache join uses only `zDSP_UniqueKey`, not DSP
order, program, line item, or a latest-log predicate.

### SSRS Dataset Procedures

| Dataset procedure | Result |
| --- | --- |
| `sp_Memo_Postload_Report_Prepare_Failed_SSRS` | `SELECT *` from failed cache |
| `sp_Memo_Postload_Report_Prepare_Success_SSRS` | `SELECT *` from success cache |

## Step 4: Trigger Standard SSRS Exports

Procedure:

```sql
[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Export]
```

The procedure triggers these subscriptions:

| Subscription description | Workbook |
| --- | --- |
| `Postload_Failed` | `Postload_Failed.xlsx` |
| `Postload_Success` | `Postload_Success.xlsx` |

For each matching subscription, the procedure:

1. Deletes the previous workbook through `xp_cmdshell`.
2. Calls `ReportServer$DACPRD.dbo.AddEvent` with event type `TimedSubscription`.
3. Polls `ReportServer$DACPRD.dbo.Event` every three seconds.
4. Stops waiting when the event disappears or iteration `100` is reached.

The fixed workbook folder is:

```text
F:\BOA\Transform\Report\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_SSRS
```

The timeout is approximately five minutes per subscription.

## Step 5: Email Standard Reports

Procedure:

```sql
[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Send]
```

The procedure counts rows in the two standard caches and emails each workbook only
when its cache is nonempty.

| Subscription | Record-count source | Send condition |
| --- | --- | --- |
| `Postload_Failed` | `Memo_Postload_Line_Report_Prepare_Failed_Cache` | Count greater than zero |
| `Postload_Success` | `Memo_Postload_Line_Report_Prepare_Success_Cache` | Count greater than zero |

It waits five seconds before calling `msdb.dbo.sp_send_dbmail`, although the nearby
comment still says three seconds.

### Standard Report Email

| Setting | Value |
| --- | --- |
| Database Mail profile | `SSRS` |
| Subject pattern | `Report Notif: Memo RFP <subscription> - <count> Record(s) Generated` |
| Attachment folder | `F:\BOA\Transform\Report\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_SSRS` |
| Report server link | `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx` |
| Recipients | `zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph;jsshernandez@globe.com.ph;emmerioles@globe.com.ph;michelle.oliveras@gsupport.com.ph;paula.villafranca@gsupport.com.ph` |
| Copy recipients | `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph` |

Important observed detail: the `Postload_Success` count row has a comment saying there
is no need to send a notification for passed rows, but the active cursor still sends
the success report whenever its count is greater than zero.

## Step 6: Start the Stage-3 Summary

Procedure started asynchronously:

```sql
[dswTDIR1].[dbo].[sp_Job_Memo_Postload_Notif_Summary]
```

SQL Agent job:

```text
Memo_Postload_P25_Notif_Summary_AdHoc
```

### Summary Timestamp

The procedure gets the report-send completion time from:

```sql
[etl_db].[dbo].[fn_GetLatestProccessedDate](
    'Memo',
    '[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Send]'
)
```

It falls back to the current date when no logged timestamp is returned.

### Summary Rows

The procedure globally truncates `MemoMigratePostloadTemp`, then inserts:

| Order | Process metric | Source |
| --- | --- | --- |
| 1 | `Postload Count` | Count of `ttMEMOAPP_Postload` |
| 2 | `Successfully Posted in SAP` | Count of `Memo_Postload_Line_Report_Prepare_Success_Cache` |
| 3 | `Failed to Post in SAP: Added To Memo Error Page` | Count of `Memo_Postload_Line_Report_Prepare_Failed_Cache` |
| 4 | `Discrepancy of Postload Records vs Line Items` | Row 1 minus the sum of rows 2 and 3 |

The subject changes when row 4 is nonzero:

| Condition | Subject prefix |
| --- | --- |
| Discrepancy is nonzero | `Report Notif: Memo RFP Completed w/ Discrepancies - Postload Transformation(Process Stage 3 of 3)` |
| Discrepancy is zero | `Report Notif: Memo RFP Successfully Processed - Postload Transformation(Process Stage 3 of 3)` |

The summary uses Database Mail profile `SSRS`, the same recipients as standard report
emails, and the same copy recipients.

Important observed detail: the summary label says failed rows were added to the Memo
error page. The failed cache itself is classified by `zLoaded <> 1`; routing into DCS
uses a separate insert selector and duplicate check.

## Related DCS Postload Workflow

The DCS postload is operationally related but is not part of the direct call chain from
`sp_Job_Memo_Postload`.

### Upstream DCS Preload Handoff

Before DCS postload runs, the separately scheduled DCS preload transform:

```sql
[dswTDIR1].[dbo].[sp_Memo_Preload_DCS_Transform]
```

globally deletes `ttMEMOAPP_DCS_Postload`, then inserts approved cleansing-page rows
from `dcMemoApp`.

The approved-row selector requires:

```text
zLoaded = 0
zError_LineItem_DCS = 0
zError_Counter_DCS = 0
zDisabled_LineItem = 0
zDisabled_Counter = 0
zCleansingPeriodClosed = 0
zApprovalStatus = Counter Approved
boaStatus IN (0, 4, 3) OR boaStatus IS NULL
```

The selected counter must also appear in a `dcMemoApp` subquery whose rows are not
disabled and whose `boaStatus` is allowed or null.

### DCS Postload Entry Chain

The scheduled DCS parent is:

```sql
[dswTDIR1].[dbo].[sp_Job_Memo_Postoad_DCS]
```

It logs with step `Postload - DCS` and runs:

| Order | Procedure | Role |
| --- | --- | --- |
| 1 | `sp_Memo_Postload_DCS_LoadSapTables` | Refresh SAP upload-log delta |
| 2 | `sp_Memo_Postoad_DCS_Transform` | Mark DCS posting outcomes |
| 3 | `sp_Memo_Postoad_DCS_Report_Prepare` | Refresh DCS report caches |
| 4 | `sp_Memo_Postoad_DCS_Report_Export` | Trigger DCS SSRS workbook exports |
| 5 | `sp_Memo_Postoad_DCS_Report_Send` | Email nonempty DCS reports |

### DCS Status Updates

`sp_Memo_Postoad_DCS_Transform` runs:

| Order | Procedure | Behavior |
| --- | --- | --- |
| 1 | `trMEMOAPP_DCS_Postload_zLoaded_ttMEMOAPP_DCS_Postload_1Upd` | Marks `ttMEMOAPP_DCS_Postload.zLoaded = 1` when latest SAP logs match order plus unique key, message contains `SUCCES` or `Posted`, and row is not disabled |
| 2 | `trMEMOAPP_DCS_Postload_zLoaded_Upd` | Marks `dcMemoApp.zLoaded = 1` under the same SAP success conditions for rows still unloaded, enabled, and `Counter Approved` |
| 3 | `trMEMOAPP_DCS_Postload_zError_Message_Upd` | Writes latest SAP failure text to `dcMemoApp`, resets workflow approvals to draft/unsubmitted/unapproved, sets `boaStatus = 0`, stamps `ChangedBy = 'DSP_Process_Postload'`, and stamps current change time |

The DCS failure update requires:

```text
SAP message does not contain SUCCES
SAP message does not contain Posted
Z_PROG_NAME = ZRFFI_UPLOAD_OPEN_BAL
dcMemoApp.zLoaded = 0
dcMemoApp.zDisabled_LineItem = 0
dcMemoApp.zApprovalStatus = Counter Approved
```

### DCS Reports

DCS report selectors read `ttMEMOAPP_DCS_Postload`:

| Report | Selector condition | Cache |
| --- | --- | --- |
| `Postload_DCS_Failed` | `zLoaded = '0'` | `Memo_Postoad_DCS_Report_Prepare_Failed_Cache` |
| `Postload_DCS_Success` | `zLoaded = '1'` | `Memo_Postoad_DCS_Report_Prepare_Success_Cache` |

The DCS export procedure deletes fixed `.xlsx` files and triggers SSRS subscriptions
the same way as standard postload, but its polling loop stops at iteration `25`.
With a three-second delay, its timeout is approximately 72 seconds after the initial
check, not five minutes.

The DCS report-send procedure emails each nonempty DCS report through profile `SSRS`.
Its active copy recipients are:

```text
wmadiano@globe.com.ph;neevangelista@globe.com.ph
```

Unlike standard report emails, the DCS copy list does not include
`isg-eso-support@globe.com.ph`.

## Historical References

Historical reference: `ESTSS` contains older Memo postload summary procedures:

```text
sp_MemoMigratePostload_SendMail
sp_MemoMigratePostload_SendMail_DSP
sp_MemoMigratePostload_SendMail_SQL
```

Those procedures use older DSP process-log tables and alternate mail behavior. They
are not invoked by `dswTDIR1.dbo.sp_Job_Memo_Postload`.

Historical reference: `dswTDIR1.dbo.sp_Memo_Postload_Report_Send_02_DSP` is an
alternate report-mail procedure with a `[Memo Beta]` subject. It is not called by the
active standard entry procedure.

Historical reference: both correctly spelled and typo-preserving DCS transform
procedures exist:

```text
sp_Memo_Postload_DCS_Transform
sp_Memo_Postoad_DCS_Transform
```

The active SQL Agent parent calls the typo-preserving `sp_Memo_Postoad_DCS_Transform`.

## Business Logic Summary

- Standard postload has no runtime parameters and rebuilds a global work table.
- Only preload rows with `zError_Counter = 0` enter standard postload.
- SAP logs are refreshed from the last one day through linked server `SAP_S4`.
- SAP unique keys are normalized before local delta insertion.
- Standard success matching uses latest logs, DSP order, unique key, and message
  substrings `SUCCES` or `Posted`.
- Standard failure matching uses the raw log wrapper, exact unique key, non-success
  message, and SAP program `ZRFFI_UPLOAD_OPEN_BAL`.
- Every unresolved row absent from DCS by legacy key and source is inserted into the
  cleansing page as `Draft` with `boaStatus = 1`.
- Standard failed and success report caches are globally truncated and rebuilt.
- Standard SSRS report exports use fixed workbook names and a fixed report folder.
- Standard report mail sends both failed and successful workbook attachments when
  their counts are nonzero.
- The final Process Stage 3 of 3 summary runs asynchronously.
- DCS postload is a separately scheduled reconciliation pass for operator-approved
  cleansing-page rows.
- No postload SFTP step is present in the active chain.

## Operational Risks and Gaps

### 1. Standard Postload Is Global, Not Run-Isolated

`ttMEMOAPP_Postload`, report caches, and summary staging are deleted or truncated
globally. Concurrent runs can overwrite each other's work and report output.

### 2. Input Selection Can Reprocess Retained Preload Rows

The postload input selector filters only `ttMEMOAPP_Preload.zError_Counter = 0`.
It has no date, filename, scenario, or run identifier. Any retained preload rows
continue to participate in a later postload rebuild.

### 3. SAP Delta Refresh Reads Only the Last One Day

`sp_ZFFI_REPORT_ODBC_Delta` queries SAP logs from the previous one day. Older local
rows remain available, but a missing or delayed refresh outside that window may leave
postload without the expected SAP result.

### 4. Success and Failure Matchers Use Different Contracts

Standard success uses latest logs and matches order plus key. Standard failure reads
the raw log wrapper and matches only key. If multiple SAP log rows share a key, the
failure update can be ambiguous or apply a stale message.

### 5. Success Report Join Is Not Latest-Log Scoped

The success-cache loader left joins raw SAP logs by unique key only. Multiple SAP log
rows for one key can duplicate cache output or surface a nonlatest message.

### 6. Unresolved Rows Are Routed Without Requiring SAP Failure Text

The active DCS insert selector does not require `zErrorMessage_Load IS NOT NULL`.
Rows can appear on the cleansing page before a specific SAP failure message is
captured.

### 7. DCS Is a Cross-Database Runtime Dependency

`dswTDIR1.dbo.dcMemoApp` is a view over `DCSTDIR1.dbo.dcMemoApp`. Standard transform
success depends on write access and availability across that database boundary.

### 8. Summary Job Is Fire-and-Forget

The standard parent starts `Memo_Postload_P25_Notif_Summary_AdHoc` asynchronously and
does not check its result. A successful parent status does not prove that Stage 3
summary mail was sent.

### 9. SSRS Uses Shared Filenames and Fixed Waits

Both standard and DCS report exports delete fixed workbook files through
`xp_cmdshell`, trigger shared subscriptions, and use polling timeouts. Overlapping runs
or slow SSRS generation can produce missing or stale attachments.

### 10. DCS Naming Typos Are Operationally Significant

The active DCS procedure and cache names use `Postoad`. Automation or manual support
queries using corrected spelling can target inactive or nonexistent objects.

### 11. DCS Preload Rebuilds Its Postload Table Globally

The upstream DCS preload transform deletes all rows from `ttMEMOAPP_DCS_Postload`
before reinserting approved cleansing records. Concurrent DCS runs can race with DCS
postload reconciliation and report generation.

### 12. Pipeline Metadata Omits Required Runtime Dependencies

`etl_pipelines.txt` leaves the Memo SQL Agent job section empty and does not list
several runtime databases and services. Operators must use `sql-agent-jobs.txt` and
the SQL source together.

### 13. Inactive Alternate Procedures Increase Support Ambiguity

The repository retains older `ESTSS` mail procedures, alternate DSP send procedures,
alternate no-pipe matchers, and both corrected and typo-preserving DCS transforms.
Production support should confirm the active entry chain before executing helpers
manually.

## Validation Checklist

Before relying on or changing a standard postload run:

- Confirm the standard preload completed before `Memo_Postload_P20_WkDays` starts at
  `3:55 PM`.
- Confirm preload export and SFTP delivery completed and SAP had time to process the
  upload files.
- Confirm `ttMEMOAPP_Preload` contains only the expected current workload or account
  for retained rows.
- Compare `ttMEMOAPP_Preload` rows with `zError_Counter = 0` to the expected
  `ttMEMOAPP_Postload` rebuild count.
- Verify linked server `SAP_S4` is reachable.
- Verify `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta` completed and refreshed the
  expected last-one-day SAP log rows.
- Inspect SAP-log duplicates by `zDSP_UniqueKey`, `zDSP_Order`, `Z_PROG_NAME`, and
  `Z_LINE_ITEM`.
- Verify successful postload rows match latest SAP messages containing `SUCCES` or
  `Posted`.
- Verify failed rows have the expected SAP `zErrorMessage_Load`.
- Compare unresolved postload rows with new `DCSTDIR1.dbo.dcMemoApp` draft rows.
- Verify no concurrent standard or DCS Memo job is rebuilding shared tables.
- Compare failed-cache plus success-cache counts with the total postload count.
- Verify `Postload_Failed.xlsx` and `Postload_Success.xlsx` were regenerated when their
  counts are nonzero.
- Verify SSRS subscriptions `Postload_Failed` and `Postload_Success` exist in
  `ReportServer$DACPRD`.
- Verify report emails include the expected attachments.
- Verify `Memo_Postload_P25_Notif_Summary_AdHoc` completed successfully and reported
  zero unexplained discrepancy.
- Monitor DCS jobs separately at `4:05 PM` and `7:35 PM`.
- For DCS runs, verify approved cleansing rows were loaded into
  `ttMEMOAPP_DCS_Postload` and that `Postload_DCS_Failed` plus
  `Postload_DCS_Success` counts match the DCS postload table.

## High-Level Data Flow

```text
Upstream Memo preload
    |
    +--> dswTDIR1.dbo.ttMEMOAPP_Preload
    |
    +--> SAP posting files and preload SFTP
              |
              v
        SAPPRD.ZFFI_REPORT_ODBC
              |
              | OPENQUERY([SAP_S4]) last one day
              v
dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC
              |
              v
dswTDIR1.dbo.sp_Job_Memo_Postload
    |
    +--> refresh SAP upload-log delta
    |
    +--> delete and rebuild dswTDIR1.dbo.ttMEMOAPP_Postload
    |       |
    |       +--> zLoaded = 1 for SAP success / posted rows
    |       |
    |       +--> zErrorMessage_Load for SAP failure rows
    |       |
    |       +--> unresolved rows inserted through dswTDIR1.dbo.dcMemoApp
    |                         |
    |                         v
    |                  DCSTDIR1.dbo.dcMemoApp
    |
    +--> rebuild standard failed and success report caches
    |
    +--> xp_cmdshell delete fixed SSRS workbooks
    |
    +--> ReportServer$DACPRD.dbo.AddEvent
    |
    +--> msdb.dbo.sp_send_dbmail report attachments
    |
    +--> msdb.dbo.sp_start_job
             |
             v
        Memo_Postload_P25_Notif_Summary_AdHoc
             |
             v
        Process Stage 3 of 3 summary email

Separately scheduled DCS path:

DCSTDIR1.dbo.dcMemoApp approved counters
    |
    v
dswTDIR1.dbo.sp_Memo_Preload_DCS_Transform
    |
    +--> delete and rebuild dswTDIR1.dbo.ttMEMOAPP_DCS_Postload
    |
    v
dswTDIR1.dbo.sp_Job_Memo_Postoad_DCS
    |
    +--> refresh SAP upload-log delta
    +--> mark DCS success and failure state
    +--> rebuild DCS report caches
    +--> trigger Postload_DCS_Failed / Postload_DCS_Success subscriptions
    +--> email nonempty DCS reports
```
