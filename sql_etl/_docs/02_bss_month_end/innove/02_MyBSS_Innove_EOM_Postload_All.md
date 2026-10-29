# sp_Job_MyBSS_Innove_EOM_Postload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_All`

Execution starts on `sp_Job_MyBSS_Innove_EOM_Postload_All`. The procedure is the parent postload orchestrator for Innove end-of-month MyBSS DP2 Unearned MSF, DP3 Unbilled Charges, and DP4 Unbilled Adjustments. It starts three SQL Agent ad hoc jobs and waits for each job to show completion before starting the next one.

This document also covers the child postload procedures, SAP latest-log refresh, loaded-status update rules, SQL Agent context, setup cleanup context, report cache generation, SSRS subscription triggers, and email notification flow. It does not re-document the full EOM preload transform logic except where postload status, report selectors, or operational prerequisites depend on preload output tables.

## Executive Summary

`sp_Job_MyBSS_Innove_EOM_Postload_All` does not load source extracts directly. It runs after the Innove EOM setup, extract, preload, SAP file export, and preload SFTP flow has populated `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, and `ttInnove_Unbilled_Adj`, and after SAP has produced latest-log rows for the posted files.

At a high level, the procedure:

1. Starts the DP2 Unearned MSF postload SQL Agent job and waits for a SQL Agent stop time.
2. Starts the DP3 Unbilled Charges postload SQL Agent job and waits for a SQL Agent stop time.
3. Starts the DP4 Unbilled Adjustments postload SQL Agent job and waits for a SQL Agent stop time.
4. DP2 and DP4 refresh SAP reference/latest-log tables before their transform steps; the active DP3 child procedure does not call the SAP refresh procedure.
5. Each child job updates `zLoaded` from SAP latest logs, rebuilds valid/error report caches, triggers SSRS Excel subscriptions, and sends report emails for nonempty caches.
6. No active Innove EOM postload child procedure exports a SAP reversal file or starts a postload SFTP job.

There is no date, cycle, bill-cycle, posting-period, or run-id parameter. Runtime scope is global to the three Innove EOM target tables, SAP latest logs, report caches, and hard-coded filesystem/report paths.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Innove/programmability/stored_procedures/dbo.sp_Job_MyBSS_Innove_EOM_Postload_All.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Child postload jobs:

- `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unearned_MSF.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Char.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Adj.StoredProcedure.sql`

SAP/latest-log refresh and loaded-status procedures:

- `dbo.sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables.StoredProcedure.sql`
- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZFFI_REPORT_ODBC_Delta.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Transform.StoredProcedure.sql`
- `dbo.trInnove_Unearned_MSF_zloaded_Upd`, `dbo.trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd`, and matching views
- `dbo.trInnove_Unbilled_Char_zLoaded_1Upd`, `dbo.trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd`, and matching views
- `dbo.trInnove_Unbilled_Adj_zloaded_Upd`, `dbo.trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd`, and matching views

Report cache, export, send, and SSRS dataset procedures:

- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Prepare`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Error`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Valid`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Export`
- `dbo.sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Send`
- Equivalent `Unbilled_Char` and `Unbilled_Adj` postload report procedures
- `dbo.sp_rpt_Innove_Postload_Unearned_MSF_Error_SSRS`
- `dbo.sp_rpt_Innove_Postload_Unearned_MSF_Valid_SSRS`
- `dbo.sp_rpt_Innove_Postload_Unbilled_Char_Error_SSRS`
- `dbo.sp_rpt_Innove_Postload_Unbilled_Char_Valid_SSRS`
- `dbo.sp_rpt_Innove_Postload_Unbilled_Adj_Error_SSRS`
- `dbo.sp_rpt_Innove_Postload_Unbilled_Adj_Valid_SSRS`

Important tables and views:

- `sdbTDIR2_Innove/tables/dbo.307_Unbilled_Adjustments_Report_I.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.317_Unbilled_Charges_I.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.324_Unearned_MSF_Summary_Report_I.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.sap_airc_I.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.sap_aiuc_I.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.sap_glunbilled_i.Table.sql`
- `sdbTDIR2_Innove/tables/dbo.sap_glunbilled_unconf_I.Table.sql`
- `dswTDIR2_Innove/tables/dbo.stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I.Table.sql`
- `dswTDIR2_Innove/tables/dbo.stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I.Table.sql`
- `dswTDIR2_Innove/tables/dbo.stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i.Table.sql`
- `dswTDIR2_Innove/tables/dbo.ttInnove_Unearned_MSF.Table.sql`
- `dswTDIR2_Innove/tables/dbo.ttInnove_Unbilled_Char.Table.sql`
- `dswTDIR2_Innove/tables/dbo.ttInnove_Unbilled_Adj.Table.sql`
- `dswTDIR2_Innove/tables/dbo.rpt_Postload_Report_*_Cache.Table.sql`
- `dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dbo.tvInnove_Unearned_MSF_PostLoad_ErrorRptSel.View.sql`
- `dbo.tvInnove_Unearned_MSF_PostLoad_ValidRptSel.View.sql`
- `dbo.tvInnove_Unbilled_Char_PostLoad_ErrorRptSel.View.sql`
- `dbo.tvInnove_Unbilled_Char_PostLoad_ValidRptSel.View.sql`
- `dbo.tvInnove_Unbilled_Adj_Postload_ErrorRptSel.View.sql`
- `dbo.tvInnove_Unbilled_Adj_Postload_ValidRptSel.View.sql`
- `dbo.tvInnove_Unbilled_Adj_PreloadRptSel.View.sql`

