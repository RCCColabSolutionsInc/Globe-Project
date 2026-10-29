# sp_Job_MyBSS_Innove_EOM_Preload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document explains the SQL Server ETL flow driven by:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_All`

The procedure is the parent preload orchestrator for Innove end-of-month MyBSS DP2, DP3, and DP4 flows. It starts three SQL Agent ad hoc jobs and waits for each job to finish before starting the next one.

This document covers the parent procedure, SQL Agent job context, setup cleanup, SSIS extract context, child preload procedures, SAP lookup refresh, transform/export/report/SFTP behavior, important source and target tables, report selector behavior, and operational risks visible in the repository.

## Executive Summary

`sp_Job_MyBSS_Innove_EOM_Preload_All` does not transform data directly. It assumes the setup cleanup and upstream SSIS extract jobs have already loaded Innove EOM source data into `sdbTDIR2_Innove` tables, then runs the three domain preload jobs in SQL Agent job-name order.

At a high level, the process:

1. Starts the DP2 Unearned MSF, DP3 Unbilled Charges, and DP4 Unbilled Adjustments ad hoc preload jobs.
2. Refreshes SAP lookup/reference tables in each child job before transformation.
3. Loads raw SAP interface rows from `sdbTDIR2_Innove` into Innove staging tables.
4. Applies generated source-rule procedures to populate normalized columns, batch numbers, DSP order values, and unique keys.
5. Deletes and reloads domain target tables in `dswTDIR2_Innove` for `zSource = 'TDIR2_Innove'`.
6. Updates `zLoaded` from SAP latest-log messages, with different downstream selector behavior by domain.
7. Exports SAP preload text files under `F:\BOA\Transform\Export\TDIR2-MyBSS\Innove`.
8. Rebuilds report cache tables, triggers SSRS subscriptions to create Excel files, sends notification emails for nonempty caches, and starts matching SFTP jobs asynchronously.

The parent and child preload procedures have no date, cycle, period, or run-id parameter. Period behavior is implicit through SQL Agent schedule timing, global source/target tables, and report/export logic that uses the prior calendar month from `GETDATE()`.

## Source Files Reviewed

