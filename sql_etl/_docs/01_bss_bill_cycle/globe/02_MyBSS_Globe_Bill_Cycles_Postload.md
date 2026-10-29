# sp_Job_MyBSS_Globe_EOC_Postload Reverse Engineering

Reverse engineered on 2026-05-08 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_Postload`

Execution starts on `sp_Job_MyBSS_Globe_EOC_Postload`. The document also covers the child procedures it calls through `etl_db.dbo.sp_ExecuteQueryAndLog`, the SAP log refresh and loaded-status logic, report cache generation, SSRS subscription triggers, email notification flow, and SQL Agent metadata for the EOC bill-cycle postload jobs.

## Executive Summary

`sp_Job_MyBSS_Globe_EOC_Postload` is the SQL orchestration layer for the MyBSS Globe EOC DP1 Billed Postload process. It runs after SAP has attempted to load the preload-generated DP1 billed interface file.

The postload process does not rebuild DP1 billed target rows, does not generate a new SAP load text file, and does not run SFTP. It consumes `ttGlobe_DP1_Billed` rows created by preload, refreshes SAP latest-log data, updates `zLoaded` flags using SAP feedback, rebuilds valid and error report cache tables for one bill cycle, triggers SSRS Excel exports, and emails the nonempty report output.

At a high level, the procedure:

1. Refreshes selected SAP reference/log tables from `dgS4HANA_TDIR1`.
2. Updates `ttGlobe_DP1_Billed.zLoaded` from SAP ODBC latest logs.
3. Resolves `@CycleCode` to a bill cycle such as `BC01`.
4. Rebuilds Globe DP1 billed postload valid and error cache tables for that bill cycle.
5. Triggers SSRS subscriptions for valid and error Excel reports.
6. Sends report emails according to the error/valid record-count rules.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOC_Postload.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Main subprocesses:

- `dbo.sp_MyBSS_Globe_EOC_Postload_LoadSapTables.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Transform.StoredProcedure.sql`
- `dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd.StoredProcedure.sql`
- `dbo.trGlobe_DP1_Billed_zLoaded_1Upd.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Report_Prepare.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Error.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Valid.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Report_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Postload_Report_Send.StoredProcedure.sql`

Important tables/views:

- `dswTDIR2_Globe/tables/dbo.BillCycles.Table.sql`
- `dswTDIR2_Globe/tables/dbo.ttGlobe_DP1_Billed.Table.sql`
- `dswTDIR2_Globe/tables/dbo.rpt_Postload_Report_DP1_Billed_Error_Cache.Table.sql`
- `dswTDIR2_Globe/tables/dbo.rpt_Postload_Report_DP1_Billed_Valid_Cache.Table.sql`
- `dswTDIR2_Globe/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dswTDIR2_Globe/views/dbo.Globe_DP1_Billed_zLoaded_0_CycleCode.View.sql`
- `dswTDIR2_Globe/views/dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpdSel.View.sql`
- `dswTDIR2_Globe/views/dbo.trGlobe_DP1_Billed_zLoaded_1UpdSel.View.sql`
- `dswTDIR2_Globe/views/dbo.tvGlobe_DP1_Billed_Cycle*_Postload_ErrorRptSel.View.sql`
- `dswTDIR2_Globe/views/dbo.tvGlobe_DP1_Billed_Cycle*_Postload_ValidRptSel.View.sql`
- `dbo.sp_rpt_tvGlobe_DP1_Billed_Postload_Error_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvGlobe_DP1_Billed_Postload_Valid_SSRS.StoredProcedure.sql`

Postload report prepare also reads EOC source-control staging tables:

- `sdbTDIR2_Globe/tables/dbo.sapglbilled_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.308_Billed_Adjustments_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.318_Billed_Charges_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.411_Bill_Control_ssis.Table.sql`

Historical reference:

- `dbo.sp_MyBSS_Globe_EOC_Postload_LoadOdbc_bak.StoredProcedure.sql`

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Globe` | SSIS landing/staging tables used by the postload reconciliation filter. |
| `dswTDIR2_Globe` | Postload orchestration, DP1 billed target rows, status update views/procedures, report cache tables, SAP wrapper views, and SSRS dataset procedures. |
| `dgS4HANA_TDIR1` | SAP reference tables and latest ODBC/load-log data. |
| `etl_db` | Execution logging through `sp_ExecuteQueryAndLog`; historical SQL Agent helper metadata in the inactive ODBC loader. |
| `ReportServer$DACPRD` | SSRS subscription lookup and event queue. |
| `msdb` | Database Mail through `sp_send_dbmail`; historical job starts in the inactive ODBC loader. |
| Windows file system | SSRS Excel output path on `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS`. |

