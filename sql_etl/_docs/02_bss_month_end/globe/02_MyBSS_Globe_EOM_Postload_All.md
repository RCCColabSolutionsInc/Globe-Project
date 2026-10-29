# sp_Job_MyBSS_Globe_EOM_Postload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_All`

Execution starts on `sp_Job_MyBSS_Globe_EOM_Postload_All`. The procedure is the parent postload orchestrator for Globe end-of-month MyBSS DP2, DP3, DP4, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment flows. It starts five SQL Agent ad hoc jobs and waits for each one to finish before starting the next job.

This document also covers the child postload procedures, SAP latest-log refresh, loaded-status update rules, reversal export files, SFTP jobs, SQL Agent context, setup cleanup context, report cache generation, SSRS subscription triggers, and email notification flow. It does not document the full preload transform logic except where postload output, report selectors, or reversal export selectors depend on preload target tables and aggregate views.

## Executive Summary

`sp_Job_MyBSS_Globe_EOM_Postload_All` does not load source extracts directly. It runs after the Globe EOM extract and preload chain has populated `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, and `ttGlobe_DP5_Unconfirmed_Adj`, exported preload SAP files, and SAP has produced latest-log rows.

At a high level, the procedure:

1. Starts the DP2 Unearned postload SQL Agent job and waits for a SQL Agent stop time.
2. Starts the DP3 Unbilled Charges postload SQL Agent job and waits for a stop time.
3. Starts the DP4 Unbilled Adjustments postload SQL Agent job and waits for a stop time.
4. Starts the DP5 Unconfirmed postload SQL Agent job and waits for a stop time.
5. Starts the DP5 Unconfirmed Adjustment postload SQL Agent job and waits for a stop time.
6. Each child job refreshes SAP reference/latest-log tables, updates loaded-status or error status according to domain-specific SQL, rebuilds report caches, triggers SSRS Excel subscriptions, and sends report emails for nonempty caches.
7. DP4, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment also export SAP reversal text files and start postload SFTP SQL Agent jobs.

There is no date, cycle, bill-cycle, posting-period, or run-id parameter. Runtime scope is global to the Globe EOM target tables, reversal selectors, SAP latest logs, report caches, and filesystem paths.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOM_Postload_All.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Child postload jobs:

- `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP2.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP3.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP4.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj.StoredProcedure.sql`

SAP/latest-log refresh and loaded-status procedures:

- `dbo.sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables.StoredProcedure.sql`
- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZFFI_REPORT_ODBC_Delta.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP2_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP3_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP4_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Transform.StoredProcedure.sql`
- `dbo.trGlobe_DP2_Unearned_zLoaded_1Upd`, `dbo.trGlobe_DP2_Unearned_zLoaded_0_Error_LineUpd`, and matching views
- `dbo.trGlobe_DP3_Unbilled_Char_zLoaded_1Upd`, `dbo.trGlobe_DP3_Unbilled_Char_zLoaded_0_Error_LineUpd`, and matching views
- `dbo.trGlobe_DP4_Unbilled_Adj_zLoaded_0_Error_LineUpd` and matching views
- Existing but inactive DP5-specific `trGlobe_DP5_Unconfirmed*_zLoaded_0_Error_LineUpd` procedures and views

Reversal export and SFTP procedures:

- `dbo.sp_MyBSS_Globe_EOM_Postload_DP4_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Export_Unbilled_Adj_Rev_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Export_Unconfirmed_Rev_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Export_Unconfirmed_Adj_Rev_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP4_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_SFTP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_SFTP.StoredProcedure.sql`

Report cache, export, send, and SSRS dataset procedures:

- `dbo.sp_MyBSS_Globe_EOM_Postload_DP*_Report_Prepare*`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP*_Report_Export`
- `dbo.sp_MyBSS_Globe_EOM_Postload_DP*_Report_Send`
- `dbo.sp_rpt_Globe_Postload_DP2_Unearned_Error_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP2_Unearned_Valid_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP3_Unbilled_Char_Error_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP3_Unbilled_Char_Valid_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP4_Unbilled_Adj_Error_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP4_Unbilled_Adj_Valid_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP5_Unconfirmed_Charges_*_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP5_Unconfirmed_MSF_*_SSRS`
- `dbo.sp_rpt_Globe_Postload_DP5_Unconfirmed_Adj_*_SSRS`

Important tables and views:

- `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, `ttGlobe_DP5_Unconfirmed_Adj`
- `rpt_Postload_Report_DP2_Unearned_*_Cache`
- `rpt_Postload_Report_DP3_Unbilled_Char_*_Cache`
- `rpt_Postload_Report_DP4_Unbilled_Adj_*_Cache`
- `rpt_Postload_Report_DP5_Unconfirmed_Charges_*_Cache`
- `rpt_Postload_Report_DP5_Unconfirmed_MSF_*_Cache`
- `rpt_Postload_Report_DP5_Unconfirmed_Adj_*_Cache`
- `ZFFI_REPORT_ODBC`, `ZFFI_REPORT_ODBC_LATESTLOGS`, and `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS`
- `txGlobe_DP4_Unbilled_Adj_ExportSel`, `txGlobe_DP4_Unbilled_Adj_Rev_ExportSel`
- `txGlobe_DP5_Unconfirmed_CH_ExporSel`, `txGlobe_DP5_Unconfirmed_MSF_ExpSel`, `txGlobe_DP5_Unconfirmed_Rev_ExportSel`
- `txGlobe_DP5_Unconfirmed_Adj_agg_ExportSel`, `txGlobe_DP5_Unconfirmed_Adj_Rev_ExportSel`
- `tvGlobe_DP2_Unearned_Postload_*RptSel`
- `tvGlobe_DP3_Unbilled_Char_PostLoad_*RptSel`
- `tvGlobe_Postload_DP4_Unbilled_Adj_Postload_*RptSel`
- `tvGlobe_Postload_DP5_Unconfirmed_*_Postload_*RptSel`
- `tvGlobe_DP2_Unearned_Recon_AmountRptSel`
- `tvGlobe_DP3_Unbilled_Char_Recon_AmountRptSel`