| Area | Representative files |
| --- | --- |
| Parent procedure | `dswTDIR2_Innove/programmability/stored_procedures/dbo.sp_Job_MyBSS_Innove_EOM_Preload_All.StoredProcedure.sql` |
| SQL Agent metadata | `sql-agent-jobs.txt` |
| Pipeline inventory | `etl_pipelines.txt` |
| Setup cleanup | `sdbTDIR2_Innove/programmability/stored_procedures/dbo.sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03.StoredProcedure.sql` |
| Child preload jobs | `dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unearned_MSF`, `dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Char`, `dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Adj` |
| SAP lookup refresh | `dswTDIR2_Innove/programmability/stored_procedures/dbo.sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables.StoredProcedure.sql` |
| Transform procedures | `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Transform`, `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Transform`, `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Transform` |
| Generated source-rule procedures and views | `srInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I_*`, `srInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I_*`, `srInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i_*` |
| Loaded-status rules | `trInnove_Unearned_MSF_zloaded_Upd`, `trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd`, `trInnove_Unbilled_Char_zLoaded_1Upd`, `trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd`, `trInnove_Unbilled_Adj_zloaded_Upd`, `trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd` |
| Export procedures and selectors | `sp_MyBSS_Innove_EOM_Preload_*_Export`, `sp_MyBSS_Innove_EOM_Preload_*_Export_LoadFileSel`, `txInnove_*_LoadFileSel`, `tvInnove_*_PreloadRptSel` |
| Report procedures | `sp_MyBSS_Innove_EOM_Preload_*_Report_Prepare`, `*_Report_Export`, `*_Report_Send`, and `sp_rpt_Innove_Preload_*_SSRS` dataset procedures |
| SFTP procedures | `sp_MyBSS_Innove_EOM_Preload_DP2_SFTP`, `sp_MyBSS_Innove_EOM_Preload_DP3_SFTP`, `sp_MyBSS_Innove_EOM_Preload_DP4_SFTP` |
| Source tables | `sdbTDIR2_Innove.dbo.sap_airc_I`, `sap_aiuc_I`, `sap_glunbilled_i`, `sap_glunbilled_unconf_I`, `324_Unearned_MSF_Summary_Report_I`, `317_Unbilled_Charges_I`, `307_Unbilled_Adjustments_Report_I` |
| Staging and target tables | `stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I`, `stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I`, `stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i`, `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, `ttInnove_Unbilled_Adj` |
| Report cache tables | `rpt_Preload_Report_Unearned_MSF_*_Cache`, `rpt_Preload_Report_Unbilled_Char_*_Cache`, `rpt_Preload_Report_Unbilled_Adj_*_Cache` |
| SAP and mapping views | `dbo.ZTF0001S`, `dbo.ZTF0002S`, `dbo.ZFFI_SUBTYPE`, `dbo.ZFFI_0346`, `dbo.ZFFI_REPORT_ODBC_LATESTLOGS` |
| Historical references | Commented source cleanup blocks in the transform procedures and inactive `tvInnove_*_NotInnove_SubTypeRptSel` views. |

## Databases and External Dependencies

| Dependency | Usage |
| --- | --- |
| `dswTDIR2_Innove` | Main working database for Innove EOM preload orchestration, child procedures, staging tables, target tables, SAP wrapper views, export selectors, report cache tables, and SSRS dataset procedures. |
| `sdbTDIR2_Innove` | Source/extract database populated by SSIS packages. Contains raw Innove source tables such as `sap_airc_I`, `sap_aiuc_I`, `sap_glunbilled_i`, `sap_glunbilled_unconf_I`, and summary report extracts. |
| `dswTDIR2_Innove_Cache` | Listed in `etl_pipelines.txt` for the Innove EOM pipeline. The reviewed active report cache tables are scripted under `dswTDIR2_Innove`. |
| `dgS4HANA_TDIR1` | SAP lookup/reference database and SAP latest-log source used through local Innove wrapper views. |
| `etl_db` | Shared ETL helper database. Used for SQL Agent job lookup, job completion polling, execution logging, text export, text cleanup, and SFTP helpers. |
| `msdb` | Starts SQL Agent jobs through `msdb.dbo.sp_start_job` and sends report notifications through Database Mail. |
| `ReportServer$DACPRD` | Used to locate SSRS subscriptions, trigger `TimedSubscription` events through `AddEvent`, and poll report-server event rows. |
| Windows file system | Writes SAP preload files and SSRS Excel files under `F:\BOA\Transform\Export\TDIR2-MyBSS\Innove` and `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove`. |
| Database Mail | Sends report notifications through profile `SSRS`. |
| `xp_cmdshell` | Deletes existing SSRS `.xlsx` files before subscription export. |

Important helper procedures and functions:

- `etl_db.dbo.vw_SqlJobs`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `etl_db.dbo.sp_ExportTextFile`
- `etl_db.dbo.fn_CleanTxt`
- `etl_db.dbo.sp_sftp_sap_del`
- `etl_db.dbo.sp_sftp_sap_push`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_SUBTYPE`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_0346`
- `msdb.dbo.sp_start_job`
- `msdb.dbo.sp_send_dbmail`
- `ReportServer$DACPRD.dbo.AddEvent`
- `xp_cmdshell`

Local wrapper views for `ZTF0001S`, `ZTF0002S`, `ZFFI_SUBTYPE`, `ZFFI_0346`, and `ZFFI_REPORT_ODBC_LATESTLOGS` read from `dgS4HANA_TDIR1`. The batch-number rules and missing-subtype reports filter Innove company code `INOV`.

## SQL Agent Context

The relevant Innove EOM SQL Agent chain is defined in `sql-agent-jobs.txt`.

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
| `MyBss_Innove_sap_glunbilled_unconf` | DP4 unconfirmed SAP GL unbilled source used directly by the DP4 preload selector. |

The parent preload job starts these child ad hoc preload jobs:

| Parent sequence | SQL Agent job | T-SQL command |
| ---: | --- | --- |
| 1 | `MyBSS_Innove_EOM_DP2_P10_Preload_UMSF_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unearned_MSF` |
| 2 | `MyBSS_Innove_EOM_DP3_P10_Preload_UC_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Char` |
| 3 | `MyBSS_Innove_EOM_DP4_P10_Preload_UA_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Adj` |

Each child preload job starts a matching SFTP ad hoc job:

| Preload job | SFTP job |
| --- | --- |
| `MyBSS_Innove_EOM_DP2_P10_Preload_UMSF_AdHoc` | `MyBSS_Innove_EOM_DP2_P15_Preload_UMSF_SFTP_AdHoc` |
| `MyBSS_Innove_EOM_DP3_P10_Preload_UC_AdHoc` | `MyBSS_Innove_EOM_DP3_P15_Preload_UC_SFTP_AdHoc` |
| `MyBSS_Innove_EOM_DP4_P10_Preload_UA_AdHoc` | `MyBSS_Innove_EOM_DP4_P15_Preload_UA_SFTP_AdHoc` |

Important observed detail:

`etl_pipelines.txt` lists the Innove EOM pipeline with `dswTDIR2_Innnove`, with an extra `n`, and leaves the SQL Agent job list blank. `sql-agent-jobs.txt` has the operational job chain. The extract job name also uses lowercase `innove` in `MyBSS_innove_EOM_00_P02_Extract_03Mth`, while the related setup/preload/postload jobs use `Innove`.

## Cleanup Process

The setup cleanup procedure is not called by `sp_Job_MyBSS_Innove_EOM_Preload_All`. It is run by its own SQL Agent job before extract and preload.

Procedure:

`sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_CleanupBeforeProcess_03`

The cleanup truncates source extract tables and Innove target tables globally:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Innove` | `307_Unbilled_Adjustments_Report_I`, `317_Unbilled_Charges_I`, `324_Unearned_MSF_Summary_Report_I`, `sap_airc_I`, `sap_aiuc_I`, `sap_glunbilled_i`, `sap_glunbilled_unconf_I` |
| `dswTDIR2_Innove` | `ttInnove_Unearned_MSF`, `ttInnove_Unbilled_Char`, `ttInnove_Unbilled_Adj` |

