# sp_Job_MyBSS_Bayan_EOM_Postload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_All`

Execution starts on `sp_Job_MyBSS_Bayan_EOM_Postload_All`. The procedure is the parent postload orchestrator for Bayan end-of-month MyBSS DP2, DP3, and DP4 flows. It starts three SQL Agent ad hoc jobs and waits for each one to finish before starting the next job.

This document also covers the child postload procedures, SAP latest-log refresh, loaded-status update rules, SQL Agent context, setup cleanup context, report cache generation, SSRS subscription triggers, and email notification flow. It does not document the full preload transform logic except where the postload flow depends on preload output tables.

## Executive Summary

`sp_Job_MyBSS_Bayan_EOM_Postload_All` does not transform source extracts directly. It runs after the matching EOM preload has built `ttBayan_Unearned_MSF`, `ttBayan_Unbilled_Char`, and `ttBayan_Unbilled_Adj`, exported SAP load files, and SAP has attempted to post those files. The postload process assumes those target tables and SAP latest logs already represent the current EOM run.

At a high level, the procedure:

1. Starts the DP2 Unearned MSF postload SQL Agent job.
2. Waits for the DP2 job to show a stop time in SQL Agent activity.
3. Starts the DP3 Unbilled Charges postload SQL Agent job.
4. Waits for the DP3 job to show a stop time.
5. Starts the DP4 Unbilled Adjustments postload SQL Agent job.
6. Waits for the DP4 job to show a stop time.
7. Each child job refreshes SAP reference/latest-log tables, updates `zLoaded` on matched successful detail rows, rebuilds valid/error report caches, triggers SSRS Excel subscriptions, and sends report emails for nonempty caches.

There is no date, cycle, bill-cycle, posting-period, or run-id parameter. Runtime scope is global to the three EOM target tables and their report caches.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOM_Postload_All.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Child postload jobs:

- `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unearned_MSF.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Char.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Adj.StoredProcedure.sql`

SAP/latest-log refresh and loaded-status procedures:

- `dbo.sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Transform.StoredProcedure.sql`
- `dbo.trBayan_Unearned_MSF_zloaded_Upd.StoredProcedure.sql`
- `dbo.trBayan_Unbilled_Char_zloaded_Upd.StoredProcedure.sql`
- `dbo.trBayan_Unbilled_Adj_zloaded_Upd.StoredProcedure.sql`
- Matching `dbo.trBayan_*_zloaded_UpdSel.View.sql` files

Report cache, export, and email procedures:

- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Prepare.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Error.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Valid.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Send.StoredProcedure.sql`
- Equivalent `Unbilled_Char` and `Unbilled_Adj` postload report procedures

Important tables and views:

- `dswTDIR2_Bayan/tables/dbo.ttBayan_Unearned_MSF.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.ttBayan_Unbilled_Char.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.ttBayan_Unbilled_Adj.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.rpt_Postload_Report_*_Cache.Table.sql`
- `dbo.tvBayan_Unearned_MSF_PostLoad_ErrorRptSel.View.sql`
- `dbo.tvBayan_Unearned_MSF_PostLoad_ValidRptSel.View.sql`
- `dbo.tvBayan_Unbilled_Char_PostLoad_ErrorRptSel.View.sql`
- `dbo.tvBayan_Unbilled_Char_PostLoad_ValidRptSel.View.sql`
- `dbo.tvBayan_Unbilled_Adj_Postload_ErrorRptSel.View.sql`
- `dbo.tvBayan_Unbilled_Adj_Postload_ValidRptSel.View.sql`
- `dbo.ZFFI_REPORT_ODBC.View.sql`
- `dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`

SSRS dataset procedures:

- `dbo.sp_rpt_Bayan_Postload_Unearned_MSF_Error_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_Bayan_Postload_Unearned_MSF_Valid_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_Bayan_Postload_Unbilled_Char_Error_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_Bayan_Postload_Unbilled_Char_Valid_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_Bayan_Postload_Unbilled_Adj_Error_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_Bayan_Postload_Unbilled_Adj_Valid_SSRS.StoredProcedure.sql`

Setup, upstream preload, and helper context:

- `sdbTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Preload_DP2_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Preload_DP3_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOM_Preload_DP4_SFTP.StoredProcedure.sql`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta.StoredProcedure.sql`
- `etl_db.dbo.fn_IsJobCompleted.UserDefinedFunction.sql`
- `etl_db.dbo.vw_SqlJobs.View.sql`
- `etl_db.dbo.sp_ExecuteQueryAndLog.StoredProcedure.sql`

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Bayan` | EOM SSIS landing/extract tables and the setup cleanup procedure. |
| `dswTDIR2_Bayan` | Parent and child postload procedures, target tables, SAP wrapper views, report cache tables, SSRS dataset procedures, and report orchestration. |
| `dgS4HANA_TDIR1` | SAP reference and latest-log data, including `ZTF0001S`, `ZTF0002S`, and `ZFFI_REPORT_ODBC`. |
| `SAP_S4` linked server | SAP S/4HANA ODBC source used by `sp_ZFFI_REPORT_ODBC_Delta` through `OPENQUERY`. |
| `etl_db` | SQL Agent job lookup, job-completion polling, procedure execution logging, and related preload SFTP/export helpers. |
| `msdb` | Starts child SQL Agent jobs and sends email through Database Mail. |
| `ReportServer$DACPRD` | SSRS subscription lookup and timed-subscription event queue. |
| Windows file system | SSRS Excel report output under `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\...`. |
| `xp_cmdshell` | Deletes existing `.xlsx` report files before triggering SSRS subscriptions. |

Important helper procedures and functions:

- `msdb.dbo.sp_start_job`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`
- `ReportServer$DACPRD.dbo.AddEvent`
- `msdb.dbo.sp_send_dbmail`