Setup, upstream preload, and helper context:

- `sdbTDIR2_Innove/programmability/stored_procedures/dbo.sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Innove_EOM_Preload_All.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Preload_DP2_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Preload_DP3_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOM_Preload_DP4_SFTP.StoredProcedure.sql`
- `etl_db.dbo.sp_ExecuteQueryAndLog.StoredProcedure.sql`
- `etl_db.dbo.vw_SqlJobs.View.sql`
- `etl_db.dbo.fn_IsJobCompleted.UserDefinedFunction.sql`

Historical or inactive references:

- Innove EOC bill-cycle postload views and procedures such as `tvInnove_Billed_Cycle*_Postload_*RptSel`, which are not in the active EOM postload call chain.
- Innove EOM preload SFTP jobs, which are prerequisites/related upstream jobs but are not started by the active EOM postload procedures.

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Innove` | EOM SSIS landing/extract tables and the setup cleanup procedure. |
| `dswTDIR2_Innove` | Parent and child postload procedures, Innove target tables, SAP wrapper views, report cache tables, SSRS dataset procedures, and report orchestration. |
| `dswTDIR2_Innove_Cache` | Listed in `etl_pipelines.txt` for the Innove EOM pipeline. The reviewed active postload cache tables are scripted under `dswTDIR2_Innove`. |
| `dgS4HANA_TDIR1` | SAP reference and latest-log data, including `ZTF0001S`, `ZTF0002S`, `ZFFI_REPORT_ODBC`, and `ZFFI_REPORT_ODBC_LATESTLOGS`. |
| `SAP_S4` linked server | SAP S/4HANA ODBC source used by `sp_ZFFI_REPORT_ODBC_Delta` through `OPENQUERY`. |
| `etl_db` | SQL Agent job lookup, job-completion polling, procedure execution logging, and related preload export/SFTP helpers. |
| `msdb` | Starts child SQL Agent jobs and sends email through Database Mail. |
| `ReportServer$DACPRD` | SSRS subscription lookup and timed-subscription event queue. |
| Windows file system | SSRS Excel report output under `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\...`. |
| `xp_cmdshell` | Deletes existing `.xlsx` report files before triggering SSRS subscriptions. |

Important helper procedures and functions:

- `msdb.dbo.sp_start_job`
- `etl_db.dbo.vw_SqlJobs`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`
- `ReportServer$DACPRD.dbo.AddEvent`
- `msdb.dbo.sp_send_dbmail`
- `xp_cmdshell`

The local Innove wrapper view `dswTDIR2_Innove.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` reads from `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` and filters SAP client `MANDT = N'300'`.

## SQL Agent Context

The relevant Innove EOM SQL Agent chain in `sql-agent-jobs.txt` is:

| Job | Schedule | Command or package |
| --- | --- | --- |
| `MyBSS_Innove_EOM_00_P01_Setup_Cleanup_03Mth` | Monthly, every 3rd at 9:02 AM | `EXEC [dbo].[sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03]` |
| `MyBSS_innove_EOM_00_P02_Extract_03Mth` | Monthly, every 3rd at 11:15 AM | Runs seven SSIS extract packages into `sdbTDIR2_Innove`. |
| `MyBSS_Innove_EOM_00_P10_Preload_All_03Mth` | Monthly, start date `2023-09-01 11:35:00` | `EXEC [dbo].[sp_Job_MyBSS_Innove_EOM_Preload_All]` |
| `MyBSS_Innove_EOM_00_P20_Postload_All_03Mth` | Monthly, start date `2023-09-01 13:35:00` | `EXEC [dbo].[sp_Job_MyBSS_Innove_EOM_Postload_All]` |

The extract job includes these SSIS packages:

| Extract package | Target area |
| --- | --- |
| `MyBss_Innove_307_Unbilled_Adjustments_Report` | DP4 adjustment summary support. |
| `MyBss_Innove_317_Unbilled_Charges_Summary_Report` | DP3 charge summary support. |
| `MyBss_Innove_324_Unearned_MSF_Summary_Report` | DP2 unearned MSF summary support. |
| `MyBss_Innove_sap_airc` | DP2 SAP AIRC source. |
| `MyBss_Innove_sap_aiuc` | DP3 SAP AIUC source. |
| `MyBss_Innove_sap_glunbilled` | DP4 SAP GL unbilled source. |
| `MyBss_Innove_sap_glunbilled_unconf` | Unconfirmed SAP GL unbilled source extracted with the EOM group, but not used by the active DP2-DP4 postload parent. |