There is no period, run-id, partition, or cycle filter. The cleanup is destructive for the full Innove EOM working set.

## Parameter Mapping

The parent procedure has no input parameters. The child preload procedures also have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / operating company | Hard-coded through Innove-specific procedures, target tables, source suffix `_I`, job names, report names, paths, and SAP filters such as `BUKRS = 'INOV'` and `ZBUKRS = 'INOV'`. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable in the reviewed EOM preload procedures. |
| Domain | Hard-coded by child jobs: DP2 Unearned MSF, DP3 Unbilled Charges, and DP4 Unbilled Adjustments. |
| Run state | Stored in global staging, target, and report cache tables. |
| Report files | Subscription descriptions contain `_MMYY`, replaced with the previous month keyword at runtime. |
| SFTP routing | Hard-coded SFTP key names are passed to `etl_db.dbo.sp_sftp_sap_del` and `etl_db.dbo.sp_sftp_sap_push`. |

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable of three ad hoc SQL Agent job names.
3. Looks up those job names in `etl_db.dbo.vw_SqlJobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the poll loop when the job is complete or when the iteration count reaches `@MaxIteration`.
8. Moves to the next job.

Important behavior:

- Missing job names are skipped because the cursor is built from an inner join to `etl_db.dbo.vw_SqlJobs`.
- The parent checks only whether the SQL Agent job completed. It does not inspect child job success or failure status.
- If a child job does not finish before the polling limit, the parent stops waiting and proceeds to the next job.
- The active code waits up to roughly five minutes per child job. The source comment says "`240 seconds or 5 mins`" even though 60 iterations at 5 seconds is 300 seconds.
- The child jobs start their SFTP jobs asynchronously. The parent does not wait for SFTP completion.

Each child preload procedure executes the same step pattern:

1. `sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`
2. Domain transform procedure
3. Domain export procedure
4. Domain report prepare procedure
5. Domain report export procedure
6. Domain report send procedure
7. `msdb.dbo.sp_start_job` for the domain SFTP job

The child procedures execute transform/export/report steps through `etl_db.dbo.sp_ExecuteQueryAndLog` with:

| Field | Value pattern |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Innove` |
| `@Step` | Domain-specific value such as `Unearned_MSF - Preload` |
| `@Others` | `EOM` |

Important observed detail:

The variable name `@Proccess` is spelled with two `c` characters in the reviewed child procedures. The spelling is preserved here because it appears in source.