The local Bayan wrapper views `ZTF0001S`, `ZTF0002S`, `ZFFI_REPORT_ODBC`, and `ZFFI_REPORT_ODBC_LATESTLOGS` read from `dgS4HANA_TDIR1` and filter `MANDT = N'300'`.

## SQL Agent Context

The relevant SQL Agent chain in `sql-agent-jobs.txt` is:

| Job | Schedule | Step pattern |
| --- | --- | --- |
| `MyBSS_Bayan_EOM_00_P01_Setup_Cleanup_03Mth` | Monthly, every 3rd at 9:00 AM | Runs `sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03`. |
| `MyBSS_Bayan_EOM_00_P02_Extract_03Mth` | Monthly, every 3rd at 11:20 AM | Runs eight SSIS extract packages into `sdbTDIR2_Bayan`. |
| `MyBSS_Bayan_EOM_00_P10_Preload_All_03Mth` | Monthly, start date `2023-09-01 11:30:00` | Runs `sp_Job_MyBSS_Bayan_EOM_Preload_All`. |
| `MyBSS_Bayan_EOM_00_P20_Postload_All_03Mth` | Monthly, start date `2023-09-01 13:30:00` | Runs `sp_Job_MyBSS_Bayan_EOM_Postload_All`. |

The postload parent starts these ad hoc child jobs:

| Child job | Command | Schedule |
| --- | --- | --- |
| `MyBSS_Bayan_EOM_DP2_P20_Postload_UMSF_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_Postload_Unearned_MSF]` | No schedule / unknown |
| `MyBSS_Bayan_EOM_DP3_P20_Postload_UC_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Char]` | No schedule / unknown |
| `MyBSS_Bayan_EOM_DP4_P20_Postload_UA_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Adj]` | No schedule / unknown |

The extract job that feeds the related preload includes:

- `MyBss_Bayan_307_Unbilled_Adjustments_Report`
- `MyBss_Bayan_317_Unbilled_Charges_Summary_Report`
- `MyBss_Bayan_317_Unbilled_Charges_Summary_Report_V2(RowStartsAtRow5)`
- `MyBss_Bayan_324_Unearned_MSF_Summary_Report`
- `MyBss_Bayan_sap_airc`
- `MyBss_Bayan_sap_aiuc`
- `MyBss_Bayan_sap_glunbilled`
- `MyBss_Bayan_sap_glunbilled_unconf`

The postload parent does not run SSIS packages and does not start preload SFTP jobs. The related preload SFTP jobs are separate ad hoc jobs named `MyBSS_Bayan_EOM_DP2_P15_Preload_UMSF_SFTP_AdHoc`, `MyBSS_Bayan_EOM_DP3_P15_Preload_UC_SFTP_AdHoc`, and `MyBSS_Bayan_EOM_DP4_P15_Preload_UA_SFTP_AdHoc`.