Setup and upstream context:

- `sdbTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03.StoredProcedure.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Preload_All.StoredProcedure.sql`
- `etl_db.dbo.vw_SqlJobs`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`

Historical or inactive references:

- Commented custom/original transform blocks inside DP2-DP5 postload transform procedures
- `dbo.sp_MyBSS_Globe_EOC_Postload_*` procedures, which are bill-cycle DP1 postload procedures and are not in the active EOM call chain
- Existing DP5-specific loaded-error update procedures, which are not called by the active DP5 EOM postload transform procedures

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Globe` | EOM SSIS landing/extract tables and the setup cleanup procedure. |
| `dswTDIR2_Globe` | Parent and child postload procedures, Globe target tables, SAP wrapper views, report cache tables, export selectors, SSRS dataset procedures, and report orchestration. |
| `dswTDIR2_Globe_Cache` | Listed in `etl_pipelines.txt` for Globe EOM, but the reviewed active postload cache tables are scripted under `dswTDIR2_Globe`. |
| `dgS4HANA_TDIR1` | SAP reference and latest-log data, including `ZTF0001S`, `ZTF0002S`, and `ZFFI_REPORT_ODBC`. |
| `SAP_S4` linked server | SAP S/4HANA source used by `sp_ZFFI_REPORT_ODBC_Delta` through `OPENQUERY`. |
| `etl_db` | SQL Agent job lookup, job-completion polling, procedure execution logging, text export, text cleaning, and SAP SFTP helpers. |
| `msdb` | Starts SQL Agent jobs and sends email through Database Mail. |
| `ReportServer$DACPRD` | SSRS subscription lookup and timed-subscription event queue. |
| Windows file system | Writes reversal export files and SSRS Excel files under `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe` and `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe`. |
| `xp_cmdshell` | Deletes existing `.xlsx` report files before SSRS subscription export. |

Important helper procedures and functions:

- `msdb.dbo.sp_start_job`
- `etl_db.dbo.vw_SqlJobs`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `etl_db.dbo.sp_ExportTextFile`
- `etl_db.dbo.fn_CleanTxt`
- `etl_db.dbo.sp_sftp_sap_del`
- `etl_db.dbo.sp_sftp_sap_push`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`
- `ReportServer$DACPRD.dbo.AddEvent`
- `msdb.dbo.sp_send_dbmail`

The local Globe wrapper view `dswTDIR2_Globe.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` reads from `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC_LATESTLOGS` and filters SAP client `MANDT = N'300'`. Some active postload code instead reads `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` directly.

## SQL Agent Context

The relevant Globe EOM SQL Agent chain in `sql-agent-jobs.txt` is:

| Job | Schedule | Command or package |
| --- | --- | --- |
| `MyBSS_Globe_EOM_00_P01_Setup_Cleanup_03Mth` | Monthly, start date `2023-08-02 09:01:00`; description says every 3rd at 9:01 AM | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03];` |
| `MyBSS_Globe_EOM_00_P02_Extract_03Mth` | Monthly, start date `2023-08-02 11:17:00`; description says every 3rd at 11:17 AM | Runs nine SSIS extract packages into `sdbTDIR2_Globe`. |
| `MyBSS_Globe_EOM_00_P10_Preload_All_03Mth` | Monthly, start date `2023-09-01 11:40:00` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Preload_All]` |
| `MyBSS_Globe_EOM_00_P20_Postload_All_03Mth` | Monthly, start date `2023-09-01 13:40:00` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_All]` |

The extract job includes these SSIS packages:

| Extract package | Target area |
| --- | --- |
| `MyBss_Globe_307_Unbilled_Adjustments` | DP4 adjustment source support |
| `MyBss_Globe_317_Unbilled_Charges_Summary` | DP3 charge summary support |
| `MyBss_Globe_317_Unbilled_Charges_Summary_V2(ExcelStartsatRow5)` | DP3 charge summary support |
| `MyBss_Globe_324_Unearned_MSF` | DP2 unearned source support |
| `MyBss_Globe_sap_airc` | DP2 SAP AIRC source |
| `MyBss_Globe_sap_aiuc` | DP3 SAP AIUC source |
| `MyBss_Globe_glunbilled` | DP4 SAP GL unbilled source |
| `MyBss_Globe_Unconfirmed_Advance_MSF` | DP5 unconfirmed source |
| `MyBss_Globe_glunbilled_unconf` | DP5 unconfirmed adjustment source |

The parent postload job starts these child ad hoc postload jobs:

| Parent sequence | SQL Agent job | T-SQL command |
| ---: | --- | --- |
| 1 | `MyBSS_Globe_EOM_DP2_P20_Postload_Unearned_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_DP2]` |
| 2 | `MyBSS_Globe_EOM_DP3_P20_Postload_UC_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_DP3]` |
| 3 | `MyBSS_Globe_EOM_DP4_P20_Postload_UA_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_DP4]` |
| 4 | `MyBSS_Globe_EOM_DP5_1_P20_Postload_Unconfirmed_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed]` |
| 5 | `MyBSS_Globe_EOM_DP5_2_P20_Postload_Unconfirmed_Adj_AdHoc` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj]` |

DP4 and DP5 child postload jobs start these SFTP jobs:

| Child postload job | SFTP job |
| --- | --- |
| `MyBSS_Globe_EOM_DP4_P20_Postload_UA_AdHoc` | `MyBSS_Globe_EOM_DP4_P25_Postload_UA_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP5_1_P20_Postload_Unconfirmed_AdHoc` | `MyBSS_Globe_EOM_DP5_1_P25_Postload_Unconfirmed_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP5_2_P20_Postload_Unconfirmed_Adj_AdHoc` | `MyBSS_Globe_EOM_DP5_2_P25_Postload_Unconfirmed_Adj_SFTP_AdHoc` |

DP2 and DP3 postload child procedures have no export step and do not start postload SFTP jobs.

Important observed detail:

`etl_pipelines.txt` lists "MyBSS Globe EOM (End of month)" with databases `sdbTDIR2_Globe`, `dswTDIR2_Globe`, and `dswTDIR2_Globe_Cache`, but its SQL Agent job list is blank. The operational EOM job chain is present in `sql-agent-jobs.txt`.

## Cleanup Process

The setup cleanup procedure is not called by `sp_Job_MyBSS_Globe_EOM_Postload_All`. It is run by its own SQL Agent job before extract and preload.

Procedure:

`sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03`

The cleanup truncates source extract tables and Globe target tables globally:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Globe` | `307_Unbilled_Adjustments_Report_G`, `307_Unbilled_Adjustments_Report_G_header`, `317_Unbilled_Charges_Summary_Report_G`, `324_Unearned_MSF`, `DP5_Unconfirmed_Advance_MSF_header`, `sap_airc`, `sap_aiuc_G`, `sap_glunbilled_G`, `sap_glunbilled_unconf_G`, `Unconfirmed_Advanced_MSF_Charges` |
| `dswTDIR2_Globe` | `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, `ttGlobe_DP5_Unconfirmed_Adj` |

This cleanup is global, not cycle-scoped, period-scoped, or run-id scoped. Running it between preload and postload would remove the target rows that postload needs for SAP log matching, reversal export, and report generation.

## Parameter Mapping

The parent and child EOM postload procedures have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / entity | Hard-coded through Globe-specific procedures, tables, paths, report names, and SAP company code `GLOB` in export selectors. |
| Domain | Hard-coded by job and procedure names: DP2 Unearned, DP3 Unbilled Charges, DP4 Unbilled Adjustments, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable to the EOM postload procedures reviewed. |
| Run state | Global target tables, `zLoaded` flags, SAP latest logs, reversal selector views, and global report cache tables. |

Report subscription and output naming:

| Domain | Subscription descriptions | Output directory |
| --- | --- | --- |
| DP2 Unearned | `Glob_Unearned_Postload_DP2_MMYY_Error`, `Glob_Unearned_Postload_DP2_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP2_Unearned_SSRS` |
| DP3 Unbilled Charges | `Glob_UC_Postload_DP3_MMYY_Error`, `Glob_UC_Postload_DP3_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP3_Unbilled_Char_SSRS` |
| DP4 Unbilled Adjustments | `Glob_UA_DP4_MMYY_Postload_Error`, `Glob_UA_DP4_MMYY_Postload_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP4_Unbilled_Adj_SSRS` |
| DP5 Unconfirmed | `Glob_Unconfirmed_CH_Postload_DP5_MMYY_Error`, `Glob_Unconfirmed_CH_Postload_DP5_MMYY_Valid`, `Glob_Unconfirmed_MSF_Postload_DP5_MMYY_Error`, `Glob_Unconfirmed_MSF_Postload_DP5_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_ALL_SSRS` |
| DP5 Unconfirmed Adjustment | `Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Error`, `Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Valid` | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_ALL_SSRS` |

`_MMYY` is replaced at runtime with the previous-month value. For example, a run in May 2026 would look for and write names ending in `_0426_Error` or `_0426_Valid`.

Reversal export and SFTP mapping:

| Domain | Export file | Export directory | SFTP delete key | SFTP push key |
| --- | --- | --- | --- | --- |
| DP4 Unbilled Adjustments | `txGlobe_DP4_Unbilled_Adj_Rev.txt` | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP4_Unbilled_Adj_New` | `03_txGlobe_DP4_Unbilled_Adj_Rev_Del` | `01_txGlobe_DP4_Unbilled_Adj_Rev_Push` |
| DP5 Unconfirmed | `txGlobe_DP5_Unconfirmed_Rev.txt` | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_New` | `03_txGlobe_DP5_Unconfirmed_Rev_Del` | `01_txGlobe_DP5_Unconfirmed_Rev_Push` |
| DP5 Unconfirmed Adjustment | `txGlobe_DP5_Unconfirmed_Adj_Rev.txt` | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_Adj_New` | `03_txGlobe_DP5_Unconfirmed_Adj_Rev_Del` | `01_txGlobe_DP5_Unconfirmed_Adj_Rev_Push` |

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable of five ad hoc SQL Agent job names.
3. Looks up those job names in `etl_db.dbo.vw_SqlJobs`, which selects from `msdb.dbo.sysjobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each child job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the poll loop when the job shows a non-null `stop_execution_date` or when the iteration limit is reached.
8. Moves to the next child job.

The parent does not call `etl_db.dbo.sp_ExecuteQueryAndLog` itself. Logging happens inside each child postload job for transform, export where present, report prepare, report export, and report send.

Child logging dimensions:

| Domain | `@Proccess` | `@ProcessGroup` | `@Step` | `@Others` |
| --- | --- | --- | --- | --- |
| DP2 | `MyBSS` | `Globe` | `DP2_Unearned - Postload` | `EOM` |
| DP3 | `MyBSS` | `Globe` | `DP3_Unbilled_Char - Postload` | `EOM` |
| DP4 | `MyBSS` | `Globe` | `DP4_Unbilled_Adj - Postload` | `EOM` |
| DP5 Unconfirmed | `MyBSS` | `Globe` | `DP5_Unconfirmed - Postload` | `EOM` |
| DP5 Unconfirmed Adjustment | `MyBSS` | `Globe` | `DP5_Unconfirmed_Adj - Postload` | `EOM` |

Important observed details:

- Missing child job names are skipped because the cursor uses an inner join to `etl_db.dbo.vw_SqlJobs`.
- `fn_IsJobCompleted` checks for a non-null `stop_execution_date`; it does not inspect SQL Agent success/failure status.
- The parent comment says `@MaxIteration = 60` equals `240 seconds or 5 mins`. With a 5-second wait, the implemented limit is approximately five minutes, and the `240 seconds` part of the comment is inconsistent.
- The variable name `@Proccess` is spelled with two `c` characters in the child procedures. The spelling is preserved here because it appears in source.