## Step 1: Start DP2, DP3, and DP4 Ad Hoc Preload Jobs

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_All`

The parent starts these jobs sequentially:

| Sequence | Job name | Purpose |
| ---: | --- | --- |
| 1 | `MyBSS_Innove_EOM_DP2_P10_Preload_UMSF_AdHoc` | Runs DP2 Unearned MSF preload. |
| 2 | `MyBSS_Innove_EOM_DP3_P10_Preload_UC_AdHoc` | Runs DP3 Unbilled Charges preload. |
| 3 | `MyBSS_Innove_EOM_DP4_P10_Preload_UA_AdHoc` | Runs DP4 Unbilled Adjustments preload. |

Each SQL Agent job contains a T-SQL step that calls the corresponding child procedure in `dswTDIR2_Innove`.

## Step 2: Refresh SAP Lookup Tables

Procedure:

`dswTDIR2_Innove.dbo.sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`

Each child preload procedure calls this procedure before transforming its own domain. Therefore, a full parent run refreshes the same SAP lookup/reference tables three times.

Called procedures:

| Procedure | Purpose inferred from name and usage |
| --- | --- |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0002S` | Refreshes SAP transfer/reference table `ZTF0002S`. |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0001S` | Refreshes SAP transfer/reference table used by header batch-number rules. |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_SUBTYPE` | Refreshes SAP subtype reference data used by missing-subtype reports. |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_0346` | Refreshes SAP charge code/reference data used by missing-charge-code reports. |

## Step 3: DP2 Unearned MSF Preload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unearned_MSF`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Innove` |
| `@Step` | `Unearned_MSF - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Transform`
3. `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Export`
4. `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Report_Prepare`
5. `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Report_Export`
6. `dbo.sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Report_Send`
7. Starts `MyBSS_Innove_EOM_DP2_P15_Preload_UMSF_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Innove.dbo.stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I`

It then inserts `Column1` through `Column15` plus `zrownumber` from:

`sdbTDIR2_Innove.dbo.sap_airc_I`

Only rows where `Column1 IN ('00', '01', '99')` are loaded.

### Source Rule Updates

Generated rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn15Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `Column05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using source `Column2` as `FROM_SYSTEM`, `Column3` as `TO_SYSTEM`, `Column4` as `EVENT`, and `BUKRS = 'INOV'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('IUnearnedMSF' + '-' + zrownumber + '-' + Column2, 44)`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Innove'`. |
| `Ins` | Inserts staged rows into `ttInnove_Unearned_MSF`. |
| `trInnove_Unearned_MSF_zloaded_Upd` | Marks detail rows loaded when matched to SAP latest-log rows without handled error messages. |
| `trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd` | Resets loaded status to `0` for rows whose `zSource` appears in the error-line view. |

Target table:

`dswTDIR2_Innove.dbo.ttInnove_Unearned_MSF`

### Export Selector

The export writes:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Innove\ttInnove_Unearned_MSF_New` |
| File | `txInnove_Unearned_MSF_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Innove_EOM_Preload_Unearned_MSF_Export_LoadFileSel` |
| Source view | `txInnove_Unearned_MSF_LoadFileSel` / `tvInnove_Unearned_MSF_PreloadRptSel` |

The export selector cleans values through `etl_db.dbo.fn_CleanTxt`, recalculates footer `Column03` as the sum of detail-row `Column07`, formats header `Column07` as `decimal(18,0)`, and formats other `Column07` values as `decimal(18,2)`.

Important observed detail:

`tvInnove_Unearned_MSF_PreloadRptSel` selects from `ttInnove_Unearned_MSF` without filtering on `zLoaded`. The transform updates `zLoaded`, but the reviewed DP2 export selector does not use that flag to exclude rows.

### Report Cache

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unearned_MSF_SubtypeMissing_Cache` | `tvInnove_Unearned_MSF_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unearned_MSF_ChargeCodeMissing_Cache` | `tvInnove_Unearned_MSF_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unearned_MSF_Preload_Cache` | `tvInnove_Unearned_MSF_PreloadRptSel` |
| `rpt_Preload_Report_Unearned_MSF_VarianceInTotalAmount_Cache` | `tvInnove_Unearned_MSF_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttInnove_Unearned_MSF.Column07` to numeric `Total Unearned RC` values from `sdbTDIR2_Innove.dbo.324_Unearned_MSF_Summary_Report_I`.

SSRS subscription patterns:

| Pattern |
| --- |
| `Inov_UMSF_Preload_DP2_MMYY_SubsTypeMissing` |
| `Inov_UMSF_Preload_DP2_MMYY_ChargeCodeMissing` |
| `Inov_UMSF_Preload_DP2_MMYY` |
| `Inov_UMSF_Preload_DP2_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unearned_MSF_SSRS`

The SFTP job calls `sp_MyBSS_Innove_EOM_Preload_DP2_SFTP`, which deletes and pushes using:

| Key type | Value |
| --- | --- |
| Delete key | `03_txInnove_Unearned_MSF_Del` |
| Push key | `01_txInnove_Unearned_MSF_Push` |

## Step 4: DP3 Unbilled Charges Preload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Char`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Innove` |
| `@Step` | `Unbilled_Char - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Transform`
3. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Export`
4. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Report_Prepare`
5. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Report_Export`
6. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Report_Send`
7. Starts `MyBSS_Innove_EOM_DP3_P15_Preload_UC_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Innove.dbo.stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I`

It then inserts `Column1` through `Column17` plus `zrownumber` from:

`sdbTDIR2_Innove.dbo.sap_aiuc_I`

Only rows where `Column1 IN ('00', '01', '99')` are loaded.

### Source Rule Updates