Important observed detail:

`etl_pipelines.txt` has an EOM Bayan section but leaves its SQL Agent job list blank. `sql-agent-jobs.txt` contains the operational EOM job chain. The same inventory file lists Bayan EOC postload labels with `P10_Postload` for most cycles and the typo `Postoad` for EOC08; those are bill-cycle metadata inconsistencies, not active EOM postload calls.

## Cleanup Process

`sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03` is not called by `sp_Job_MyBSS_Bayan_EOM_Postload_All`. It runs through the separate setup cleanup SQL Agent job before extract and preload.

It truncates:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Bayan` | `307_Unbilled_Adjustments_Report_B`, `317_Unbilled_Charges_B`, `324_Unearned_MSF_Summary_Report_B`, `sap_airc_B`, `sap_airc_unconf_B`, `sap_aiuc_B`, `sap_aiuc_unconf_B`, `sap_glunbilled_B`, `sap_glunbilled_unconf_B` |
| `dswTDIR2_Bayan` | `ttBayan_Unearned_MSF`, `ttBayan_Unbilled_Char`, `ttBayan_Unbilled_Adj` |

This cleanup is global, not cycle-scoped or period-scoped. Running it between preload and postload would remove the target rows that postload needs.

## Parameter Mapping

The parent and child EOM postload procedures have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / entity | Hard-coded through Bayan-specific procedures, target tables, report names, paths, and SAP source filters. |
| Domain | Hard-coded by job and procedure names: DP2 Unearned MSF, DP3 Unbilled Charges, DP4 Unbilled Adjustments. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable to the EOM postload procedures reviewed. |
| Run state | Global target tables, `zLoaded` flags, SAP latest logs, and global report cache tables. |

Report subscription and output naming:

| Domain | Subscription descriptions | Output directory |
| --- | --- | --- |
| DP2 Unearned MSF | `Bayn_UMSF_Postload_DP2_MMYY_Error`, `Bayn_UMSF_Postload_DP2_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unearned_MSF_SSRS` |
| DP3 Unbilled Charges | `Bayn_UC_Postload_DP3_MMYY_Error`, `Bayn_UC_Postload_DP3_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Char_SSRS` |
| DP4 Unbilled Adjustments | `Bayn_UA_Postload_DP4_MMYY_Error`, `Bayn_UA_Postload_DP4_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Adj_SSRS` |

`_MMYY` is replaced at runtime with the previous-month value. For example, a run in May 2026 would look for and write names ending in `_0426_Error` and `_0426_Valid`.

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable containing the three postload ad hoc SQL Agent job names.
3. Looks up those names in `etl_db.dbo.vw_SqlJobs`, which selects from `msdb.dbo.sysjobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each child job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the polling loop when the job shows a `stop_execution_date` or when the iteration limit is reached.
8. Moves to the next child job.

The parent does not call `etl_db.dbo.sp_ExecuteQueryAndLog` itself. Logging happens inside each child postload job for transform, report prepare, report export, and report send.

Child logging dimensions:

| Domain | `@Proccess` | `@ProcessGroup` | `@Step` | `@Others` |
| --- | --- | --- | --- | --- |
| DP2 | `MyBSS` | `Bayan` | `Unearned_MSF - Postload` | `EOM` |
| DP3 | `MyBSS` | `Bayan` | `Unbilled_Char - Postload` | `EOM` |
| DP4 | `MyBSS` | `Bayan` | `Unbilled_Adj - Postload` | `EOM` |

Important observed details:

- Missing child job names are skipped because the cursor uses an inner join to `etl_db.dbo.vw_SqlJobs`.
- `fn_IsJobCompleted` checks for a non-null `stop_execution_date`; it does not inspect SQL Agent success/failure status.
- The parent comment says `@MaxIteration = 60` equals `240 seconds or 5 mins`. With a 5-second wait, the implemented limit is approximately five minutes, and the `240 seconds` part of the comment is inconsistent.