The parent postload job starts these child ad hoc postload jobs:

| Parent sequence | SQL Agent job | T-SQL command |
| ---: | --- | --- |
| 1 | `MyBSS_Innove_EOM_DP2_P20_Postload_UMSF_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Innove_EOM_Postload_Unearned_MSF];` |
| 2 | `MyBSS_Innove_EOM_DP3_P20_Postload_UC_AdHoc` | `EXEC  [dbo].[sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Char];` |
| 3 | `MyBSS_Innove_EOM_DP4_P20_Postload_UA_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Adj];` |

Related preload SFTP jobs exist, but there are no Innove EOM postload `P25` SFTP jobs listed in `sql-agent-jobs.txt`:

| Related preload SFTP job | Command |
| --- | --- |
| `MyBSS_Innove_EOM_DP2_P15_Preload_UMSF_SFTP_AdHoc` | `EXEC [dbo].[sp_MyBSS_Innove_EOM_Preload_DP2_SFTP];` |
| `MyBSS_Innove_EOM_DP3_P15_Preload_UC_SFTP_AdHoc` | `EXEC [dbo].[sp_MyBSS_Innove_EOM_Preload_DP3_SFTP];` |
| `MyBSS_Innove_EOM_DP4_P15_Preload_UA_SFTP_AdHoc` | `EXEC [dbo].[sp_MyBSS_Innove_EOM_Preload_DP4_SFTP];` |

Important observed details:

- `etl_pipelines.txt` lists "MyBSS Innove EOM (End of month)" with databases `sdbTDIR2_Innove`, `dswTDIR2_Innnove`, and `dswTDIR2_Innove_Cache`, but leaves the SQL Agent job list blank. The database name `dswTDIR2_Innnove` contains an extra `n`.
- The extract job name in `sql-agent-jobs.txt` uses lowercase `innove` in `MyBSS_innove_EOM_00_P02_Extract_03Mth`, while setup, preload, and postload jobs use `Innove`.
- `sql-agent-jobs.txt` lists the DP3 child postload job with two spaces after `EXEC`. The command is still a direct procedure call.

## Cleanup Process

The setup cleanup procedure is not called by `sp_Job_MyBSS_Innove_EOM_Postload_All`. It is run by its own SQL Agent job before extract and preload.

Procedure:

`sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03`

The cleanup truncates source extract tables and Innove target tables globally:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Innove` | `307_Unbilled_Adjustments_Report_I`, `317_Unbilled_Charges_I`, `324_Unearned_MSF_Summary_Report_I`, `sap_airc_I`, `sap_aiuc_I`, `sap_glunbilled_i`, `sap_glunbilled_unconf_I` |
| `dswTDIR2_Innove` | `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, `ttInnove_Unbilled_Adj` |

This cleanup is global, not cycle-scoped, period-scoped, or run-id scoped. Running it between preload and postload would remove the target rows that postload needs for SAP latest-log matching and report generation.

## Parameter Mapping

The parent and child EOM postload procedures have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / entity | Hard-coded through Innove-specific procedures, tables, report names, paths, and SAP source name `txInnove`. |
| Domain | Hard-coded by job and procedure names: DP2 Unearned MSF, DP3 Unbilled Charges, and DP4 Unbilled Adjustments. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable to the EOM postload procedures reviewed. |
| Run state | Global target tables, `zLoaded` flags, SAP latest logs, and global report cache tables. |

Report subscription and output naming:

| Domain | Subscription descriptions | Output directory |
| --- | --- | --- |
| DP2 Unearned MSF | `Inov_UMSF_Postload_DP2_MMYY_Error`, `Inov_UMSF_Postload_DP2_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unearned_MSF_SSRS` |
| DP3 Unbilled Charges | `Inov_UC_Postload_DP3_MMYY_Error`, `Inov_UC_Postload_DP3_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Char_SSRS` |
| DP4 Unbilled Adjustments | `Inov_UA_Postload_DP4_MMYY_Error`, `Inov_UA_Postload_DP4_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Adj_SSRS` |