Generated rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn17Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `Column05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using source `Column2`, `Column3`, `Column4`, and `BUKRS = 'INOV'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('IUnbilledChg' + '-' + zrownumber + '-' + Column2, 44)`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Innove'`. |
| `Ins` | Inserts staged rows into `ttInnove_Unbilled_Char`. |
| `trInnove_Unbilled_Char_zLoaded_1Upd` | Marks detail rows loaded when matched to SAP latest-log rows without handled error messages. |
| `trInnove_Unbilled_Char_zLoaded_0_Error_LineUpd` | Resets loaded status to `0` for rows whose `zSource` appears in the error-line view. |

Target table:

`dswTDIR2_Innove.dbo.ttInnove_Unbilled_Char`

### Export Selector

The export writes:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Char_New` |
| File | `txInnove_Unbilled_Char_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Export_LoadFileSel` |
| Source view | `txInnove_Unbilled_Char_LoadFileSel` / `tvInnove_Unbilled_Char_PreloadRptSel` |

The export selector cleans values through `etl_db.dbo.fn_CleanTxt`, recalculates footer `Column03` as the sum of detail-row `Column07`, formats header `Column07` as `decimal(18,0)`, and formats other `Column07` values as `decimal(18,2)`.

Important observed detail:

`tvInnove_Unbilled_Char_PreloadRptSel` filters `ttInnove_Unbilled_Char` to `zLoaded = '0'`. DP3 therefore excludes rows already marked loaded by SAP latest-log matching, unlike the reviewed DP2 and DP4 preload selectors.

### Report Cache

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unbilled_Char_SubtypeMissing_Cache` | `tvInnove_Unbilled_Char_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Char_ChargeCodeMissing_Cache` | `tvInnove_Unbilled_Char_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Char_Preload_Cache` | `tvInnove_Unbilled_Char_PreloadRptSel` |
| `rpt_Preload_Report_Unbilled_Char_VarianceInTotalAmount_Cache` | `tvInnove_Unbilled_Char_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttInnove_Unbilled_Char.Column07` to `Amount` from `sdbTDIR2_Innove.dbo.317_Unbilled_Charges_I`.

SSRS subscription patterns:

| Pattern |
| --- |
| `Inov_UC_Preload_DP3_MMYY_SubsTypeMissing` |
| `Inov_UC_Preload_DP3_MMYY_ChargeCodeMissing` |
| `Inov_UC_Preload_DP3_MMYY` |
| `Inov_UC_Preload_DP3_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Char_SSRS`

The SFTP job calls `sp_MyBSS_Innove_EOM_Preload_DP3_SFTP`, which deletes and pushes using:

| Key type | Value |
| --- | --- |
| Delete key | `03_txInnove_Unbilled_Char_Del` |
| Push key | `01_txInnove_Unbilled_Char_Push` |

## Step 5: DP4 Unbilled Adjustments Preload

Procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOM_Preload_Unbilled_Adj`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Innove` |
| `@Step` | `Unbilled_Adj - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Transform`
3. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Export`
4. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Report_Prepare`
5. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Report_Export`
6. `dbo.sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Report_Send`
7. Starts `MyBSS_Innove_EOM_DP4_P15_Preload_UA_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Innove.dbo.stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i`

It then inserts `Column1` through `Column13` plus `zrownumber` from:

`sdbTDIR2_Innove.dbo.sap_glunbilled_i`

Only rows where `Column1 IN ('00', '01', '99')` are loaded into the staging table.

### Source Rule Updates

Generated rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn13Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `Column05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using source `Column2`, `Column3`, `Column4`, and `BUKRS = 'INOV'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('IUnbilledAdj' + '-' + zrownumber + '-' + Column2, 44)`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Innove'`. |
| `Ins` | Inserts staged rows into `ttInnove_Unbilled_Adj`. |
| `trInnove_Unbilled_Adj_zloaded_Upd` | Marks detail rows loaded when matched to SAP latest-log rows without handled error messages. |
| `trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd` | Resets loaded status to `0` for rows whose `zSource` appears in the error-line view. |

Target table:

`dswTDIR2_Innove.dbo.ttInnove_Unbilled_Adj`

### Export Selector