## Step 1: Start DP2, DP3, and DP4 Postload Jobs

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_All`

The parent starts these jobs sequentially:

| Sequence | SQL Agent job | Child procedure | Domain |
| --- | --- | --- | --- |
| 1 | `MyBSS_Bayan_EOM_DP2_P20_Postload_UMSF_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unearned_MSF` | DP2 Unearned MSF |
| 2 | `MyBSS_Bayan_EOM_DP3_P20_Postload_UC_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Char` | DP3 Unbilled Charges |
| 3 | `MyBSS_Bayan_EOM_DP4_P20_Postload_UA_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Adj` | DP4 Unbilled Adjustments |

Because ordering is by job name, the current names naturally execute DP2, then DP3, then DP4.

## Step 2: Refresh SAP Tables and Latest Logs

Procedure:

`dswTDIR2_Bayan.dbo.sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables`

Each child postload job calls this procedure before its transform step. A full parent run therefore refreshes the same SAP tables/logs three times.

Called procedures:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`

`sp_ZTF0002S` and `sp_ZTF0001S` truncate and reload their local SAP reference tables from `vw_RT_ZTF0002S` and `vw_RT_ZTF0001S`. For this postload flow, the important active dependency is `ZFFI_REPORT_ODBC_LATESTLOGS`.

`sp_ZFFI_REPORT_ODBC_Delta` reads recent SAP `SAPPRD.ZFFI_REPORT_ODBC` rows through `OPENQUERY([SAP_S4], ...)`, limited to `Z_DATE >= current date - 1 day`. It keeps the latest row per `ZDSP_UNIQUEKEY`, `Z_PROG_NAME`, and `Z_LINE_ITEM`, deletes matching existing local rows by unique key, DSP order, and program name, then inserts the refreshed rows into `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` inside a transaction.

Important observed detail:

The SAP refresh is called directly by each child job and is not wrapped by `sp_ExecuteQueryAndLog`, unlike the transform/report steps.

## Step 3: DP2 Unearned MSF Postload

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unearned_MSF`

Call sequence:

1. `sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Transform`
3. `sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Prepare`
4. `sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Export`
5. `sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Report_Send`

### Loaded Status Update

`sp_MyBSS_Bayan_EOM_Postload_Unearned_MSF_Transform` calls `trBayan_Unearned_MSF_zloaded_Upd`.

That procedure updates the updatable view `trBayan_Unearned_MSF_zloaded_UpdSel`, setting `ttBayan_Unearned_MSF.zLoaded = 1` where:

- `ttBayan_Unearned_MSF.zDSP_Order = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER`
- `ttBayan_Unearned_MSF.zDSP_UniqueKey = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY`
- `ttBayan_Unearned_MSF.Column01 = '01'`
- SAP `Z_MESSAGE` does not contain any of these error fragments:
  - `does not exist for`
  - `is not allowed for characteristic`
  - `requires an assignment to a CO object`
  - `Error in document`
  - `is not found in table`

The transform only sets rows to loaded. It does not reset rows from `1` back to `0`.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unearned_MSF_Error_Cache` | `tvBayan_Unearned_MSF_PostLoad_ErrorRptSel` |
| `rpt_Postload_Report_Unearned_MSF_Valid_Cache` | `tvBayan_Unearned_MSF_PostLoad_ValidRptSel` |

Error report rows come from `ttBayan_Unearned_MSF` joined to latest SAP logs where `zLoaded = 0` and `Z_SOURCE_NAME = 'txBayan'`.

Valid report rows include:

- Detail rows where `zLoaded = 1` and latest SAP log source is `txBayan`.
- Non-detail rows where `Column01 <> '01'`.

The valid view casts `zDSP_UniqueKey` to `nvarchar(44)` with a comment saying it was added on `6/6/2022` to fix a truncation issue.

### Report Export and Email

The export procedure deletes existing files with:

`del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unearned_MSF_SSRS\{dynamicSubscriptionName}.xlsx`

It then triggers SSRS subscriptions through `ReportServer$DACPRD.dbo.AddEvent` and polls `ReportServer$DACPRD.dbo.Event` every 3 seconds, up to 25 iterations.

The send procedure counts rows in each cache and sends email only when the count is greater than zero.

## Step 4: DP3 Unbilled Charges Postload

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Char`

Call sequence:

1. `sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Transform`
3. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Report_Prepare`
4. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Report_Export`
5. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Report_Send`