## Step 1: Start DP2-DP5 Postload Jobs

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_All`

The parent starts these jobs sequentially:

| Sequence | SQL Agent job | Child procedure | Domain |
| ---: | --- | --- | --- |
| 1 | `MyBSS_Globe_EOM_DP2_P20_Postload_Unearned_AdHoc` | `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP2` | DP2 Unearned |
| 2 | `MyBSS_Globe_EOM_DP3_P20_Postload_UC_AdHoc` | `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP3` | DP3 Unbilled Charges |
| 3 | `MyBSS_Globe_EOM_DP4_P20_Postload_UA_AdHoc` | `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP4` | DP4 Unbilled Adjustments |
| 4 | `MyBSS_Globe_EOM_DP5_1_P20_Postload_Unconfirmed_AdHoc` | `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed` | DP5 Unconfirmed |
| 5 | `MyBSS_Globe_EOM_DP5_2_P20_Postload_Unconfirmed_Adj_AdHoc` | `dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj` | DP5 Unconfirmed Adjustment |

Because ordering is by job name, the current names naturally execute DP2, DP3, DP4, DP5_1, and DP5_2.

## Step 2: Refresh SAP Tables and Latest Logs

Procedure:

`dswTDIR2_Globe.dbo.sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`

Each child postload job calls this procedure before its transform step. A full parent run therefore refreshes the same SAP reference/latest-log tables five times.

Called procedures:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`

`sp_ZFFI_REPORT_ODBC_Delta` reads recent SAP `SAPPRD.ZFFI_REPORT_ODBC` rows through `OPENQUERY([SAP_S4], ...)`, limited to `Z_DATE >= current date - 1 day`. It keeps the latest row per `ZDSP_UNIQUEKEY`, `Z_PROG_NAME`, and `Z_LINE_ITEM`, deletes matching existing rows from `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` by unique key, DSP order, and program name, then inserts the refreshed rows inside a transaction.

Important observed detail:

The SAP refresh is called directly by each child job and is not wrapped by `sp_ExecuteQueryAndLog`, unlike transform/export/report steps.

## Step 3: DP2 Unearned Postload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP2`

Call sequence:

1. `sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Globe_EOM_Postload_DP2_Transform`
3. `sp_MyBSS_Globe_EOM_Postload_DP2_Report_Prepare`
4. `sp_MyBSS_Globe_EOM_Postload_DP2_Report_Export`
5. `sp_MyBSS_Globe_EOM_Postload_DP2_Report_Send`

### Loaded Status Update

`sp_MyBSS_Globe_EOM_Postload_DP2_Transform` uses a custom inline implementation. The original generated calls to `trGlobe_DP2_Unearned_zLoaded_1Upd` and `trGlobe_DP2_Unearned_zLoaded_0_Error_LineUpd` are commented out.

The active transform sets `ttGlobe_DP2_Unearned.zLoaded = '1'` where:

- `ttGlobe_DP2_Unearned.ZDSP_ORDER = dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER`
- `ttGlobe_DP2_Unearned.ZDSP_UNIQUEKEY = dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY`
- `Data = '01'`
- `Z_MESSAGE` does not contain any configured error fragment:
  - `is not found`
  - `requires an assignment to a CO object`
  - `does not exist in chart of accounts`
  - `Error in document`
  - `not defined in chart of accounts`
  - `not allowed for characteristic`
  - `Balance in Transaction Currency`

It then groups SAP error matches by `zSource` into `#ERROR` where `Data = '01'` and `Z_MESSAGE` contains any configured error fragment. Every row in `ttGlobe_DP2_Unearned` whose `zSource` appears in `#ERROR` is set back to `zLoaded = '0'`.

This means one error detail row can mark all rows from the same `zSource` as not loaded.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source logic |
| --- | --- |
| `rpt_Postload_Report_DP2_Unearned_Error_Cache` | Temp table copied from `ttGlobe_DP2_Unearned` joined to `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS`, filtered to `zLoaded = '0'`. |
| `rpt_Postload_Report_DP2_Unearned_Valid_Cache` | Temp table copied from the same join, filtered to `zLoaded = '1'`. |

Both caches require the DP2 recon difference from `tvGlobe_DP2_Unearned_Recon_AmountRptSel` to be between `-100000.00` and `100000.00`. The recon view compares `324_Unearned_MSF_Header_Item.[Total Unearned RC]` with `sdbTDIR2_Globe..SAP_AIRC.Column7` where `Column1 = '01'`, and formats the values as strings with commas before the postload report prepare procedure converts the difference back to numeric.

### Report Export and Email

`sp_MyBSS_Globe_EOM_Postload_DP2_Report_Export` triggers SSRS subscriptions for:

- `Glob_Unearned_Postload_DP2_MMYY_Error`
- `Glob_Unearned_Postload_DP2_MMYY_Valid`

`sp_MyBSS_Globe_EOM_Postload_DP2_Report_Send` emails only report caches with `COUNT(1) > 0`. It sends through Database Mail profile `SSRS`, attaches the generated Excel file, sends to `rosoldevilla@globe.com.ph;rnvillar@globe.com.ph`, and copies `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph`.

There is no DP2 postload reversal export or SFTP step.

## Step 4: DP3 Unbilled Charges Postload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP3`

Call sequence:

1. `sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Globe_EOM_Postload_DP3_Transform`
3. `sp_MyBSS_Globe_EOM_Postload_DP3_Report_Prepare`
4. `sp_MyBSS_Globe_EOM_Postload_DP3_Report_Export`
5. `sp_MyBSS_Globe_EOM_Postload_DP3_Report_Send`

### Loaded Status Update

`sp_MyBSS_Globe_EOM_Postload_DP3_Transform` calls:

1. `trGlobe_DP3_Unbilled_Char_zLoaded_1Upd`
2. `trGlobe_DP3_Unbilled_Char_zLoaded_0_Error_LineUpd`