The export writes:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Adj_New` |
| File | `txInnove_Unbilled_Adj_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Export_LoadFileSel` |
| Source view | `txInnove_Unbilled_Adj_LoadFileSel` / `tvInnove_Unbilled_Adj_PreloadRptSel` |

The DP4 preload selector has extra behavior:

- `tvInnove_Unbilled_Adj_Preload010RptSel` selects target rows from `ttInnove_Unbilled_Adj` where `Column01 <> 99`.
- The same view unions detail rows from `sdbTDIR2_Innove.dbo.sap_glunbilled_unconf_I` where `Column1 = '01'`.
- Unconfirmed rows emit `Column1` through `Column9`, blank `Column10` through `Column13`, `zrownumber` as `zDSP_Order`, and `Left('ISapGLUnBilled' + '-' + zrownumber + '-' + Column2, 44)` as `zDSP_UniqueKey`.
- `tvInnove_Unbilled_Adj_PreloadRptSel` adds a regenerated footer row with `Column01 = '99'`, detail count, and detail amount sum from `tvInnove_Unbilled_Adj_Preload010RptSel`.
- `sp_MyBSS_Innove_EOM_Preload_Unbilled_Adj_Export_LoadFileSel` again recalculates footer `Column03` as the sum of detail-row `Column07`.

Important observed detail:

The DP4 export path includes unconfirmed rows from `sap_glunbilled_unconf_I` directly in the selector. Those rows do not pass through the DP4 transform source-rule procedures, target table insert, or target `zLoaded` updates.

### Report Cache

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unbilled_Adj_SubtypeMissing_Cache` | `tvInnove_Unbilled_Adj_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_ChargeCodeMissing_Cache` | `tvInnove_Unbilled_Adj_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_Preload_Cache` | `tvInnove_Unbilled_Adj_PreloadRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_VarianceInTotalAmount_Cache` | `tvInnove_Unbilled_Adj_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttInnove_Unbilled_Adj.Column07` to `Amount` from `sdbTDIR2_Innove.dbo.307_Unbilled_Adjustments_Report_I`. It does not include the directly unioned `sap_glunbilled_unconf_I` rows.

The charge-code-missing view reads from `tvInnove_Unbilled_Adj_PreloadRptSel`, so it can include directly unioned unconfirmed rows. The subtype-missing view reads from `ttInnove_Unbilled_Adj`, so it does not include those unconfirmed rows.

SSRS subscription patterns:

| Pattern |
| --- |
| `Inov_UA_Preload_DP4_MMYY_SubsTypeMissing` |
| `Inov_UA_Preload_DP4_MMYY_ChargeCodeMissing` |
| `Inov_UA_Preload_DP4_MMYY` |
| `Inov_UA_Preload_DP4_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Unbilled_Adj_SSRS`

The SFTP job calls `sp_MyBSS_Innove_EOM_Preload_DP4_SFTP`, which deletes and pushes using:

| Key type | Value |
| --- | --- |
| Delete key | `03_txInnove_Unbilled_Adj_Del` |
| Push key | `01_txInnove_Unbilled_Adj_Push` |

## Shared Reporting Behavior

Each domain exports four SSRS reports:

| Report type | Purpose |
| --- | --- |
| Subtype missing | Lists detail rows whose subtype is not found in `ZFFI_SUBTYPE` for `ZBUKRS = 'INOV'`. |
| Charge code missing | Lists detail rows whose charge code is not found in `ZFFI_0346`. |
| Preload | Full preload output dataset for the domain selector. |
| Variance in total amount | Compares transformed SAP preload totals to the corresponding MyBSS summary report total. |

Report export behavior:

1. Compute previous month keyword with `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`.
2. Create dynamic file/subscription names by replacing `_MMYY` with the computed keyword.
3. Match SSRS subscriptions using the literal subscription description pattern containing `_MMYY`.
4. Delete the expected `.xlsx` file with `xp_cmdshell`.
5. Trigger the SSRS timed subscription through `ReportServer$DACPRD.dbo.AddEvent`.
6. Poll the SSRS event queue every 3 seconds, up to 25 iterations.

Report send behavior:

1. Recompute the previous month keyword.
2. Count rows in each report cache.
3. Send email only when `recordcount > 0`.
4. Attach the generated `.xlsx` file for the dynamic subscription name.

Email profile and recipients:

| Field | Value |
| --- | --- |
| Profile | `SSRS` |
| Recipients | `harvey.tiong@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;princess.ortilano@globe.com.ph;jpdacquil@globe.com.ph` |
| Copy recipients | `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph` |
| Subject prefix | `Report Notif: MyBSS` |
| Report server link | `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx` |

## Shared Transform Behavior

The three domain transforms follow the same active pattern:

1. Clear the domain staging table with `DELETE`.
2. Load source rows from the Innove `sdbTDIR2_Innove` extract table.
3. Keep only SAP row types `00`, `01`, and `99` during the staging insert.
4. Populate normalized columns using generated source-rule procedures.
5. Update header batch number from `ZTF0001S.BATCH_NO + 1` for `BUKRS = 'INOV'`.
6. Build detail-row unique keys with Innove-specific prefixes.
7. Delete existing target rows for `zSource = 'TDIR2_Innove'`.
8. Insert transformed staged rows into the domain target table.
9. Update `zLoaded` from SAP latest-log matching.
10. Reset `zLoaded` to `0` by `zSource` when handled SAP error messages exist.