Important helper procedures outside the Globe database:

- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`
- `ReportServer$DACPRD.dbo.AddEvent`
- `msdb.dbo.sp_send_dbmail`
- `xp_cmdshell`

## SQL Agent Context

The scheduled SQL Agent postload jobs are named like:

`MyBSS_Globe_EOC01_P20_Postload_12Mth`

Based on `sql-agent-jobs.txt`, each scheduled Globe EOC postload job has one T-SQL step that invokes:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_Postload @CycleCode`

through:

`etl_db.dbo.sp_ExecuteQueryAndLog`

The SQL Agent step uses these logging dimensions:

- System: `MyBSS`
- Company/entity: `Globe`
- Process: `DP1_Billed - Postload`
- Cycle: hard-coded per SQL Agent job, such as `EOC1`
- Procedure name and dynamic command text

The extracted SQL Agent metadata shows the postload jobs running monthly at `13:42:00`.

Important observed detail:

`etl_pipelines.txt` lists Globe postload labels with `P10_Postload` for most cycles and has a typo for EOC08 (`Postoad`). `sql-agent-jobs.txt` consistently uses `P20_Postload` for all Globe EOC postload jobs. Treat the live SQL Agent definition as the operational source of truth.

## Cycle Mapping

`dbo.BillCycles` defines the runtime columns `BillCycle`, `CycleCode`, `Description`, `RunDay`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName`, but the repository contains only the table schema, not seed rows. `Keyword_SSRS` is therefore a data-driven live-table dependency.

The postload procedures resolve `@CycleCode` through `BillCycles`. The following mapping is observed from `sql-agent-jobs.txt` and from the related Globe preload export procedure's hard-coded table variable:

| CycleCode | BillCycle | Job label | Scheduled day | Postload subscription pattern |
| --- | --- | --- | ---: | --- |
| `EOC1` | `BC01` | `12Mth` | 12 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC2` | `BC06` | `14Mth` | 14 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC3` | `BC08` | `15Mth` | 15 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC4` | `BC10` | `16Mth` | 16 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC5` | `BC11` | `17Mth` | 17 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC6` | `BC13` | `19Mth` | 19 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC7` | `BC16` | `21Mth` | 21 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC8` | `BC18` | `24Mth` | 24 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC9` | `BC21` | `26Mth` | 26 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC10` | `BC24` | `30Mth` | 30 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC11` | `BC27` | `02Mth` | 2 | `Glob_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |

Example subscription names are assembled as:

- `Glob_Billed_Postload_DP1{Keyword_SSRS}_Error`
- `Glob_Billed_Postload_DP1{Keyword_SSRS}_Valid`

The code comment gives this example:

`Glob_Billed_Postload_DP1_BC1_C1_Valid`

## Main Procedure Call Chain

`sp_Job_MyBSS_Globe_EOC_Postload @CycleCode`

1. `sp_MyBSS_Globe_EOC_Postload_LoadSapTables`
2. `sp_MyBSS_Globe_EOC_Postload_Transform`
3. `sp_MyBSS_Globe_EOC_Postload_Report_Prepare @CycleCode`
4. `sp_MyBSS_Globe_EOC_Postload_Report_Export @CycleCode`
5. `sp_MyBSS_Globe_EOC_Postload_Report_Send @CycleCode`