`_MMYY` is replaced at runtime with the previous-month value for file deletion, file attachment, and generated report file names. The subscription lookup itself joins to SSRS `Subscriptions.Description` using the static template string that still contains `_MMYY`.

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable containing the three postload ad hoc SQL Agent job names.
3. Looks up those names in `etl_db.dbo.vw_SqlJobs`, which selects from `msdb.dbo.sysjobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each child job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the polling loop when the job shows a non-null `stop_execution_date` or when the iteration limit is reached.
8. Moves to the next child job.

The parent does not call `etl_db.dbo.sp_ExecuteQueryAndLog` itself. Logging happens inside each child postload job for transform, report prepare, report export, and report send.

Child logging dimensions:

| Domain | `@Proccess` | `@ProcessGroup` | `@Step` | `@Others` |
| --- | --- | --- | --- | --- |
| DP2 | `MyBSS` | `Innove` | `Unearned_MSF - Postload` | `EOM` |
| DP3 | `MyBSS` | `Innove` | `Unbilled_Char - Postload` | `EOM` |
| DP4 | `MyBSS` | `Innove` | `Unbilled_Adj - Postload` | `EOM` |

Important observed details:

- The variable name `@Proccess` is spelled with two `c` characters in the child procedures.
- Missing child jobs are skipped because the parent cursor uses an inner join to `etl_db.dbo.vw_SqlJobs`.
- `etl_db.dbo.fn_IsJobCompleted` checks for a non-null `stop_execution_date`; it does not inspect SQL Agent success/failure status.
- The parent comment says `@MaxIteration = 60` equals `240 seconds or 5 mins`. With a 5-second wait, the implemented limit is approximately five minutes, and the `240 seconds` part of the comment is inconsistent.

## Step 1: Start DP2, DP3, and DP4 Postload Jobs

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_All`

The parent starts these jobs sequentially:

| Sequence | SQL Agent job | Child procedure | Domain |
| ---: | --- | --- | --- |
| 1 | `MyBSS_Innove_EOM_DP2_P20_Postload_UMSF_AdHoc` | `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unearned_MSF` | DP2 Unearned MSF |
| 2 | `MyBSS_Innove_EOM_DP3_P20_Postload_UC_AdHoc` | `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Char` | DP3 Unbilled Charges |
| 3 | `MyBSS_Innove_EOM_DP4_P20_Postload_UA_AdHoc` | `dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Adj` | DP4 Unbilled Adjustments |

Because ordering is by job name, the current names naturally execute DP2, then DP3, then DP4.

## Step 2: Refresh SAP Tables and Latest Logs

Procedure:

`dswTDIR2_Innove.dbo.sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables`

The DP2 and DP4 child postload jobs call this procedure before their transform steps. The active DP3 child postload job does not call it. A full parent run therefore refreshes the same SAP reference/latest-log tables twice, once before DP2 and once before DP4.

Called procedures:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`

`sp_ZTF0002S` and `sp_ZTF0001S` refresh SAP reference tables. For this postload flow, the active status/report dependency is `ZFFI_REPORT_ODBC_LATESTLOGS`.

`sp_ZFFI_REPORT_ODBC_Delta` reads recent SAP `SAPPRD.ZFFI_REPORT_ODBC` rows through `OPENQUERY([SAP_S4], ...)`, limited to `Z_DATE >= current date - 1 day`. It trims control characters from `ZDSP_UNIQUEKEY`, keeps the latest row per `ZDSP_UNIQUEKEY`, `Z_PROG_NAME`, and `Z_LINE_ITEM`, deletes matching existing local rows by unique key, DSP order, and program name, then inserts refreshed rows into `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` inside a transaction.

Important observed detail:

The SAP refresh is called directly by DP2 and DP4 child jobs and is not wrapped by `sp_ExecuteQueryAndLog`, unlike the transform/report steps. DP3 relies on SAP latest-log state already available from a prior refresh or another run.

## Step 3: DP2 Unearned MSF Postload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unearned_MSF`

Call sequence:

1. `sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Transform`
3. `sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Prepare`
4. `sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Export`
5. `sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Report_Send`

### Loaded Status Update

`sp_MyBSS_Innove_EOM_Postload_Unearned_MSF_Transform` calls:

1. `trInnove_Unearned_MSF_zloaded_Upd`
2. `trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd`

The success update sets `ttInnove_Unearned_MSF.zLoaded = 1` through `trInnove_Unearned_MSF_zloaded_UpdSel` where:

- `ttInnove_Unearned_MSF.zDSP_Order = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER`
- `ttInnove_Unearned_MSF.zDSP_UniqueKey = ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY`
- `ttInnove_Unearned_MSF.Column01 = '01'`
- SAP `Z_MESSAGE` does not contain any of these error fragments:
  - `does not exist for`
  - `is not allowed for characteristic`
  - `requires an assignment to a CO object`
  - `Error in document`
  - `is not found in table`

The error reset sets `ttInnove_Unearned_MSF.zLoaded = 0` through `trInnove_Unearned_MSF_zLoaded_0_Error_LineUpdSel`. The underlying `Innove_Unearned_MSF_zLoaded_0_Error_Line` view matches detail rows to latest SAP logs, uses `OR` across the same five SAP error fragments, groups by `zSource`, and returns any source with at least one error. Every target row with that `zSource` is then reset to not loaded.