The success update sets `zLoaded = '1'` through `trGlobe_DP3_Unbilled_Char_zLoaded_1UpdSel` where `ttGlobe_DP3_Unbilled_Char` matches `ZFFI_REPORT_ODBC_LATESTLOGS` on `ZDSP_ORDER` and `ZDSP_UNIQUEKEY`, `Column01 = '01'`, and the SAP message does not contain the configured error fragments.

The error update sets `zLoaded = '0'` through `trGlobe_DP3_Unbilled_Char_zLoaded_0_Error_LineUpdSel` for every row whose `zSource` appears in `Globe_DP3_Unbilled_Char_zLoaded_0_Error_Line`. That error-line view groups by `zSource` and uses `OR` across the configured SAP error fragments, again restricted to detail rows where `Column01 = '01'`.

The custom inline transform block in this procedure is commented out.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_DP3_Unbilled_Char_Error_Cache` | `tvGlobe_DP3_Unbilled_Char_PostLoad_ErrorRptSel` |
| `rpt_Postload_Report_DP3_Unbilled_Char_Valid_Cache` | `tvGlobe_DP3_Unbilled_Char_PostLoad_ValidRptSel` |

Both selector views require `tvGlobe_DP3_Unbilled_Char_Recon_AmountRptSel.variance` to be between `-100000.00` and `100000.00`. The recon view compares SAP detail `ttGlobe_DP3_Unbilled_Char.Column07` where `Column01 = '01'` with `sdbTDIR2_Globe.dbo.317_Unbilled_Charges_Summary_Report_G.Amount` where `LEN([Customer Type]) = 1`.

### Report Export and Email

`sp_MyBSS_Globe_EOM_Postload_DP3_Report_Export` triggers SSRS subscriptions for:

- `Glob_UC_Postload_DP3_MMYY_Error`
- `Glob_UC_Postload_DP3_MMYY_Valid`

`sp_MyBSS_Globe_EOM_Postload_DP3_Report_Send` emails nonempty caches with the same recipient, copy-recipient, body, and Database Mail profile pattern as DP2.

There is no DP3 postload reversal export or SFTP step.

## Step 5: DP4 Unbilled Adjustments Postload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP4`

Call sequence:

1. `sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Globe_EOM_Postload_DP4_Transform`
3. `sp_MyBSS_Globe_EOM_Postload_DP4_Export`
4. `sp_MyBSS_Globe_EOM_Postload_DP4_Report_Prepare`
5. `sp_MyBSS_Globe_EOM_Postload_DP4_Report_Export`
6. `sp_MyBSS_Globe_EOM_Postload_DP4_Report_Send`
7. `msdb.dbo.sp_start_job @JobName = 'MyBSS_Globe_EOM_DP4_P25_Postload_UA_SFTP_AdHoc'`

### Loaded Status Update

`sp_MyBSS_Globe_EOM_Postload_DP4_Transform` calls only:

`trGlobe_DP4_Unbilled_Adj_zLoaded_0_Error_LineUpd`

That procedure sets `ttGlobe_DP4_Unbilled_Adj.zLoaded = '0'` for rows whose `zSource` appears in `Globe_DP4_Unbilled_Adj_zLoaded_0_Error_Line`. The error-line view matches `ttGlobe_DP4_Unbilled_Adj` to `ZFFI_REPORT_ODBC_LATESTLOGS` on `ZDSP_ORDER` and `ZDSP_UNIQUEKEY`, groups by `zSource`, and uses `OR` across the configured error fragments.

There is no active DP4 postload `zLoaded = '1'` update in the reviewed procedure.

### Reversal Export

`sp_MyBSS_Globe_EOM_Postload_DP4_Export` writes:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP4_Unbilled_Adj_New\txGlobe_DP4_Unbilled_Adj_Rev.txt`

The export is produced through `etl_db.dbo.sp_ExportTextFile` using:

`EXEC [dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Preload_DP4_Export_Unbilled_Adj_Rev_LoadFileSel]`

Important observed detail:

The active DP4 postload reversal export calls a procedure whose name contains `Preload`. The procedure itself selects reversal fields from `txGlobe_DP4_Unbilled_Adj_Rev_ExportSel`.

The reversal selector:

- Reads successful SAP latest-log rows from `txGlobe_DP4_Unbilled_Adj_ExportSel` joined to `ZFFI_REPORT_ODBC_LATESTLOGS`.
- Extracts `DocNum` from `Z_MESSAGE` using `Ltrim(Rtrim(Substring(Z_MESSAGE, Charindex(':', Z_MESSAGE) + 2, 10)))`.
- Uses `LEFT(z_date, 4)` as `Fiscal.Yr`.
- Groups by document number, company code, and fiscal year.
- Outputs the minimum `zDSP_order` and minimum `zDSP_UniqueKey` as `ASzDSP_UniqueKey`.
- Filters out configured SAP error fragments with `NOT LIKE`.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_DP4_Unbilled_Adj_Error_Cache` | `tvGlobe_Postload_DP4_Unbilled_Adj_Postload_ErrorRptSel` |
| `rpt_Postload_Report_DP4_Unbilled_Adj_Valid_Cache` | `tvGlobe_Postload_DP4_Unbilled_Adj_Postload_ValidRptSel` |

The selector views read from `txGlobe_DP4_Unbilled_Adj_ExportSel`, which is based on `tvGlobe_DP4_Unbilled_Adj_agg_Preload_RptSel`. That preload aggregate view builds `zDSP_UniqueKey` as:

`GUnbilledAdj-{zDSP_order}-{Post Date}`

The aggregate rows are built from `DP4_Unbilled_Adj_agg_Union`, which creates debit/credit SAP rows using `Posting_Date`, `DP4_PostingDate010`, `DP4_PostingDate011`, `DP4_PostingDate0111`, `tvGlobe_DP4_Unbilled_Adj_aggRptSel`, and the sum of `ttGlobe_DP4_Unbilled_Adj.Amount_Net`.

Important observed detail:

The DP4 valid report selector joins latest logs on both `ZDSP_UNIQUEKEY` and `ZDSP_ORDER`. The DP4 error report selector joins only on `ZDSP_UNIQUEKEY` and uses `AND` across every configured error fragment, which requires a single SAP message to contain all fragments at once.

### Report Export, Email, and SFTP

`sp_MyBSS_Globe_EOM_Postload_DP4_Report_Export` triggers SSRS subscriptions for:

- `Glob_UA_DP4_MMYY_Postload_Error`
- `Glob_UA_DP4_MMYY_Postload_Valid`

`sp_MyBSS_Globe_EOM_Postload_DP4_Report_Send` emails nonempty caches with the same recipient and attachment pattern as DP2.

The child job starts `MyBSS_Globe_EOM_DP4_P25_Postload_UA_SFTP_AdHoc` asynchronously. The SFTP procedure calls:

1. `etl_db.dbo.sp_sftp_sap_del '03_txGlobe_DP4_Unbilled_Adj_Rev_Del'`
2. `etl_db.dbo.sp_sftp_sap_push '01_txGlobe_DP4_Unbilled_Adj_Rev_Push'`

## Step 6: DP5 Unconfirmed Postload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed`

Call sequence:

1. `sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Transform`
3. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Export`
4. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Report_Prepare`
5. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Report_Export`
6. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Report_Send`
7. `msdb.dbo.sp_start_job @JobName = 'MyBSS_Globe_EOM_DP5_1_P25_Postload_Unconfirmed_SFTP_AdHoc'`

### Loaded Status Update

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Transform` actively calls:

`trGlobe_DP4_Unbilled_Adj_zLoaded_0_Error_LineUpd`

The procedure contains a commented custom block that would have updated `ttGlobe_DP5_Unconfirmed`, and the repository also contains `trGlobe_DP5_Unconfirmed_zLoaded_0_Error_LineUpd`, but neither is active in the current child procedure.

Important observed detail:

The active DP5 Unconfirmed transform updates DP4 unbilled-adjustment rows, not DP5 unconfirmed rows.

### Reversal Export

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Export` writes:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_New\txGlobe_DP5_Unconfirmed_Rev.txt`

The export is produced through `etl_db.dbo.sp_ExportTextFile` using:

`EXEC [dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Preload_DP5_Export_Unconfirmed_Rev_LoadFileSel]`

The reversal selector `txGlobe_DP5_Unconfirmed_Rev_ExportSel` unions successful rows from:

- `txGlobe_DP5_Unconfirmed_CH_ExporSel`
- `txGlobe_DP5_Unconfirmed_MSF_ExpSel`

Both branches extract `DocNum` from `Z_MESSAGE`, use `LEFT(z_date, 4)` as `Fiscal.Yr`, group by document number, company code, and fiscal year, and filter out configured SAP error fragments with `NOT LIKE`.

Important observed detail:

The child export procedure and load-file selector names contain `Preload` even though this is the EOM postload reversal export.

### Report Cache

Report preparation truncates and reloads four global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_DP5_Unconfirmed_Charges_Error_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_CH_Postload_ErrorRptSel` |
| `rpt_Postload_Report_DP5_Unconfirmed_Charges_Valid_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_CH_Postload_ValidRptSel` |
| `rpt_Postload_Report_DP5_Unconfirmed_MSF_Error_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_MSF_Postload_ErrorRptSel` |
| `rpt_Postload_Report_DP5_Unconfirmed_MSF_Valid_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_MSF_Postload_ValidRptSel` |

The CH selector is based on `txGlobe_DP5_Unconfirmed_CH_ExporSel`, which reads `tvGlobe_DP5_Unconfirmed_Charges_agg_Preload_RptSel` and builds unique keys as:

`GUnconfChg-{zDSP_order}-{Post Date}`

The MSF selector is based on `txGlobe_DP5_Unconfirmed_MSF_ExpSel`, which reads `tvGlobe_DP5_Unconfirmed_MSF_agg_Preload_RptSel` and builds unique keys as:

`GUnconfMSF-{zDSP_order}-{Post Date}`

Both aggregate areas ultimately use `ttGlobe_DP5_Unconfirmed` and DP5 posting-date helper views. The report selectors do not directly filter on `ttGlobe_DP5_Unconfirmed.zLoaded`.

Important observed detail:

The DP5 Unconfirmed valid report selectors join latest logs on both `ZDSP_UNIQUEKEY` and `ZDSP_ORDER`. The error report selectors join only on `ZDSP_UNIQUEKEY` and use `AND` across every configured error fragment.

### Report Export, Email, and SFTP

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Report_Export` triggers SSRS subscriptions for:

- `Glob_Unconfirmed_CH_Postload_DP5_MMYY_Error`
- `Glob_Unconfirmed_CH_Postload_DP5_MMYY_Valid`
- `Glob_Unconfirmed_MSF_Postload_DP5_MMYY_Error`
- `Glob_Unconfirmed_MSF_Postload_DP5_MMYY_Valid`

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Report_Send` emails nonempty caches with the same recipient and attachment pattern as DP2.

The child job starts `MyBSS_Globe_EOM_DP5_1_P25_Postload_Unconfirmed_SFTP_AdHoc` asynchronously. The SFTP procedure calls:

1. `etl_db.dbo.sp_sftp_sap_del '03_txGlobe_DP5_Unconfirmed_Rev_Del'`
2. `etl_db.dbo.sp_sftp_sap_push '01_txGlobe_DP5_Unconfirmed_Rev_Push'`

## Step 7: DP5 Unconfirmed Adjustment Postload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj`

Call sequence:

1. `sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables`
2. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Transform`
3. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Export`
4. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Report_Prepare`
5. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Report_Export`
6. `sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Report_Send`
7. `msdb.dbo.sp_start_job @JobName = 'MyBSS_Globe_EOM_DP5_2_P25_Postload_Unconfirmed_Adj_SFTP_AdHoc'`