Every active child stored procedure is executed through `etl_db.dbo.sp_ExecuteQueryAndLog` with:

- System: `MyBSS`
- Company/entity: `Globe`
- Process: `DP1_Billed - Postload`
- Cycle: `@CycleCode`
- Procedure name and dynamic command text

Important observed detail:

The main procedure contains a commented-out "Update ODBC" block for `sp_MyBSS_Globe_EOC_Postload_LoadOdbc`. That procedure name is not present as an active SQL source file; only `sp_MyBSS_Globe_EOC_Postload_LoadOdbc_bak` exists. The active path refreshes ODBC/latest-log data through `sp_MyBSS_Globe_EOC_Postload_LoadSapTables`, which calls `sp_ZFFI_REPORT_ODBC_Delta`.

## Step 1: Load SAP Tables and Logs

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Postload_LoadSapTables`

This step has no cycle parameter. It refreshes SAP reference/log tables by calling:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`

Business purpose:

- `ZFFI_REPORT_ODBC`/latest logs provide SAP posting feedback used by postload.
- `ZTF0001S` and `ZTF0002S` are refreshed for consistency with the broader DP1 billed flow, though the postload status update and reports primarily depend on latest ODBC logs.

Local wrapper view:

`dbo.ZFFI_REPORT_ODBC_LATESTLOGS`

This view reads from `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` and filters:

`MANDT = '300'`

Historical reference:

`sp_MyBSS_Globe_EOC_Postload_LoadOdbc_bak` starts SQL Agent jobs named `SapS4Hana_ZFFI_REPORT_ODBC` and `SapS4Hana_ZTF0001S`, then polls `etl_db.dbo.fn_IsJobCompleted` every 3 seconds up to 100 iterations. This backup procedure is not in the active postload call chain.

## Step 2: Transform / Loaded Status Update

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Postload_Transform`

This procedure does not accept `@CycleCode`. The active implementation runs two generated update procedures:

1. `dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd`
2. `dbo.trGlobe_DP1_Billed_zLoaded_1Upd`

### Reset Cycles With SAP Errors

Procedure:

`dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd`

This updates through:

`dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpdSel`

The update sets:

`ttGlobe_DP1_Billed.zLoaded = '0'`

for rows whose `zLegacyCycle_Code` appears in:

`dbo.Globe_DP1_Billed_zLoaded_0_CycleCode`

The cycle-level error view joins `ttGlobe_DP1_Billed` to `ZFFI_REPORT_ODBC_LATESTLOGS` by:

- `ttGlobe_DP1_Billed.ZDSP_ORDER = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER`
- `ttGlobe_DP1_Billed.ZDSP_UNIQUEKEY = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY`

It groups by `zLegacyCycle_Code`, counts SAP messages, and keeps only cycles with at least one matched detail row where `Data = '01'` and `Z_MESSAGE` matches one of these error patterns:

- `%is not found%`
- `%requires an assignment to a CO object%`
- `%does not exist in chart of accounts%`
- `%Error in document%`
- `%not defined in chart of accounts%`
- `%not allowed for characteristic%`
- `%Balance in Transaction Currency%`

Important observed detail:

The reset is cycle-wide. If one detail row in a bill cycle has a recognized SAP error, the generated update sets `zLoaded = 0` for all rows in `ttGlobe_DP1_Billed` for that `zLegacyCycle_Code`.

### Mark Successful Detail Rows Loaded

Procedure:

`dbo.trGlobe_DP1_Billed_zLoaded_1Upd`

This updates through:

`dbo.trGlobe_DP1_Billed_zLoaded_1UpdSel`

The update sets:

`ttGlobe_DP1_Billed.zLoaded = '1'`

for detail rows where:

- A latest SAP log matches on `ZDSP_ORDER` and `ZDSP_UNIQUEKEY`.
- `Data = '01'`.
- `Z_MESSAGE` does not match the error patterns listed above.

Important observed details:

- The loaded-status update is not scoped by the `@CycleCode` passed to the entry procedure.
- The active transform runs the cycle-wide error reset first, then marks matching successful detail rows loaded.
- The update does not write `zLoad_Message`; report caches later read SAP `Z_MESSAGE` directly from latest-log views.
- Success classification is a negative text filter. If SAP introduces a new error message that does not match the listed patterns, a failed row can be marked loaded.

Historical reference:

`sp_MyBSS_Globe_EOC_Postload_Transform` contains a commented custom implementation that used `dgS4HANA_TDIR1.dbo.vw_RT_ZFFI_REPORT_ODBC` in a temp table and recoded the same two ideas inline. That block is not active.

## Step 3: Report Prepare

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Postload_Report_Prepare @CycleCode`