This means one SAP error detail row can mark every row from the same `zSource` as not loaded.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unearned_MSF_Error_Cache` | `tvInnove_Unearned_MSF_PostLoad_ErrorRptSel` |
| `rpt_Postload_Report_Unearned_MSF_Valid_Cache` | `tvInnove_Unearned_MSF_PostLoad_ValidRptSel` |

The error view selects from `ttInnove_Unearned_MSF` joined to latest SAP logs where `zLoaded = 0` and `Z_SOURCE_NAME = 'txInnove'`.

The valid view uses a left join to latest SAP logs and returns:

- Detail rows where `zLoaded = 1` and latest SAP log source is `txInnove`.
- Non-detail rows where `Column01 <> '01'`.

For non-detail rows, `zDSP_Order` is set to `NULL`. The valid selector casts `zDSP_UniqueKey` to `nvarchar(44)`.

### Report Export and Email

The export procedure deletes existing files with:

`del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unearned_MSF_SSRS\{dynamicSubscriptionName}.xlsx`

It then triggers SSRS subscriptions through `ReportServer$DACPRD.dbo.AddEvent` and polls `ReportServer$DACPRD.dbo.Event` every 3 seconds, up to 25 iterations.

The send procedure counts rows in each cache and sends email only when the count is greater than zero.

| Setting | Value |
| --- | --- |
| File directory | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unearned_MSF_SSRS` |
| Error subscription | `Inov_UMSF_Postload_DP2_MMYY_Error` |
| Valid subscription | `Inov_UMSF_Postload_DP2_MMYY_Valid` |
| Error cache count | `rpt_Postload_Report_Unearned_MSF_Error_Cache` |
| Valid cache count | `rpt_Postload_Report_Unearned_MSF_Valid_Cache` |

Emails use Database Mail profile `SSRS`, send to `harvey.tiong@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;princess.ortilano@globe.com.ph;jpdacquil@globe.com.ph`, and copy `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph`.

## Step 4: DP3 Unbilled Charges Postload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Char`

Call sequence:

1. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Transform`
2. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Report_Prepare`
3. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Report_Export`
4. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Report_Send`

Important observed detail:

Unlike DP2 and DP4, the active DP3 child procedure does not call `sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables`. When it runs as part of the parent, it follows the DP2 refresh. When it runs standalone, SAP latest-log freshness depends on some other process having already refreshed `dgS4HANA_TDIR1`.

### Loaded Status Update

`sp_MyBSS_Innove_EOM_Postload_Unbilled_Char_Transform` calls:

1. `trInnove_Unbilled_Char_zLoaded_1Upd`
2. `trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd`

The success update matches `ttInnove_Unbilled_Char` to `ZFFI_REPORT_ODBC_LATESTLOGS` by `zDSP_Order` and `zDSP_UniqueKey`, requires `Column01 = '01'`, and excludes the same five SAP error-message fragments used by DP2. Matching rows are set to `zLoaded = 1`.

The error reset uses `Innove_Unbilled_Char_zLoaded_0_Error_Line`, which groups SAP error matches by `zSource` and returns sources with at least one error. `trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd` then sets every `ttInnove_Unbilled_Char` row with that `zSource` to `zLoaded = 0`.

### Report Cache

Report preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unbilled_Char_Error_Cache` | `tvInnove_Unbilled_Char_PostLoad_ErrorRptSel` |
| `rpt_Postload_Report_Unbilled_Char_Valid_Cache` | `tvInnove_Unbilled_Char_PostLoad_ValidRptSel` |

The error view uses an inner join to latest SAP logs and returns rows with `zLoaded = 0` and `Z_SOURCE_NAME = 'txInnove'`.

The valid view uses a left join to latest SAP logs and returns detail rows with `zLoaded = 1` and `Z_SOURCE_NAME = 'txInnove'`, plus non-detail rows where `Column01 <> '01'`. For non-detail rows, `zDSP_Order` is set to `NULL`; `zDSP_UniqueKey` is cast to `nvarchar(44)`.

The cache tables carry `Column01` through `Column17`, `zDSP_Order`, `zDSP_UniqueKey`, and `Posting_Log_Message`.

### Report Export and Email

The export and send pattern matches DP2, with these domain-specific names:

| Setting | Value |
| --- | --- |
| File directory | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Char_SSRS` |
| Error subscription | `Inov_UC_Postload_DP3_MMYY_Error` |
| Valid subscription | `Inov_UC_Postload_DP3_MMYY_Valid` |
| Error cache count | `rpt_Postload_Report_Unbilled_Char_Error_Cache` |
| Valid cache count | `rpt_Postload_Report_Unbilled_Char_Valid_Cache` |

Emails use the same recipients, copy recipients, report-server link, Database Mail profile, and `COUNT(1) > 0` rule used by DP2.

## Step 5: DP4 Unbilled Adjustments Postload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_Unbilled_Adj`

Call sequence:

1. `sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Transform`
3. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Report_Prepare`
4. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Report_Export`
5. `sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Report_Send`

### Loaded Status Update

`sp_MyBSS_Innove_EOM_Postload_Unbilled_Adj_Transform` calls:

1. `trInnove_Unbilled_Adj_zloaded_Upd`
2. `trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd`

The success update matches `ttInnove_Unbilled_Adj` to `ZFFI_REPORT_ODBC_LATESTLOGS` by `zDSP_Order` and `zDSP_UniqueKey`, requires `Column01 = '01'`, and excludes the same five SAP error-message fragments. Matching rows are set to `zLoaded = 1`.

The error reset uses `Innove_Unbilled_Adj_zLoaded_0_Error_Line`, which groups SAP error matches by `zSource` and returns sources with at least one error. `trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd` then sets every `ttInnove_Unbilled_Adj` row with that `zSource` to `zLoaded = 0`.

### Report Cache

Report preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_Unbilled_Adj_Error_Cache` | `tvInnove_Unbilled_Adj_Postload_ErrorRptSel` |
| `rpt_Postload_Report_Unbilled_Adj_Valid_Cache` | `tvInnove_Unbilled_Adj_Postload_ValidRptSel` |

The error view selects from `ttInnove_Unbilled_Adj` joined to latest SAP logs where `zLoaded = 0` and `Z_SOURCE_NAME = 'txInnove'`, or where `Column01 <> '01'`. Because the join is an inner join, rows still need a latest-log match to appear.

The valid view is notably different from DP2 and DP3. It reads from `tvInnove_Unbilled_Adj_PreloadRptSel`, not directly from `ttInnove_Unbilled_Adj`, and the `a.zLoaded = '1'` condition is commented out. Active filtering is:

- Latest SAP log `Z_SOURCE_NAME = 'txInnove'`, or
- `Column01 <> '01'`.

`tvInnove_Unbilled_Adj_PreloadRptSel` unions detail rows from `tvInnove_Unbilled_Adj_Preload010RptSel` with a generated footer row where `Column01 = '99'`, `Column02` is the detail row count, and `Column03` is `SUM(TRY_PARSE(column07 AS decimal(38, 2)))` over detail rows.

Important observed detail:

Because the DP4 valid selector does not actively filter on `zLoaded = 1`, detail rows with a latest `txInnove` SAP log can be placed in the valid cache even if the loaded-status update did not mark them loaded. This differs from DP2 and DP3.

### Report Export and Email

The export and send pattern matches DP2 and DP3, with these domain-specific names:

| Setting | Value |
| --- | --- |
| File directory | `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Adj_SSRS` |
| Error subscription | `Inov_UA_Postload_DP4_MMYY_Error` |
| Valid subscription | `Inov_UA_Postload_DP4_MMYY_Valid` |
| Error cache count | `rpt_Postload_Report_Unbilled_Adj_Error_Cache` |
| Valid cache count | `rpt_Postload_Report_Unbilled_Adj_Valid_Cache` |

The DP4 valid selector casts `zDSP_UniqueKey` to `nvarchar(44)` with a source comment referencing truncation issue `INC0394837`. The valid cache table stores `Posting_Log_Message` as `nvarchar(1200)`, while the other Innove EOM postload caches use `nvarchar(1024)`.

Emails use the same recipients, copy recipients, report-server link, Database Mail profile, and `COUNT(1) > 0` rule used by DP2 and DP3.

## Business Logic Summary

- The parent process is job orchestration only; business updates happen inside child SQL Agent jobs.
- Parent and child procedures are global-scope EOM flows. They do not accept cycle, period, run-id, or entity parameters.
- Preload is expected to have already inserted rows into `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, and `ttInnove_Unbilled_Adj`, with `zLoaded` defaulting to `0`.
- SAP latest-log refresh uses `sp_ZFFI_REPORT_ODBC_Delta`, which pulls recent SAP ODBC rows from the `SAP_S4` linked server and refreshes local `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC`.
- A full parent run calls the SAP refresh procedure twice, not three times: DP2 and DP4 call it, while DP3 does not.
- `sp_ZFFI_REPORT_ODBC_Delta` refreshes only recent SAP rows where `Z_DATE >= current date - 1 day`.
- Loaded-status updates are detail-row only: all three success update views require `Column01 = '01'`.
- Rows are marked loaded by matching both `zDSP_Order` and `zDSP_UniqueKey` to `ZFFI_REPORT_ODBC_LATESTLOGS`.
- A matched SAP log is treated as successful only when its message does not contain the five hard-coded error fragments.
- After success updates, all three domains reset `zLoaded` to `0` for every row whose `zSource` appears in the domain error-line view.
- Error-line views group only by `zSource`, so one detail-row SAP error can affect every row from the same source.
- Error report selectors generally require a latest SAP log row. A target detail row with `zLoaded = 0` and no latest SAP log is not necessarily present in an error cache.
- DP2 and DP3 valid selectors require `zLoaded = 1` for detail rows; DP4 valid selector has the `zLoaded` condition commented out and reads from the preload report selector.
- Report cache tables are globally truncated and reloaded. There is no period partition or run-id isolation.
- Report export deletes the expected previous-month `.xlsx` file before triggering the matching SSRS subscription.
- Email send procedures only send reports whose corresponding cache table has at least one row.
- There is no active Innove EOM postload SAP reversal export, postload SFTP job start, or postload SFTP helper call.