### Loaded Status Update

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Transform` actively calls:

`trGlobe_DP4_Unbilled_Adj_zLoaded_0_Error_LineUpd`

The procedure contains a commented custom block that would have updated `ttGlobe_DP5_Unconfirmed_Adj`, and the repository also contains `trGlobe_DP5_Unconfirmed_Adj_zLoaded_0_Error_LineUpd`, but neither is active in the current child procedure.

Important observed detail:

The active DP5 Unconfirmed Adjustment transform updates DP4 unbilled-adjustment rows, not DP5 unconfirmed-adjustment rows.

### Reversal Export

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Export` writes:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_Adj_New\txGlobe_DP5_Unconfirmed_Adj_Rev.txt`

The export is produced through `etl_db.dbo.sp_ExportTextFile` using:

`EXEC [dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Postload_DP5_Export_Unconfirmed_Adj_Rev_LoadFileSel]`

The selector reads `txGlobe_DP5_Unconfirmed_Adj_Rev_ExportSel`, which joins `txGlobe_DP5_Unconfirmed_Adj_agg_ExportSel` to `ZFFI_REPORT_ODBC_LATESTLOGS`, extracts `DocNum` from `Z_MESSAGE`, uses `LEFT(z_date, 4)` as `Fiscal.Yr`, groups by document number, company code, and fiscal year, and filters out configured SAP error fragments with `NOT LIKE`.

Important observed detail:

The DP5 adjustment load-file selector does not apply `etl_db.dbo.fn_CleanTxt` to output columns, unlike the DP4 and DP5 Unconfirmed reversal load-file selectors.

### Report Cache

Report preparation truncates and reloads two global cache tables:

| Cache table | Source view |
| --- | --- |
| `rpt_Postload_Report_DP5_Unconfirmed_Adj_Error_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_Adj_Postload_ErrorRptSel` |
| `rpt_Postload_Report_DP5_Unconfirmed_Adj_Valid_Cache` | `tvGlobe_Postload_DP5_Unconfirmed_Adj_Postload_ValidRptSel` |

The selector is based on `txGlobe_DP5_Unconfirmed_Adj_agg_ExportSel`, which reads `tvGlobe_DP5_Unconfirmed_Adj_agg_Preload_RptSel` and builds unique keys as:

`GUnconfAdj-{zDSP_order}-{Post Date}`

The aggregate rows are built from `DP5_Unconfirmed_Adj_agg_Union`, `tvGlobe_DP5_Unconfirmed_aggRptSel`, DP5 posting-date helper views, and the sum of `ttGlobe_DP5_Unconfirmed_Adj.Amount_Net`.

Important observed detail:

The DP5 Unconfirmed Adjustment valid report selector joins latest logs on both `ZDSP_UNIQUEKEY` and `ZDSP_ORDER`. The error report selector joins only on `ZDSP_UNIQUEKEY` and uses `AND` across every configured error fragment.

### Report Export, Email, and SFTP

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Report_Export` triggers SSRS subscriptions for:

- `Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Error`
- `Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Valid`

`sp_MyBSS_Globe_EOM_Postload_DP5_Unconfirmed_Adj_Report_Send` emails nonempty caches with the same recipient and attachment pattern as DP2.

The child job starts `MyBSS_Globe_EOM_DP5_2_P25_Postload_Unconfirmed_Adj_SFTP_AdHoc` asynchronously. The SFTP procedure calls:

1. `etl_db.dbo.sp_sftp_sap_del '03_txGlobe_DP5_Unconfirmed_Adj_Rev_Del'`
2. `etl_db.dbo.sp_sftp_sap_push '01_txGlobe_DP5_Unconfirmed_Adj_Rev_Push'`

## Business Logic Summary

- The parent process is job orchestration only; business updates happen inside child SQL Agent jobs.
- Parent and child procedures are global-scope EOM flows. They do not accept cycle, period, run-id, or entity parameters.
- SAP latest-log refresh is performed by every child postload job, so one full parent run calls `sp_ZFFI_REPORT_ODBC_Delta` five times.
- `sp_ZFFI_REPORT_ODBC_Delta` refreshes only recent SAP rows where `Z_DATE >= current date - 1 day`.
- DP2 and DP3 set successful detail rows to `zLoaded = '1'`, then set all rows for any `zSource` with an SAP error match back to `zLoaded = '0'`.
- DP4 has no active success update; it only sets `ttGlobe_DP4_Unbilled_Adj.zLoaded = '0'` for source groups with errors.
- DP5 Unconfirmed and DP5 Unconfirmed Adjustment active transforms call the DP4 error-line update procedure, not their DP5-specific update procedures.
- DP2 and DP3 postload reports depend on `zLoaded` and recon variance thresholds.
- DP4 and DP5 postload reports are built from preload aggregate export selectors joined to SAP latest logs; they do not directly filter on DP4/DP5 target-table `zLoaded`.
- DP4 and DP5 reversal export selectors derive SAP document numbers from successful SAP latest-log messages by substringing text after the first colon.
- DP4 and DP5 reversal exports use global hard-coded paths and filenames. There is no period or run-id in the export file name.
- SSRS report export procedures delete the expected previous-month `.xlsx` file with `xp_cmdshell`, trigger `ReportServer$DACPRD.dbo.AddEvent`, and poll the report-server event queue every 3 seconds up to 25 iterations.
- Report send procedures only email reports whose corresponding cache table has at least one row.
- DP4 and DP5 SFTP jobs are started asynchronously by child procedures. The child procedures do not wait for delete/push completion.

## Operational Risks and Gaps