This resolves:

`@BillCycle = BillCycles.BillCycle WHERE CycleCode = @CycleCode`

Then it executes:

1. `sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Error @BillCycle`
2. `sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Valid @BillCycle`

There is no explicit validation or error if `@CycleCode` is missing from `BillCycles`.

### Reconciliation Filter Used by Both Caches

Both error and valid prepare procedures build the same CTE stack from these `sdbTDIR2_Globe` source tables:

| CTE/source | Purpose |
| --- | --- |
| `CTE_308_Billed_Adjustments_Header_Item` from `308_Billed_Adjustments_ssis` | Reads cycle header fields and billed adjustment item amounts. |
| `CTE_411_Bill_Control_G_Billed_Adjustment` from `411_Bill_Control_ssis` | Reads `Total Adjustments` and `Total Adjustment VAT`. |
| `CTE_318_Billed_Charges_Header_Item` from `318_Billed_Charges_ssis` | Reads cycle header fields and billed charge item amounts. |
| `CTE_411_Bill_Control_G_Billed_Charges` from `411_Bill_Control_ssis` | Reads rental, discount, traffic, VAS, onetime, overseas tax, surcharge, and VAT control totals. |
| `CTE_DP1_Billed_Control_Recon` | Builds control/reconciliation rows including `Billed Charges`, `Billed Adjustment`, and `sapglbilled`. |

The report rows are inserted only when the `sapglbilled` reconciliation difference is within the inclusive range:

`-100000.00 <= difference <= 100000.00`

The code parses `Column4` from the CTE with `parse(... as numeric(38, 2))`; comments show this replaced older `CAST` logic on July 15, 2022.

### Error Report Cache

Procedure:

`sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Error @BillCycle`

Cache table:

`rpt_Postload_Report_DP1_Billed_Error_Cache`

Behavior:

- Builds a temp table from `ttGlobe_DP1_Billed`.
- Joins directly to `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` on `zDSP_Order` and `zDSP_UniqueKey`.
- Filters `zLegacyCycle_Code = @BillCycle`.
- Applies the `sapglbilled` reconciliation threshold described above.
- Inserts rows where `zLoaded = '0'`.
- Deletes prior cache rows only for the current `BillCycle` before inserting the new result.

Inserted report columns:

- `Data`
- `Date` from `Posting_Date`
- `Brand` from `SAPFIGL`
- `Customer Type` from `CT`
- `Subscriber Type` from `ST`
- `Charge Code` from `CH_Code`
- `Discount Code` from `DP_Code`
- `Amount`, `Hits`, `UOM`, `WO Indicator`, `Cost Center`
- `GL` as a blank string
- `NB Indicator`, `Remarks`
- `zDSP_Order`
- `zDSP_UniqueKey`
- `Posting_Log_Message` from SAP `Z_MESSAGE`
- `BillCycle`

Important observed detail:

The error report prepare does not filter `Data = '01'`; it filters on `zLoaded = '0'` and requires a matching latest SAP log. The email step later counts only detail rows where `Data = '01'`.

### Valid Report Cache

Procedure:

`sp_MyBSS_Globe_EOC_Postload_Report_Prepare_DP1_Billed_Valid @BillCycle`

Cache table:

`rpt_Postload_Report_DP1_Billed_Valid_Cache`

Behavior:

- Uses the same source CTEs and reconciliation threshold as the error cache.
- Builds a temp table from `ttGlobe_DP1_Billed`.
- Joins directly to `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` on `zDSP_Order` and `zDSP_UniqueKey`.
- Filters `zLegacyCycle_Code = @BillCycle`.
- Inserts rows where `zLoaded = '1'`.
- Deletes prior cache rows only for the current `BillCycle` before inserting the new result.

Inserted columns are the same as the error cache, including `Posting_Log_Message`.

Important observed detail:

The cache prepare procedures use `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` directly, while the generated transform views use the local `dswTDIR2_Globe.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` wrapper view.

## Step 4: SSRS Dataset Procedures

The SSRS reports read from the postload cache tables.

Error dataset:

`sp_rpt_tvGlobe_DP1_Billed_Postload_Error_SSRS @CycleCode`

Behavior:

- Defaults `@BCCode` to `BC01`.
- Resolves `@BCCode = BillCycles.BillCycle WHERE CycleCode = @CycleCode`.
- Reads `rpt_Postload_Report_DP1_Billed_Error_Cache`.
- Filters `BillCycle = @BCCode`.
- Returns `Posting_Log_Message`.
- Orders by `Data`, then `zDSP_Order`.

Valid dataset:

`sp_rpt_tvGlobe_DP1_Billed_Postload_Valid_SSRS @CycleCode`

Behavior:

- Defaults `@BCCode` to `BC01`.
- Resolves `@BCCode = BillCycles.BillCycle WHERE CycleCode = @CycleCode`.
- Reads `rpt_Postload_Report_DP1_Billed_Valid_Cache`.
- Filters `BillCycle = @BCCode`.
- Returns `Posting_Log_Message`.
- Orders by `Data`, then `zDSP_Order`.

There are also direct cycle-specific views named like:

- `tvGlobe_DP1_Billed_Cycle1_Postload_ErrorRptSel`
- `tvGlobe_DP1_Billed_Cycle1_Postload_ValidRptSel`

Those views reproduce similar logic with hard-coded bill cycles such as `BC01`. The current postload prepare/export/send flow is cache-driven and parameterized by `@CycleCode`.

## Step 5: Report Export

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Postload_Report_Export @CycleCode`

This step triggers SSRS subscriptions to generate Excel files.

It resolves:

`@Keyword_SSRS = BillCycles.Keyword_SSRS WHERE CycleCode = @CycleCode`

Then it builds these SSRS subscription description names:

- `Glob_Billed_Postload_DP1{Keyword_SSRS}_Error`
- `Glob_Billed_Postload_DP1{Keyword_SSRS}_Valid`

For each matching subscription in `ReportServer$DACPRD.dbo.Subscriptions`:

1. Deletes the previous Excel file:
   - `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\{SubscriptionDescription}.xlsx`
2. Calls:
   - `ReportServer$DACPRD.dbo.AddEvent @EventType = 'TimedSubscription', @EventData = @SubsID`
3. Polls `ReportServer$DACPRD.dbo.Event` every 3 seconds.
4. Stops waiting after 25 iterations, or about 75 seconds.

Important observed detail:

The file delete uses `xp_cmdshell`:

`del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\{SubscriptionDescription}.xlsx`

The procedure triggers both valid and error subscriptions when matching SSRS subscriptions exist. Email rules later decide which generated files are mailed.

## Step 6: Report Send

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Postload_Report_Send @CycleCode`

This step emails generated report files through Database Mail profile `SSRS`.