Handled SAP error patterns in the loaded-status rules include:

- `does not exist for`
- `is not allowed for characteristic`
- `requires an assignment to a CO object`
- `Error in document`
- `is not found in table`

Historical reference:

Each transform procedure retains a commented-out source cleanup block that references `sdbTDIR2_Globe.dbo.sap_airc`. The block is inside a SQL comment in the reviewed Innove files and is not active behavior.

## Business Logic Summary

| Domain | Source extract | Staging table | Target table | Unique key prefix | Export `zLoaded` filter |
| --- | --- | --- | --- | --- | --- |
| DP2 Unearned MSF | `sdbTDIR2_Innove.dbo.sap_airc_I` | `stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I` | `ttInnove_Unearned_MSF` | `IUnearnedMSF` | No reviewed filter |
| DP3 Unbilled Charges | `sdbTDIR2_Innove.dbo.sap_aiuc_I` | `stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I` | `ttInnove_Unbilled_Char` | `IUnbilledChg` | `zLoaded = '0'` |
| DP4 Unbilled Adjustments | `sdbTDIR2_Innove.dbo.sap_glunbilled_i` plus selector-only `sap_glunbilled_unconf_I` | `stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i` | `ttInnove_Unbilled_Adj` | `IUnbilledAdj`; selector-only unconfirmed prefix `ISapGLUnBilled` | No reviewed filter |

Common row types:

| `Column1` value | Meaning inferred from procedure behavior |
| --- | --- |
| `00` | Header row. Batch number is updated in `Column05`/`zColumn05`. |
| `01` | Detail row. Unique key and DSP order are emitted. |
| `99` | Footer row. Export selectors recalculate the amount total. |

Batch number logic:

Header rows are matched to `ZTF0001S` using source system, target system, event, and `BUKRS = 'INOV'`. The output batch number is `BATCH_NO + 1`.

Subtype validation:

Missing subtype reports compare detail-row `Column05` to `ZFFI_SUBTYPE.ZSUBTYPE` with `ZBUKRS = 'INOV'`.

Charge code validation:

Missing charge code reports compare detail-row `Column06` to `ZFFI_0346.ZCCODE`. The reviewed charge code missing views do not apply an Innove company-code filter.

Footer and amount handling:

- Export procedures recalculate footer `Column03` from detail `Column07` totals.
- `Column07` is exported as `decimal(18,0)` for header rows and `decimal(18,2)` for other rows.
- DP4 regenerates a footer in `tvInnove_Unbilled_Adj_PreloadRptSel` and then recalculates it again in the export stored procedure.

## Operational Risks and Gaps

| Risk or gap | Impact |
| --- | --- |
| No period/run parameter | Runs are tied to current server date and global table contents. Reruns outside the expected month can produce different report file names and subscription names. |
| Global cleanup | The setup cleanup truncates full source and target tables, not a scoped run partition. |
| Parent only checks completion | `fn_IsJobCompleted` is used for completion polling, but the parent does not verify child job success or failure status. |
| Timeout continues to next job | If a child job exceeds the polling limit, the parent breaks the wait loop and proceeds. |
| Missing job names are skipped | The parent inner joins hard-coded job names to `etl_db.dbo.vw_SqlJobs`; missing jobs are silently absent from the cursor. |
| SFTP is asynchronous | Child preload procedures start SFTP jobs but do not wait for SFTP completion or status. |
| SAP lookups refresh three times | Each child job calls `sp_MyBSS_Innove_EOM_Preload_000_LoadSapTables`, so a full run reloads the same lookup tables repeatedly. |
| Error-line reset is source-scoped | The error-line update joins only by `zSource`, so one handled SAP error for `TDIR2_Innove` can reset loaded status for the domain's source rows rather than only the failing detail row. |
| Inconsistent `zLoaded` selector behavior | DP3 filters preload output to `zLoaded = '0'`, while DP2 and DP4 reviewed selectors do not. This can make rerun behavior differ by domain. |
| DP4 unconfirmed rows bypass transform | `sap_glunbilled_unconf_I` rows are unioned directly into the DP4 preload selector and do not receive the generated transform rules or target-level status updates. |
| Report caches are global | Report prepare procedures truncate and reload full cache tables without period/run scoping. |
| Report email counts can be misleading | Preload caches include normal output rows and variance caches are summary rows, so emails may be sent even when there is no exception condition. |
| SSRS subscription matching depends on template descriptions | The export procedures join `ReportServer$DACPRD.dbo.Subscriptions.Description` to literal `_MMYY` patterns, then use the dynamic month value only for file names. |
| Hard-coded file paths and `xp_cmdshell` | Report export and attachment behavior depends on Windows paths, SQL Server service permissions, and `xp_cmdshell` being enabled. |
| Hard-coded SFTP keys | SFTP routing depends on shared configuration keys such as `01_txInnove_Unbilled_Adj_Push`; missing or changed keys are not validated in these procedures. |
| SQL Agent metadata inconsistency | `etl_pipelines.txt` has the `dswTDIR2_Innnove` typo and no listed Innove EOM jobs; `sql-agent-jobs.txt` has the operational chain. |