### Loaded Status Update

`sp_MyBSS_Bayan_EOM_Postload_Unbilled_Char_Transform` calls `trBayan_Unbilled_Char_zloaded_Upd`.

The update rule matches `ttBayan_Unbilled_Char` to `ZFFI_REPORT_ODBC_LATESTLOGS` by `zDSP_Order` and `zDSP_UniqueKey`, requires `Column01 = '01'`, and excludes the same five SAP error-message fragments used by the DP2 update. Matching rows are set to `zLoaded = 1`.

### Report Cache

Report preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unbilled_Char_Error_Cache` | `tvBayan_Unbilled_Char_PostLoad_ErrorRptSel` |
| `rpt_Postload_Report_Unbilled_Char_Valid_Cache` | `tvBayan_Unbilled_Char_PostLoad_ValidRptSel` |

The error view uses an inner join to latest SAP logs and returns rows with `zLoaded = 0` and `Z_SOURCE_NAME = 'txBayan'`.

The valid view uses a left join to latest SAP logs and returns detail rows with `zLoaded = 1` and `Z_SOURCE_NAME = 'txBayan'`, plus non-detail rows where `Column01 <> '01'`. It also casts `zDSP_UniqueKey` to `nvarchar(44)`.

### Report Export and Email

The export and send pattern matches DP2, with these domain-specific names:

| Setting | Value |
| --- | --- |
| File directory | `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Char_SSRS` |
| Error subscription | `Bayn_UC_Postload_DP3_MMYY_Error` |
| Valid subscription | `Bayn_UC_Postload_DP3_MMYY_Valid` |
| Error cache count | `rpt_Postload_Report_Unbilled_Char_Error_Cache` |
| Valid cache count | `rpt_Postload_Report_Unbilled_Char_Valid_Cache` |

## Step 5: DP4 Unbilled Adjustments Postload

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_Unbilled_Adj`

Call sequence:

1. `sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Transform`
3. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Prepare`
4. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Export`
5. `sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Send`

### Loaded Status Update

`sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Transform` calls `trBayan_Unbilled_Adj_zloaded_Upd`.

The update rule matches `ttBayan_Unbilled_Adj` to `ZFFI_REPORT_ODBC_LATESTLOGS` by `zDSP_Order` and `zDSP_UniqueKey`, requires `Column01 = '01'`, and excludes the same five SAP error-message fragments. Matching rows are set to `zLoaded = 1`.

### Report Cache