It resolves:

- `@Keyword_SSRS`
- `@BillCycle`

Record-count rules:

| Report | Record count source |
| --- | --- |
| `Glob_Billed_Postload_DP1{Keyword_SSRS}_Error` | Detail rows in error cache for the current bill cycle where `Data = '01'`. |
| `Glob_Billed_Postload_DP1{Keyword_SSRS}_Valid` | Detail rows in valid cache for the current bill cycle where `Data = '01'`, but only when the error count is zero. |

Important observed detail:

The procedure comment states: "SAP Posting is All or Nothing". If at least one error detail row exists, `@ValidCount` remains zero and the valid report is not emailed, even if the valid cache contains rows.

Reports are emailed only when the computed detail record count is greater than zero.

Attachment path:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\{SubscriptionDescription}.xlsx`

Email subject:

`Report Notif: MyBSS {SubscriptionDescription} - {RecordCount} Record(s) Generated`

Recipients:

- `rosoldevilla@globe.com.ph`
- `rnvillar@globe.com.ph`

CC:

- `wmadiano@globe.com.ph`
- `neevangelista@globe.com.ph`
- `isg-eso-support@globe.com.ph`

The body is HTML and includes a Report Server link:

`http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx`

## Business Logic Summary

Core business behavior:

- The process starts on `sp_Job_MyBSS_Globe_EOC_Postload`.
- Active postload does not call SSIS packages, does not export SAP load text files, and does not SFTP files.
- Postload consumes `ttGlobe_DP1_Billed` rows created by preload.
- SAP feedback comes from ODBC latest-log data in `dgS4HANA_TDIR1`.
- Detail rows are identified by `Data = '01'` in the transform status update and in email record counts.
- SAP row matching uses `zDSP_Order` and `zDSP_UniqueKey`.
- If a cycle has at least one recognized SAP error message, `trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd` resets all rows for that cycle to `zLoaded = 0`.
- Matching successful detail rows are then marked `zLoaded = 1` when SAP `Z_MESSAGE` does not match known error text.
- Report preparation is cycle-scoped through `BillCycles`.
- Report cache rows require a matching latest SAP log.
- Report cache rows are generated only when the `sapglbilled` control reconciliation difference is within `+/-100000.00`.
- Postload valid and error report caches both include `Posting_Log_Message`.
- SSRS Excel files are generated through timed subscriptions.
- Report emails are sent only for nonzero detail counts.
- Valid report email is suppressed when any error detail row exists for the bill cycle.

## Operational Risks and Gaps

1. Loaded-status updates are not scoped to the input cycle.

   `sp_MyBSS_Globe_EOC_Postload_Transform` has no `@CycleCode` parameter. It can update `zLoaded` for any matching row in `ttGlobe_DP1_Billed`, not just the cycle being reported by the current job.

2. The cycle-wide reset can affect all rows in a cycle.

   If `Globe_DP1_Billed_zLoaded_0_CycleCode` finds one recognized error for a `zLegacyCycle_Code`, `trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd` sets `zLoaded = 0` for all target rows in that cycle before successful detail rows are marked loaded again.

3. Success classification depends on message text.

   Rows are marked loaded when SAP `Z_MESSAGE` does not match a fixed list of error substrings. New or changed SAP error text can be misclassified.

4. Report caches require matching latest SAP logs.

   The valid and error prepare procedures inner join to `vw_ZFFI_REPORT_ODBC_LATESTLOGS`. A target row with no matching latest log will not appear in either cache, even if its `zLoaded` flag is still zero.

5. Report visibility depends on the `sapglbilled` reconciliation threshold.

   Both caches require the `sapglbilled` control reconciliation difference to be between `-100000.00` and `100000.00`. If the difference is outside that range or cannot be parsed as numeric, expected postload rows may not be cached.

6. Active ODBC refresh differs from the commented orchestration.

   The main procedure has a commented `sp_MyBSS_Globe_EOC_Postload_LoadOdbc` block, but active code uses `sp_MyBSS_Globe_EOC_Postload_LoadSapTables` and `sp_ZFFI_REPORT_ODBC_Delta`. Verify that the delta loader has captured the SAP feedback needed for the cycle.

7. Report export uses a fixed wait.

   SSRS export waits up to about 75 seconds per subscription. If export is slower, the procedure continues, and email send may look for a missing or stale attachment.

8. Report files and report server are hard-coded.

   The Excel output path and report server link are environment-specific:

   - `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS`
   - `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx`

9. `xp_cmdshell` is required for housekeeping.

   `sp_MyBSS_Globe_EOC_Postload_Report_Export` deletes prior files through `xp_cmdshell`. SQL Server configuration and the execution/security context must allow it.

10. Valid email is intentionally suppressed when errors exist.

    The valid report can be generated by SSRS, but `sp_MyBSS_Globe_EOC_Postload_Report_Send` sets valid count only when error count is zero.

11. Job list metadata is inconsistent.

    `etl_pipelines.txt` has `P10_Postload` labels and a `Postoad` typo, while `sql-agent-jobs.txt` shows `P20_Postload` jobs. Verify live SQL Agent metadata before relying on pipeline comments.

## Validation Checklist

Before running or changing this process, verify:

- The matching Globe EOC preload job completed for the target cycle.
- SAP has attempted to load the preload-generated DP1 billed file.
- The target `BillCycles` row exists for the input `@CycleCode`.
- `BillCycles.Keyword_SSRS` is populated for the cycle.
- `ttGlobe_DP1_Billed` contains rows for the resolved `BillCycle`.
- Detail rows have populated `zDSP_Order` and `zDSP_UniqueKey`.
- `sp_ZFFI_REPORT_ODBC_Delta` has refreshed current SAP feedback.
- Latest SAP logs contain matching `ZDSP_ORDER`, `ZDSP_UNIQUEKEY`, and `Z_MESSAGE` values for the cycle's records.
- The `sapglbilled` reconciliation difference from `411_Bill_Control_ssis`, `318_Billed_Charges_ssis`, `308_Billed_Adjustments_ssis`, and `sapglbilled_ssis` is within `+/-100000.00`.
- `rpt_Postload_Report_DP1_Billed_Valid_Cache` and `rpt_Postload_Report_DP1_Billed_Error_Cache` are refreshed for the bill cycle.
- SSRS subscriptions exist for:
  - `Glob_Billed_Postload_DP1{Keyword_SSRS}_Valid`
  - `Glob_Billed_Postload_DP1{Keyword_SSRS}_Error`
- Excel files are generated in:
  - `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS`
- Database Mail profile `SSRS` is configured and can send attachments.
- The scheduled `13:42:00` postload start is late enough for SAP to finish processing the cycle's load file.

## High-Level Data Flow

```text
SQL Agent P20 Postload job
  -> dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_Postload @CycleCode
       -> refresh SAP reference/log tables
          -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
          -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
          -> dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta
       -> update loaded flags in ttGlobe_DP1_Billed
          -> trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd
          -> Globe_DP1_Billed_zLoaded_0_CycleCode
          -> trGlobe_DP1_Billed_zLoaded_1Upd
          -> ZFFI_REPORT_ODBC_LATESTLOGS
       -> resolve @CycleCode to BillCycle
       -> prepare postload report caches
          -> sdbTDIR2_Globe source/control staging tables
          -> rpt_Postload_Report_DP1_Billed_Error_Cache
          -> rpt_Postload_Report_DP1_Billed_Valid_Cache
       -> trigger SSRS Excel exports
          -> Glob_Billed_Postload_DP1{Keyword_SSRS}_Error
          -> Glob_Billed_Postload_DP1{Keyword_SSRS}_Valid
       -> send report emails for reports with nonzero detail counts
```