## Validation Checklist

Before running or changing this process, validate:

| Check | Reason |
| --- | --- |
| Cleanup job completed before extract | The preload expects fresh source extract tables and globally emptied target tables. |
| Extract job completed successfully | The preload reads from `sdbTDIR2_Innove` source tables populated by SSIS. |
| Parent and child SQL Agent jobs exist in `etl_db.dbo.vw_SqlJobs` | The parent starts jobs by IDs looked up through this view. |
| Child job duration fits the parent wait window | The parent proceeds after its polling limit even if a child job is still not complete. |
| SAP lookup refresh procedures are available | Each child preload calls the common SAP lookup refresh. |
| `ZTF0001S` has current `INOV` batch rows | Header batch numbers are derived from `BATCH_NO + 1`. |
| SAP latest-log data is current | `zLoaded` updates depend on `ZFFI_REPORT_ODBC_LATESTLOGS`. |
| DP3 `zLoaded` behavior is expected | DP3 export/report output excludes loaded rows, unlike DP2 and DP4 reviewed selectors. |
| DP4 unconfirmed source row counts are reviewed | `sap_glunbilled_unconf_I` rows are inserted directly into DP4 preload output. |
| Summary report totals are loaded | Variance reports compare against `324_Unearned_MSF_Summary_Report_I`, `317_Unbilled_Charges_I`, and `307_Unbilled_Adjustments_Report_I`. |
| SSRS subscriptions exist with literal `_MMYY` descriptions | Report export joins subscriptions by the template pattern. |
| `F:\BOA\Transform\Export\...` and `F:\BOA\Transform\Report\...` paths exist | Text exports, SSRS output, and email attachments depend on these paths. |
| Database Mail profile `SSRS` is configured | Report notification procedures use this profile. |
| SFTP keys exist in shared configuration | Domain SFTP procedures call delete and push helpers by hard-coded file key. |
| Report cache row counts are interpreted by report type | A nonzero preload or variance cache does not necessarily mean an exception occurred. |

## High-Level Data Flow

```text
SQL Agent schedule
  -> Setup cleanup job
      -> truncate Innove EOM source extracts and target tables
  -> Extract job
      -> SSIS packages populate sdbTDIR2_Innove source tables
  -> Preload all job
      -> sp_Job_MyBSS_Innove_EOM_Preload_All
          -> DP2 P10 job
              -> refresh SAP lookups
              -> sap_airc_I -> stInnove_Unearned_MSF_* -> ttInnove_Unearned_MSF
              -> update SAP loaded status
              -> export txInnove_Unearned_MSF_LoadFileSel.txt
              -> prepare SSRS caches
              -> export/send reports
              -> start DP2 SFTP job
          -> DP3 P10 job
              -> refresh SAP lookups
              -> sap_aiuc_I -> stInnove_Unbilled_Char_* -> ttInnove_Unbilled_Char
              -> update SAP loaded status
              -> export unloaded rows to txInnove_Unbilled_Char_LoadFileSel.txt
              -> prepare SSRS caches
              -> export/send reports
              -> start DP3 SFTP job
          -> DP4 P10 job
              -> refresh SAP lookups
              -> sap_glunbilled_i -> stInnove_Unbilled_Adj_* -> ttInnove_Unbilled_Adj
              -> union sap_glunbilled_unconf_I rows in preload selector
              -> update SAP loaded status for transformed target rows
              -> export txInnove_Unbilled_Adj_LoadFileSel.txt
              -> prepare SSRS caches
              -> export/send reports
              -> start DP4 SFTP job

External services:
  -> dgS4HANA_TDIR1 supplies SAP lookup/reference/latest-log views
  -> etl_db logs steps, exports text files, and runs SFTP helpers
  -> ReportServer$DACPRD exports Excel reports through timed subscriptions
  -> msdb starts SQL Agent jobs and sends Database Mail
```