- Global cleanup can destroy postload inputs. `sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03` truncates all Globe EOM target tables and is not scoped by period or run-id.
- The parent checks only SQL Agent stop time. `etl_db.dbo.fn_IsJobCompleted` does not inspect success/failure status, so the parent can proceed after a failed child job.
- The parent has a fixed wait limit of roughly five minutes per child job. If a child job runs longer, the parent breaks out and starts the next job.
- Missing child jobs are silently skipped because the parent cursor is built from an inner join to `etl_db.dbo.vw_SqlJobs`.
- DP5 Unconfirmed and DP5 Unconfirmed Adjustment transforms call the DP4 error updater. That means active DP5 postload transform logic can update `ttGlobe_DP4_Unbilled_Adj` instead of DP5 tables.
- DP4, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment error report selectors use `AND` across all configured SAP error fragments. A single message would need to contain every fragment to be classified as an error by those report views.
- DP4 and DP5 valid report selectors use `NOT LIKE` filters against SAP messages but do not inspect `zLoaded`, so report classification can differ from the loaded-status updates.
- DP4 and DP5 error report selectors join latest logs only on `ZDSP_UNIQUEKEY`, while valid selectors also join on `ZDSP_ORDER`. This can produce different match behavior between valid and error reports.
- `sp_ZFFI_REPORT_ODBC_Delta` pulls only one day of recent SAP logs. Late SAP posting results outside that window can be absent from latest-log matching.
- Report export depends on SSRS subscription descriptions matching template names containing `_MMYY`. If subscription descriptions are renamed to fixed month names, the join will not find them.
- Report export deletes files with `xp_cmdshell` before triggering SSRS. If SSRS fails after deletion, the previous Excel output is gone.
- Report emails attach files after a fixed 5-second wait and do not verify that the attachment exists.
- DP4 and DP5 SFTP jobs are asynchronous. The child procedures do not confirm delete/push success before ending.
- DP4 and DP5 reversal files have fixed names with no period suffix, so reruns overwrite or replace the same logical output.
- The DP5 Unconfirmed Adjustment reversal load-file selector does not use `etl_db.dbo.fn_CleanTxt`, unlike the DP4 and DP5 Unconfirmed reversal selectors.
- `etl_pipelines.txt` leaves the Globe EOM SQL Agent job list blank, so operational metadata must be reconciled against `sql-agent-jobs.txt`.

## Validation Checklist

- Confirm the setup cleanup and extract jobs completed before preload, and confirm cleanup has not run again after preload.
- Confirm the preload parent `MyBSS_Globe_EOM_00_P10_Preload_All_03Mth` and all five child preload jobs completed successfully.
- Check row counts in `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, and `ttGlobe_DP5_Unconfirmed_Adj`.
- Confirm SAP load files were posted and recent rows exist in `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC` for the expected `ZDSP_UNIQUEKEY` and `ZDSP_ORDER` values.
- Confirm `sp_ZFFI_REPORT_ODBC_Delta` has a sufficient date window for the SAP posting time being validated.
- For DP2, validate `tvGlobe_DP2_Unearned_Recon_AmountRptSel.Difference` is within `-100000.00` to `100000.00` after removing commas.
- For DP3, validate `tvGlobe_DP3_Unbilled_Char_Recon_AmountRptSel.variance` is within `-100000.00` to `100000.00`.
- Review `zLoaded` distribution by target table and `zSource`, especially for DP2 and DP3 source-level error overrides.
- Review whether the active DP5 transform calls should use DP5-specific zLoaded update procedures before relying on DP5 postload status.
- Validate DP4 and DP5 reversal selector row counts before SFTP: `txGlobe_DP4_Unbilled_Adj_Rev_ExportSel`, `txGlobe_DP5_Unconfirmed_Rev_ExportSel`, and `txGlobe_DP5_Unconfirmed_Adj_Rev_ExportSel`.
- Confirm reversal export files exist at the configured `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\...` paths.
- Confirm the `P25_Postload` SFTP jobs exist and the SFTP helper keys map to the expected remote delete and push configuration.
- Confirm SSRS subscription descriptions match the exact `_MMYY` templates used by the export procedures.
- Confirm the previous-month `.xlsx` files were regenerated under the configured `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\...` directories.
- Confirm each report cache count matches the intended email notification count before `sp_send_dbmail` runs.
- Confirm Database Mail profile `SSRS` is enabled and attachment paths are reachable by SQL Server.
- Reconcile `sql-agent-jobs.txt` with live SQL Agent configuration because `etl_pipelines.txt` does not list the Globe EOM jobs.

## High-Level Data Flow

```text
SQL Agent schedule
  MyBSS_Globe_EOM_00_P01_Setup_Cleanup_03Mth
    -> sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03
    -> global truncates of EOM source and target tables

  MyBSS_Globe_EOM_00_P02_Extract_03Mth
    -> SSIS packages load sdbTDIR2_Globe source tables

  MyBSS_Globe_EOM_00_P10_Preload_All_03Mth
    -> preload child jobs populate ttGlobe_DP2_Unearned
                                ttGlobe_DP3_Unbilled_Char
                                ttGlobe_DP4_Unbilled_Adj
                                ttGlobe_DP5_Unconfirmed
                                ttGlobe_DP5_Unconfirmed_Adj
    -> preload export and SFTP sends SAP load files

  SAP S/4HANA posting
    -> SAP_S4.ZFFI_REPORT_ODBC latest posting messages

  MyBSS_Globe_EOM_00_P20_Postload_All_03Mth
    -> dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Postload_All
       -> starts DP2, DP3, DP4, DP5_1, DP5_2 postload ad hoc jobs
       -> waits for SQL Agent stop time after each job

Child postload jobs
  -> sp_MyBSS_Globe_EOM_Postload_000_LoadSapTables
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
     -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
     -> dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta
        -> SAP_S4 linked server -> dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC

  -> domain transform
     -> zLoaded updates and/or source-level error resets

  -> domain report prepare
     -> global rpt_Postload_Report_*_Cache tables

  -> domain report export
     -> ReportServer$DACPRD subscriptions
     -> xp_cmdshell deletes previous Excel files
     -> F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\...\*.xlsx

  -> domain report send
     -> msdb.dbo.sp_send_dbmail with nonempty report caches

  -> DP4/DP5 reversal export
     -> etl_db.dbo.sp_ExportTextFile
     -> F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\...\*_Rev.txt

  -> DP4/DP5 postload SFTP jobs
     -> etl_db.dbo.sp_sftp_sap_del
     -> etl_db.dbo.sp_sftp_sap_push
     -> SAP SFTP destination
```