## Operational Risks and Gaps

- The parent waits for job completion, not job success. `etl_db.dbo.fn_IsJobCompleted` only checks `msdb.dbo.sysjobactivity.stop_execution_date`, so a failed child job can still let the parent continue to the next domain.
- `etl_db.dbo.fn_IsJobCompleted` selects `TOP 1` from `msdb.dbo.sysjobactivity` without an `ORDER BY` or current-session filter. Completion polling can therefore depend on which activity row SQL Server returns.
- The parent has a fixed polling limit of about five minutes per child job. If a child is still running at the limit, the parent proceeds to the next job.
- Missing child jobs are silently skipped by the inner join to `etl_db.dbo.vw_SqlJobs`.
- The active DP3 child postload job does not refresh SAP latest logs. Standalone DP3 runs can operate on stale latest-log data unless another process refreshes `dgS4HANA_TDIR1` first.
- DP2 and DP4 refresh SAP latest logs at different points in the parent sequence. DP2, DP3, and DP4 can observe different log state if SAP postings change during the run.
- The SAP ODBC delta refresh only reads recent rows from the linked server (`Z_DATE >= current date - 1 day`). Late SAP postings outside that window may not be refreshed by this postload path.
- Source-level error resets can be broad. The error-line views group by `zSource`, so one matching SAP error can set every target row for that `zSource` back to `zLoaded = 0`.
- The DP4 valid selector has the active `zLoaded = '1'` condition commented out. This can make DP4 valid reporting diverge from the transform's loaded-status classification.
- DP4 valid reporting reads from `tvInnove_Unbilled_Adj_PreloadRptSel`, not directly from the postload target table. Changes to preload selector behavior can affect postload valid output.
- Error report selectors use joins to latest SAP logs, so rows without a matching latest log may be absent from both useful error detail and loaded-status updates.
- Report cache tables are globally truncated. Running reports concurrently or rerunning a domain can overwrite cache data used by another report export/send step.
- Report file deletion uses `xp_cmdshell` and hard-coded `F:\BOA\Transform\Report\...` paths. Missing directories, locked files, or disabled `xp_cmdshell` can break export preparation.
- SSRS polling has a fixed 25 iterations at 3 seconds each. If the report server takes longer, the procedure stops waiting while export may still be pending.
- Email send waits only 5 seconds before attaching the expected file. If SSRS export has not completed or produced the expected file name, Database Mail attachment sending can fail.
- The report period is derived from server `GETDATE()` minus one month, not from a batch parameter. Backfills and reruns outside the normal schedule will generate names for the previous calendar month at runtime.
- The setup cleanup job is global and destructive for postload prerequisites. Running it between preload and postload removes `ttInnove_*` rows needed for SAP status matching.
- There is no active postload reversal export or postload SFTP job for Innove EOM, unlike the Globe EOM postload flow. If operations expect postload reversal files, that expectation is not supported by the reviewed Innove EOM postload source.
- `etl_pipelines.txt` does not list the Innove EOM SQL Agent jobs and contains the misspelled database name `dswTDIR2_Innnove`, so operational metadata must be reconciled against `sql-agent-jobs.txt`.

## Validation Checklist

- Confirm `MyBSS_Innove_EOM_00_P01_Setup_Cleanup_03Mth`, extract, preload, and postload schedules still run in the intended order on the 3rd of the month.
- Confirm the setup cleanup job has not run after preload and before postload.
- Confirm the related preload run completed and populated `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, and `ttInnove_Unbilled_Adj`.
- Check that the three postload ad hoc child jobs exist and are enabled in SQL Agent.
- Check that `etl_db.dbo.vw_SqlJobs` can see the child job names exactly as hard-coded in the parent procedure.
- Verify SAP posting logs are available in `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` and `ZFFI_REPORT_ODBC_LATESTLOGS` for source `txInnove`.
- Validate that `sp_ZFFI_REPORT_ODBC_Delta` can connect through `SAP_S4` and that recent SAP log rows fall within the one-day delta window.
- For standalone DP3 reruns, run or verify a SAP latest-log refresh before relying on DP3 status/report output.
- Before sending reports, compare `zLoaded` counts in all three target tables against the valid and error cache counts.
- Review the domain error-line views for source-level resets: `Innove_Unearned_MSF_zLoaded_0_Error_Line`, `Innove_Unbilled_Char_zLoaded_0_Error_Line`, and `Innove_Unbilled_Adj_zLoaded_0_Error_Line`.
- Specifically validate DP4 Unbilled Adjustments because the valid selector does not require `zLoaded = 1`.
- Confirm SSRS subscriptions exist with the static descriptions containing `_MMYY`: `Inov_UMSF_Postload_DP2_MMYY_*`, `Inov_UC_Postload_DP3_MMYY_*`, and `Inov_UA_Postload_DP4_MMYY_*`.
- Confirm the runtime previous-month `MMyy` suffix matches the reporting month intended for the run.
- Confirm output directories exist and old `.xlsx` files can be deleted by the SQL Server service account.
- Confirm `xp_cmdshell` is enabled if report export deletion depends on it.
- Confirm Database Mail profile `SSRS` can send attachments to the configured recipients.
- Review `etl_db.dbo.ProcessLogs` for child transform, report prepare, report export, and report send errors after each child job.
- Review SQL Agent history for actual child job success because the parent only waits for completion.
- Confirm no downstream team expects Innove EOM postload reversal files or `P25_Postload` SFTP jobs, because none are active in the reviewed source.

## High-Level Data Flow

```text
SQL Agent
  MyBSS_Innove_EOM_00_P01_Setup_Cleanup_03Mth
    -> sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03
       -> global truncates in sdbTDIR2_Innove source tables
       -> global truncates in dswTDIR2_Innove target tables