Report preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unbilled_Adj_Error_Cache` | `tvBayan_Unbilled_Adj_Postload_ErrorRptSel` |
| `rpt_Postload_Report_Unbilled_Adj_Valid_Cache` | `tvBayan_Unbilled_Adj_Postload_ValidRptSel` |

The error view selects from `ttBayan_Unbilled_Adj` joined to latest SAP logs where `zLoaded = 0` and `Z_SOURCE_NAME = 'txBayan'`, or where `Column01 <> '01'`.

The valid view is notably different from DP2 and DP3. It reads from `tvBayan_Unbilled_Adj_PreloadRptSel`, not directly from `ttBayan_Unbilled_Adj`, and the `a.zLoaded = '1'` condition is commented out. Active filtering is:

- Latest SAP log `Z_SOURCE_NAME = 'txBayan'`, or
- `Column01 <> '01'`

It casts `zDSP_Order`, casts `zDSP_UniqueKey` to `nvarchar(44)`, casts SAP `Z_MESSAGE` to `nvarchar(max)`, and orders by `Column01`.

Important observed detail:

Because the DP4 valid selector does not actively filter on `zLoaded = 1`, detail rows with a latest `txBayan` SAP log can be placed in the valid cache even if the loaded-status update did not mark them loaded. This differs from DP2 and DP3.

### Report Export and Email

The export and send pattern matches DP2 and DP3, with these domain-specific names:

| Setting | Value |
| --- | --- |
| File directory | `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Adj_SSRS` |
| Error subscription | `Bayn_UA_Postload_DP4_MMYY_Error` |
| Valid subscription | `Bayn_UA_Postload_DP4_MMYY_Valid` |
| Error cache count | `rpt_Postload_Report_Unbilled_Adj_Error_Cache` |
| Valid cache count | `rpt_Postload_Report_Unbilled_Adj_Valid_Cache` |

## Business Logic Summary

- The EOM postload process has no input parameters. It operates on the current global contents of the three Bayan EOM target tables.
- Preload is expected to have already inserted rows into `ttBayan_Unearned_MSF`, `ttBayan_Unbilled_Char`, and `ttBayan_Unbilled_Adj`, with `zLoaded` defaulting to `0`.
- SAP latest-log refresh uses `sp_ZFFI_REPORT_ODBC_Delta`, which pulls recent SAP ODBC rows from the `SAP_S4` linked server and refreshes local `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC`.
- Loaded-status updates are detail-row only: all three `trBayan_*_zloaded_UpdSel` views require `Column01 = '01'`.
- Rows are marked loaded by matching both `zDSP_Order` and `zDSP_UniqueKey` to `ZFFI_REPORT_ODBC_LATESTLOGS`.
- A matched SAP log is treated as successful only when its message does not contain the five hard-coded error fragments.
- The postload transform does not reset `zLoaded` from `1` to `0`; reset depends on cleanup/preload rebuilding the target table.
- Error report selectors generally require a latest SAP log row. A target detail row with `zLoaded = 0` and no latest SAP log is not necessarily present in an error cache.
- DP2 and DP3 valid selectors require `zLoaded = 1` for detail rows; DP4 valid selector has the `zLoaded` condition commented out.
- Report cache tables are globally truncated and reloaded. There is no period partition or run-id isolation.
- Report export deletes the expected `.xlsx` file before triggering the matching SSRS subscription.
- Email send procedures only send reports whose cache row count is greater than zero.
- Emails use Database Mail profile `SSRS`, send to `princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph`, and copy `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph`.

## Operational Risks and Gaps

- The parent waits for job completion, not job success. `etl_db.dbo.fn_IsJobCompleted` only checks `msdb.dbo.sysjobactivity.stop_execution_date`, so a failed child job can still let the parent continue to the next domain.
- `etl_db.dbo.fn_IsJobCompleted` selects `TOP 1` from `msdb.dbo.sysjobactivity` without an `ORDER BY` or current-session filter. Completion polling can therefore depend on which activity row SQL Server returns.
- The parent has a fixed polling limit of about five minutes per child job. If a child is still running at the limit, the parent proceeds to the next job.
- Missing child jobs are silently skipped by the inner join to `etl_db.dbo.vw_SqlJobs`.
- The same SAP latest-log refresh runs three times in a full parent execution. DP2, DP3, and DP4 can observe different refreshed log windows if SAP logs change during the run.
- The SAP ODBC delta refresh only reads recent rows from the linked server (`Z_DATE >= current date - 1 day`). Late SAP postings outside that window may not be refreshed by this postload path.
- `zLoaded` is only set to `1`; the postload transform does not clear stale loaded flags. A rerun without cleanup or target reload can preserve earlier loaded state.
- The DP4 valid selector has the active `zLoaded = '1'` condition commented out. This can make DP4 valid reporting diverge from the transform's loaded-status classification.
- Error report selectors use joins to latest SAP logs, so rows without a matching latest log may be absent from both useful error detail and loaded-status updates.
- Report cache tables are globally truncated. Running reports concurrently or rerunning a domain can overwrite cache data used by another report export/send step.
- Report file deletion uses `xp_cmdshell` and hard-coded `F:\BOA\Transform\Report\...` paths. Missing directories, locked files, or disabled `xp_cmdshell` can break export preparation.
- SSRS polling has a fixed 25 iterations at 3 seconds each. If the report server takes longer, the procedure stops waiting while export may still be pending.
- Email send waits only 5 seconds before attaching the expected file. If SSRS export has not completed or produced the expected file name, Database Mail attachment sending can fail.
- The report period is derived from server `GETDATE()` minus one month, not from a batch parameter. Backfills and reruns outside the normal schedule will generate names for the previous calendar month at runtime.
- The setup cleanup job is global and destructive for postload prerequisites. Running it between preload and postload removes `ttBayan_*` rows needed for SAP status matching.

## Validation Checklist

- Confirm `MyBSS_Bayan_EOM_00_P01_Setup_Cleanup_03Mth`, extract, preload, and postload schedules still run in the intended order on the 3rd of the month.
- Confirm the related preload run completed and populated `ttBayan_Unearned_MSF`, `ttBayan_Unbilled_Char`, and `ttBayan_Unbilled_Adj` before postload starts.
- Check that the three postload ad hoc child jobs exist and are enabled in SQL Agent.
- Check that `etl_db.dbo.vw_SqlJobs` can see the child job names exactly as hard-coded in the parent procedure.
- Verify SAP posting logs are available in `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` and `ZFFI_REPORT_ODBC_LATESTLOGS` for source `txBayan`.
- Validate that `sp_ZFFI_REPORT_ODBC_Delta` can connect through `SAP_S4` and that recent SAP log rows fall within the one-day delta window.
- Before sending reports, compare `zLoaded` counts in all three target tables against the valid and error cache counts.
- Specifically validate DP4 Unbilled Adjustments because the valid selector does not require `zLoaded = 1`.
- Confirm SSRS subscriptions exist with the static descriptions containing `_MMYY`: `Bayn_UMSF_Postload_DP2_MMYY_*`, `Bayn_UC_Postload_DP3_MMYY_*`, and `Bayn_UA_Postload_DP4_MMYY_*`.
- Confirm the runtime previous-month `MMyy` suffix matches the reporting month intended for the run.
- Confirm output directories exist and old `.xlsx` files can be deleted by the SQL Server service account.
- Confirm `xp_cmdshell` is enabled if report export deletion depends on it.
- Confirm Database Mail profile `SSRS` can send attachments to the configured recipients.
- Review `etl_db.dbo.ProcessLogs` for child transform, report prepare, report export, and report send errors after each child job.
- Review SQL Agent history for actual child job success because the parent only waits for completion.

## High-Level Data Flow

```text
SQL Agent
  MyBSS_Bayan_EOM_00_P01_Setup_Cleanup_03Mth
    -> sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03
       -> global truncates in sdbTDIR2_Bayan and dswTDIR2_Bayan target tables

SQL Agent
  MyBSS_Bayan_EOM_00_P02_Extract_03Mth
    -> SSIS extracts into sdbTDIR2_Bayan

SQL Agent
  MyBSS_Bayan_EOM_00_P10_Preload_All_03Mth
    -> dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All
       -> ttBayan_Unearned_MSF
       -> ttBayan_Unbilled_Char
       -> ttBayan_Unbilled_Adj
       -> SAP preload files and related preload SFTP jobs

SQL Agent
  MyBSS_Bayan_EOM_00_P20_Postload_All_03Mth
    -> dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Postload_All
       -> start MyBSS_Bayan_EOM_DP2_P20_Postload_UMSF_AdHoc
       -> wait for SQL Agent stop_execution_date
       -> start MyBSS_Bayan_EOM_DP3_P20_Postload_UC_AdHoc
       -> wait for SQL Agent stop_execution_date
       -> start MyBSS_Bayan_EOM_DP4_P20_Postload_UA_AdHoc
       -> wait for SQL Agent stop_execution_date

Each child postload job
  -> sp_MyBSS_Bayan_EOM_Postload_000_LoadSapTables
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
     -> dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta
        -> SAP_S4 linked server
        -> dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC
        -> dswTDIR2_Bayan.dbo.ZFFI_REPORT_ODBC_LATESTLOGS
  -> trBayan_*_zloaded_Upd
     -> ttBayan_* zLoaded = 1 for matched successful SAP logs
  -> sp_MyBSS_Bayan_EOM_Postload_*_Report_Prepare
     -> truncate and reload rpt_Postload_Report_*_Error_Cache
     -> truncate and reload rpt_Postload_Report_*_Valid_Cache
  -> sp_MyBSS_Bayan_EOM_Postload_*_Report_Export
     -> xp_cmdshell delete old .xlsx
     -> ReportServer$DACPRD.dbo.AddEvent
     -> SSRS writes Excel report files under F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan
  -> sp_MyBSS_Bayan_EOM_Postload_*_Report_Send
     -> count cache rows
     -> msdb.dbo.sp_send_dbmail with .xlsx attachment for nonempty reports
```