SQL Agent
  MyBSS_innove_EOM_00_P02_Extract_03Mth
    -> SSIS extracts into sdbTDIR2_Innove
       -> 307_Unbilled_Adjustments_Report_I
       -> 317_Unbilled_Charges_I
       -> 324_Unearned_MSF_Summary_Report_I
       -> sap_airc_I
       -> sap_aiuc_I
       -> sap_glunbilled_i
       -> sap_glunbilled_unconf_I

SQL Agent
  MyBSS_Innove_EOM_00_P10_Preload_All_03Mth
    -> dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_All
       -> ttInnove_Unearned_MSF
       -> ttInnove_Unbilled_Char
       -> ttInnove_Unbilled_Adj
       -> SAP preload files
       -> related preload SFTP jobs

SAP S/4HANA posting
  -> SAP_S4.SAPPRD.ZFFI_REPORT_ODBC latest posting messages

SQL Agent
  MyBSS_Innove_EOM_00_P20_Postload_All_03Mth
    -> dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Postload_All
       -> start MyBSS_Innove_EOM_DP2_P20_Postload_UMSF_AdHoc
       -> wait for SQL Agent stop_execution_date
       -> start MyBSS_Innove_EOM_DP3_P20_Postload_UC_AdHoc
       -> wait for SQL Agent stop_execution_date
       -> start MyBSS_Innove_EOM_DP4_P20_Postload_UA_AdHoc
       -> wait for SQL Agent stop_execution_date

DP2 child postload job
  -> sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
     -> dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta
        -> SAP_S4 linked server
        -> dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC
        -> dswTDIR2_Innove.dbo.ZFFI_REPORT_ODBC_LATESTLOGS
  -> trInnove_Unearned_MSF_zloaded_Upd
  -> trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd
  -> rpt_Postload_Report_Unearned_MSF_Error_Cache
  -> rpt_Postload_Report_Unearned_MSF_Valid_Cache
  -> xp_cmdshell deletes old .xlsx files
  -> ReportServer$DACPRD.dbo.AddEvent triggers SSRS subscriptions
  -> SSRS writes Excel files under F:\BOA\Transform\Report\TDIR2-MyBSS\Innove
  -> msdb.dbo.sp_send_dbmail for nonempty reports

DP3 child postload job
  -> uses existing SAP latest-log state; no active LoadSapTables call
  -> trInnove_Unbilled_Char_zLoaded_1Upd
  -> trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd
  -> rpt_Postload_Report_Unbilled_Char_Error_Cache
  -> rpt_Postload_Report_Unbilled_Char_Valid_Cache
  -> xp_cmdshell deletes old .xlsx files
  -> ReportServer$DACPRD.dbo.AddEvent triggers SSRS subscriptions
  -> SSRS writes Excel files under F:\BOA\Transform\Report\TDIR2-MyBSS\Innove
  -> msdb.dbo.sp_send_dbmail for nonempty reports

DP4 child postload job
  -> sp_MyBSS_Innove_EOM_Postload_000_LoadSapTables
     -> refresh SAP latest logs again
  -> trInnove_Unbilled_Adj_zloaded_Upd
  -> trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd
  -> rpt_Postload_Report_Unbilled_Adj_Error_Cache
  -> rpt_Postload_Report_Unbilled_Adj_Valid_Cache
     -> valid rows come from tvInnove_Unbilled_Adj_PreloadRptSel
  -> xp_cmdshell deletes old .xlsx files
  -> ReportServer$DACPRD.dbo.AddEvent triggers SSRS subscriptions
  -> SSRS writes Excel files under F:\BOA\Transform\Report\TDIR2-MyBSS\Innove
  -> msdb.dbo.sp_send_dbmail for nonempty reports

No active Innove EOM postload reversal export or postload SFTP step was found.
```
