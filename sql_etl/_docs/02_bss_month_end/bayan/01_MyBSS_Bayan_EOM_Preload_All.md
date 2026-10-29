# sp_Job_MyBSS_Bayan_EOM_Preload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document explains the SQL Server ETL flow driven by:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All`

The procedure is the parent preload orchestrator for Bayan end-of-month MyBSS DP2, DP3, and DP4 flows. It starts three SQL Agent ad hoc jobs and waits for each one to finish before starting the next job.

This document covers the parent procedure, the SQL Agent job context, the setup cleanup job, the extract jobs that populate source tables, the child preload procedures, transform/export/report/SFTP steps, key tables and views, and operational risks visible in the repository.

## Executive Summary

`sp_Job_MyBSS_Bayan_EOM_Preload_All` does not transform data directly. It starts three SQL Agent jobs in this order:

| Order | SQL Agent job | Child procedure | Domain |
| --- | --- | --- | --- |
| 1 | `MyBSS_Bayan_EOM_DP2_P10_Preload_UMSF_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unearned_MSF` | DP2 Unearned MSF |
| 2 | `MyBSS_Bayan_EOM_DP3_P10_Preload_UC_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unbilled_Char` | DP3 Unbilled Charges |
| 3 | `MyBSS_Bayan_EOM_DP4_P10_Preload_UA_AdHoc` | `dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unbilled_Adj` | DP4 Unbilled Adjustments |

Each child preload job refreshes SAP lookup/reference tables, transforms flat-file extract data from `sdbTDIR2_Bayan`, exports a SAP preload file under `F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan`, prepares SSRS report caches, triggers SSRS subscriptions to export `.xlsx` reports, sends notification emails for non-empty report caches, then starts a matching SFTP SQL Agent job asynchronously.

The parent procedure has no date, cycle, period, or run-id parameter. The process relies on SQL Agent schedule order and global staging/cache tables. Re-runs and out-of-window executions can overwrite shared state.

## Source Files Reviewed

| Area | Representative files |
| --- | --- |
| Parent procedure | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All.StoredProcedure.sql` |
| SQL Agent metadata | `sql-agent-jobs.txt` |
| Pipeline inventory | `etl_pipelines.txt` |
| Setup cleanup | `sdbTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03.StoredProcedure.sql` |
| Child preload jobs | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unearned_MSF.StoredProcedure.sql`, `...Unbilled_Char...`, `...Unbilled_Adj...` |
| SAP lookup refresh | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables.StoredProcedure.sql` |
| Transform procedures | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_MyBSS_Bayan_EOM_Preload_*_Transform.StoredProcedure.sql` |
| Export procedures | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_MyBSS_Bayan_EOM_Preload_*_Export*.StoredProcedure.sql` |
| Report procedures | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_MyBSS_Bayan_EOM_Preload_*_Report_*.StoredProcedure.sql` and `sp_rpt_Bayan_Preload_*_SSRS` |
| SFTP procedures | `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_MyBSS_Bayan_EOM_Preload_DP*_SFTP.StoredProcedure.sql` |
| ETL helpers | `etl_db` helper functions, views, and stored procedures |

## Databases and External Dependencies

| Dependency | Usage |
| --- | --- |
| `dswTDIR2_Bayan` | Main working database for Bayan EOM preload procedures, staging tables, target tables, views, report caches, and SSRS dataset procedures. |
| `sdbTDIR2_Bayan` | Source/extract database populated by SSIS packages. Contains raw B tables such as `sap_airc_B`, `sap_aiuc_B`, `sap_glunbilled_B`, and supporting summary reports. |
| `dgS4HANA_TDIR1` | SAP lookup/reference database. The preload refresh calls procedures that reload SAP tables used through Bayan views. |
| `etl_db` | Shared ETL helper database. Used for SQL Agent job lookup, job completion polling, logging, text export, text cleanup, and SFTP helpers. |
| `msdb` | Starts SQL Agent jobs through `msdb.dbo.sp_start_job`. |
| `ReportServer$DACPRD` | Used to trigger SSRS subscriptions through `AddEvent` and poll the report server event queue. |
| Windows file system | Writes SAP preload files and SSRS report files under `F:\BOA\Transform\...`. |
| Database Mail | Sends report notifications through profile `SSRS`. |
| `xp_cmdshell` | Deletes existing SSRS `.xlsx` files before triggering subscriptions. |

## SQL Agent Context

The relevant SQL Agent job chain is defined in `sql-agent-jobs.txt`.

| Job | Schedule | Command or package |
| --- | --- | --- |
| `MyBSS_Bayan_EOM_00_P01_Setup_Cleanup_03Mth` | Monthly, every 3rd at 9:00 AM | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03]` |
| `MyBSS_Bayan_EOM_00_P02_Extract_03Mth` | Monthly, every 3rd at 11:20 AM | Runs eight SSIS extract packages into `sdbTDIR2_Bayan`. |
| `MyBSS_Bayan_EOM_00_P10_Preload_All_03Mth` | Monthly, start date `2023-09-01 11:30:00` | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_Preload_All];` |
| `MyBSS_Bayan_EOM_00_P20_Postload_All_03Mth` | Monthly, start date `2023-09-01 13:30:00` | `EXEC [dbo].[sp_Job_MyBSS_Bayan_EOM_Postload_All];` |

The extract job includes packages for these source tables and reports:

| Extract package | Target area |
| --- | --- |
| `MyBss_Bayan_307_Unbilled_Adjustments_Report` | DP4 adjustment summary support |
| `MyBss_Bayan_317_Unbilled_Charges_Summary_Report` | DP3 charge summary support |
| `MyBss_Bayan_317_Unbilled_Charges_Summary_Report_V2(RowStartsAtRow5)` | DP3 charge summary support |
| `MyBss_Bayan_324_Unearned_MSF_Summary_Report` | DP2 unearned MSF summary support |
| `MyBss_Bayan_sap_airc` | DP2 SAP AIRC source |
| `MyBss_Bayan_sap_aiuc` | DP3 SAP AIUC source |
| `MyBss_Bayan_sap_glunbilled` | DP4 SAP GL unbilled source |
| `MyBss_Bayan_sap_glunbilled_unconf` | DP4 unconfirmed SAP GL unbilled source |

`etl_pipelines.txt` lists the Bayan EOM pipeline but leaves its SQL Agent job list blank. The actual job list is present in `sql-agent-jobs.txt`.

## Cleanup Process

The setup cleanup procedure is not called by `sp_Job_MyBSS_Bayan_EOM_Preload_All`. It is run by its own SQL Agent job before extract and preload.

Procedure:

`sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_CleanupBeforeProcess_03`

The cleanup truncates source extract tables and Bayan target tables globally:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Bayan` | `307_Unbilled_Adjustments_Report_B`, `317_Unbilled_Charges_B`, `324_Unearned_MSF_Summary_Report_B`, `sap_airc_B`, `sap_airc_unconf_B`, `sap_aiuc_B`, `sap_aiuc_unconf_B`, `sap_glunbilled_B`, `sap_glunbilled_unconf_B` |
| `dswTDIR2_Bayan` | `ttBayan_Unearned_MSF`, `ttBayan_Unbilled_Char`, `ttBayan_Unbilled_Adj` |

There is no period, run-id, or partition filter. The cleanup is destructive for the full working set.

## Parameter Mapping

The parent procedure has no input parameters. The child preload procedures also have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / operating company | Hard-coded through Bayan-specific procedures, tables, jobs, paths, and `BUKRS = 'BAYN'` checks in selected views. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable in the EOM preload procedures reviewed. |
| Domain | Hard-coded by job/procedure names: DP2 UMSF, DP3 UC, DP4 UA. |
| Run state | Stored in global staging, target, and report cache tables. |

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable of three ad hoc SQL Agent job names.
3. Looks up those job names in `etl_db.dbo.vw_SqlJobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the poll loop when the job is complete or the iteration count exceeds `@MaxIteration`.
8. Moves to the next job.

Important behavior:

- Missing job names are skipped because the cursor is built from an inner join to `etl_db.dbo.vw_SqlJobs`.
- The parent checks only whether the SQL Agent job completed. It does not inspect success or failure status.
- If a child job does not finish before the polling limit, the parent stops waiting and proceeds to the next job.
- The child jobs start their SFTP jobs asynchronously. The parent does not wait for SFTP completion.

## Step 1: Start DP2, DP3, and DP4 Ad Hoc Preload Jobs

Procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_All`

The parent starts these jobs sequentially:

| Sequence | Job name | Purpose |
| --- | --- | --- |
| 1 | `MyBSS_Bayan_EOM_DP2_P10_Preload_UMSF_AdHoc` | Runs DP2 Unearned MSF preload. |
| 2 | `MyBSS_Bayan_EOM_DP3_P10_Preload_UC_AdHoc` | Runs DP3 Unbilled Charges preload. |
| 3 | `MyBSS_Bayan_EOM_DP4_P10_Preload_UA_AdHoc` | Runs DP4 Unbilled Adjustments preload. |

Each SQL Agent job contains a T-SQL step that calls the corresponding child procedure in `dswTDIR2_Bayan`.

## Step 2: Refresh SAP Lookup Tables

Procedure:

`dswTDIR2_Bayan.dbo.sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables`

Each child preload procedure calls this procedure before transforming its own domain. Therefore, a full parent run refreshes the same SAP lookup/reference tables three times.

Called procedures:

| Procedure | Purpose inferred from name and usage |
| --- | --- |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0002S` | Refreshes SAP transfer/reference table `ZTF0002S`. |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0001S` | Refreshes SAP transfer/reference table `ZTF0001S`. |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_SUBTYPE` | Refreshes SAP subtype reference data. |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_0346` | Refreshes SAP charge code/reference data. |

The Bayan views in `dswTDIR2_Bayan` read from `dgS4HANA_TDIR1` and generally filter SAP client `MANDT = N'300'`.

## Step 3: DP2 Unearned MSF Preload

Child procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unearned_MSF`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Bayan` |
| `@Step` | `Unearned_MSF - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Transform`
3. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Export`
4. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Report_Prepare`
5. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Report_Export`
6. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Report_Send`
7. Starts `MyBSS_Bayan_EOM_DP2_P15_Preload_UMSF_SFTP_AdHoc`

The transform deletes from staging table:

`dswTDIR2_Bayan.dbo.stBayan_Unearned_MSF_TDIR2_Bayan_sap_airc_B`

It then inserts `Column1` through `Column15` plus `zrownumber` from:

`sdbTDIR2_Bayan.dbo.sap_airc_B`

Only rows where `Column1 IN ('00', '01', '99')` are loaded.

Generated source-rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn15Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `__Column05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using `FROM_SYSTEM`, `TO_SYSTEM`, `EVENT`, and `BUKRS = 'BAYN'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('BUnearnedMSF' + '-' + zrownumber + '-' + Column2, 44)`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Bayan'`. |
| `Ins` | Inserts staged rows into `ttBayan_Unearned_MSF`. |
| `trBayan_Unearned_MSF_zloaded_Upd` | Marks target rows loaded when matched to latest SAP ODBC logs without a "does not exist for" message. |

Target table:

`dswTDIR2_Bayan.dbo.ttBayan_Unearned_MSF`

Export file:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Unearned_MSF_New` |
| File | `txBayan_Unearned_MSF_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Bayan_EOM_Preload_Unearned_MSF_Export_LoadFileSel` |
| Source view | `txBayan_Unearned_MSF_LoadFileSel` / `tvBayan_Unearned_MSF_PreloadRptSel` |

The export formats `Column07` as decimal. Header rows use `decimal(18,0)` and other rows use `decimal(18,2)`.

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unearned_MSF_SubtypeMissing_Cache` | `tvBayan_Unearned_MSF_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unearned_MSF_ChargeCodeMissing_Cache` | `tvBayan_Unearned_MSF_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unearned_MSF_Preload_Cache` | `tvBayan_Unearned_MSF_PreloadRptSel` |
| `rpt_Preload_Report_Unearned_MSF_VarianceInTotalAmount_Cache` | `tvBayan_Unearned_MSF_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttBayan_Unearned_MSF.Column07` to summary total `Total Unearned RC` from `sdbTDIR2_Bayan.dbo.324_Unearned_MSF_Summary_Report_B`.

SSRS subscription patterns:

| Pattern |
| --- |
| `Bayn_UMSF_Preload_DP2_MMYY_SubsTypeMissing` |
| `Bayn_UMSF_Preload_DP2_MMYY_ChargeCodeMissing` |
| `Bayn_UMSF_Preload_DP2_MMYY` |
| `Bayn_UMSF_Preload_DP2_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unearned_MSF_SSRS`

The SFTP job calls `sp_MyBSS_Bayan_EOM_Preload_DP2_SFTP`, which deletes and pushes using keys:

| Key type | Value |
| --- | --- |
| Delete key | `03_txBayan_Unearned_MSF_Del` |
| Push key | `01_txBayan_Unearned_MSF_Push` |

## Step 4: DP3 Unbilled Charges Preload

Child procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unbilled_Char`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Bayan` |
| `@Step` | `Unbilled_Char - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Transform`
3. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Export`
4. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Report_Prepare`
5. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Report_Export`
6. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Report_Send`
7. Starts `MyBSS_Bayan_EOM_DP3_P15_Preload_UC_SFTP_AdHoc`

The transform deletes from staging table:

`dswTDIR2_Bayan.dbo.stBayan_Unbilled_Char_TDIR2_Bayan_sap_aiuc_B`

It then inserts `Column1` through `Column17` plus `zrownumber` from:

`sdbTDIR2_Bayan.dbo.sap_aiuc_B`

Only rows where `Column1 IN ('00', '01', '99')` are loaded.

Generated source-rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn17Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `Column05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using `BUKRS = 'BAYN'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('BUnbiledChg' + '-' + zrownumber + '-' + Column2, 44)`. The source literal uses `BUnbiledChg`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Bayan'`. |
| `Ins` | Inserts staged rows into `ttBayan_Unbilled_Char`. |
| `trBayan_Unbilled_Char_zloaded_Upd` | Marks target rows loaded when matched to latest SAP ODBC logs without a "does not exist for" message. |

Target table:

`dswTDIR2_Bayan.dbo.ttBayan_Unbilled_Char`

Export file:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Char_New` |
| File | `txBayan_Unbilled_Char_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Export_LoadFileSel` |
| Source view | `txBayan_Unbilled_Char_LoadFileSel` / `tvBayan_Unbilled_Char_PreloadRptSel` |

The export selector emits `Column16` twice and does not emit `Column15`. This is active source behavior in `sp_MyBSS_Bayan_EOM_Preload_Unbilled_Char_Export_LoadFileSel`.

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unbilled_Char_SubtypeMissing_Cache` | `tvBayan_Unbilled_Char_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Char_ChargeCodeMissing_Cache` | `tvBayan_Unbilled_Char_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Char_Cache` | `tvBayan_Unbilled_Char_PreloadRptSel` |
| `rpt_Preload_Report_Unbilled_Char_VarianceInTotalAmount_Cache` | `tvBayan_Unbilled_Char_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttBayan_Unbilled_Char.Column07` to `Amount` from `sdbTDIR2_Bayan.dbo.317_Unbilled_Charges_B`.

SSRS subscription patterns:

| Pattern |
| --- |
| `Bayn_UC_Preload_DP3_MMYY_SubsTypeMissing` |
| `Bayn_UC_Preload_DP3_MMYY_ChargeCodeMissing` |
| `Bayn_UC_Preload_DP3_MMYY` |
| `Bayn_UC_Preload_DP3_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Char_SSRS`

The SFTP job calls `sp_MyBSS_Bayan_EOM_Preload_DP3_SFTP`, which deletes and pushes using keys:

| Key type | Value |
| --- | --- |
| Delete key | `03_txBayan_Unbilled_Char_Del` |
| Push key | `01_txBayan_Unbilled_Char_Push` |

## Step 5: DP4 Unbilled Adjustments Preload

Child procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOM_Preload_Unbilled_Adj`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Bayan` |
| `@Step` | `Unbilled_Adj - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Transform`
3. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Export`
4. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Report_Prepare`
5. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Report_Export`
6. `dbo.sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Report_Send`
7. Starts `MyBSS_Bayan_EOM_DP4_P15_Preload_UA_SFTP_AdHoc`

The transform deletes from staging table:

`dswTDIR2_Bayan.dbo.stBayan_Unbilled_Adj_TDIR2_Bayan_sap_glunbilled_B`

It then inserts `Column1` through `Column13` plus `zrownumber` from:

`sdbTDIR2_Bayan.dbo.sap_glunbilled_B`

Only rows where `Column1 IN ('00', '01', '99')` are loaded.

Generated source-rule procedures populate normalized columns and target metadata:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_OrderUpd`, `zDSP_OrderUpd` | Uses source `zrownumber` as legacy and current DSP order when null. |
| `zColumn01Upd` through `zColumn13Upd` | Copies raw `ColumnN` values into normalized `zColumnNN` fields. |
| `zColumn05_batchno_Upd` | Sets header `zColumn05` from `ZTF0001S.BATCH_NO + 1` using `BUKRS = 'BAYN'`. |
| `zDSP_UniqueKeyUpd` | Builds detail-row keys as `Left('BUnbilledAdj' + '-' + zrownumber + '-' + Column2, 44)`. |
| `Del` | Deletes existing target rows where `zSource = 'TDIR2_Bayan'`. |
| `Ins` | Inserts staged rows into `ttBayan_Unbilled_Adj`. |
| `trBayan_Unbilled_Adj_zloaded_Upd` | Marks target rows loaded when matched to latest SAP ODBC logs without a "does not exist for" message. |

Target table:

`dswTDIR2_Bayan.dbo.ttBayan_Unbilled_Adj`

Export file:

| Setting | Value |
| --- | --- |
| Directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Adj_New` |
| File | `txBayan_Unbilled_Adj_LoadFileSel.txt` |
| Export procedure | `sp_MyBSS_Bayan_EOM_Preload_Unbilled_Adj_Export_LoadFileSel` |
| Source view | `txBayan_Unbilled_Adj_LoadFileSel` / `tvBayan_Unbilled_Adj_PreloadRptSel` |

The DP4 preload view is different from DP2 and DP3:

- It selects confirmed target rows from `ttBayan_Unbilled_Adj` through `tvBayan_Unbilled_Adj_Preload010RptSel`.
- It also unions detail rows from `sdbTDIR2_Bayan.dbo.sap_glunbilled_unconf_B`.
- It creates unique keys for unconfirmed rows as `Left('BSapGlUnbilled' + '-' + zrownumber + '-' + Column2, 44)`.
- It regenerates a footer row with `Column01 = '99'`, detail count, and total amount.

Report cache preparation truncates and reloads:

| Cache table | Source view |
| --- | --- |
| `rpt_Preload_Report_Unbilled_Adj_SubtypeMissing_Cache` | `tvBayan_Unbilled_Adj_Column05_SubtypeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_ChargeCodeMissing_Cache` | `tvBayan_Unbilled_Adj_Column06_ChargeCodeMissingRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_Preload_Cache` | `tvBayan_Unbilled_Adj_PreloadRptSel` |
| `rpt_Preload_Report_Unbilled_Adj_VarianceInTotalAmount_Cache` | `tvBayan_Unbilled_Adj_VarianceInTotalAmountRptSel` |

The variance report compares the target detail-row sum in `ttBayan_Unbilled_Adj.Column07` to `Amount` from `sdbTDIR2_Bayan.dbo.307_Unbilled_Adjustments_Report_B`.

SSRS subscription patterns:

| Pattern |
| --- |
| `Bayn_UA_Preload_DP4_MMYY_SubsTypeMissing` |
| `Bayn_UA_Preload_DP4_MMYY_ChargeCodeMissing` |
| `Bayn_UA_Preload_DP4_MMYY` |
| `Bayn_UA_Preload_DP4_MMYY_VarianceInTotalAmount` |

Report files are exported under:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Unbilled_Adj_SSRS`

The SFTP job calls `sp_MyBSS_Bayan_EOM_Preload_DP4_SFTP`, which deletes and pushes using keys:

| Key type | Value |
| --- | --- |
| Delete key | `03_txBayan_Unbilled_Adj_Del` |
| Push key | `01_txBayan_Unbilled_Adj_Push` |

## Shared Reporting Behavior

Each domain exports four SSRS reports:

| Report type | Purpose |
| --- | --- |
| Subtype missing | Lists detail rows whose subtype is not found in `ZFFI_SUBTYPE` for `ZBUKRS = 'BAYN'`. |
| Charge code missing | Lists detail rows whose charge code is not found in `ZFFI_0346`. |
| Preload | Full preload output dataset. |
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
| Recipients | `princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph` |
| Copy recipients | `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph` |
| Subject prefix | `Report Notif: MyBSS` |
| Report server link | `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx` |

## Shared Transform Behavior

The three domain transforms follow the same pattern:

1. Clear the domain staging table.
2. Perform a source cleanup update against `sdbTDIR2_Globe.dbo.sap_airc`.
3. Load source rows from the Bayan `sdbTDIR2_Bayan` extract table.
4. Populate normalized columns using generated source-rule procedures.
5. Delete existing target rows for `zSource = 'TDIR2_Bayan'`.
6. Insert transformed rows into the domain target table.
7. Mark rows as loaded when matched to latest SAP ODBC logs.

The source cleanup update in step 2 targets `sdbTDIR2_Globe.dbo.sap_airc`, not a Bayan table. This appears in all three Bayan EOM transform procedures and is active code, not a comment.

The `zLoaded` flag is updated after matching SAP logs, but the reviewed preload export/report selectors do not filter on `zLoaded`.

## Business Logic Summary

| Domain | Source extract | Staging table | Target table | Unique key prefix |
| --- | --- | --- | --- | --- |
| DP2 Unearned MSF | `sdbTDIR2_Bayan.dbo.sap_airc_B` | `stBayan_Unearned_MSF_TDIR2_Bayan_sap_airc_B` | `ttBayan_Unearned_MSF` | `BUnearnedMSF` |
| DP3 Unbilled Charges | `sdbTDIR2_Bayan.dbo.sap_aiuc_B` | `stBayan_Unbilled_Char_TDIR2_Bayan_sap_aiuc_B` | `ttBayan_Unbilled_Char` | `BUnbiledChg` |
| DP4 Unbilled Adjustments | `sdbTDIR2_Bayan.dbo.sap_glunbilled_B` | `stBayan_Unbilled_Adj_TDIR2_Bayan_sap_glunbilled_B` | `ttBayan_Unbilled_Adj` | `BUnbilledAdj` |

Common row types:

| `Column1` value | Meaning inferred from procedure behavior |
| --- | --- |
| `00` | Header row. Batch number is updated in `Column05`/`zColumn05`. |
| `01` | Detail row. Unique key and DSP order are emitted. |
| `99` | Footer row. |

Batch number logic:

Header rows are matched to `ZTF0001S` using source system, target system, event, and `BUKRS = 'BAYN'`. The output batch number is `BATCH_NO + 1`.

Subtype validation:

Missing subtype reports compare detail-row `Column05` to `ZFFI_SUBTYPE.ZSUBTYPE` with `ZBUKRS = 'BAYN'`.

Charge code validation:

Missing charge code reports compare detail-row `Column06` to `ZFFI_0346.ZCCODE`. The reviewed charge code missing views do not apply a Bayan company-code filter.

## Operational Risks and Gaps

| Risk or gap | Impact |
| --- | --- |
| No period/run parameter | Runs are tied to current server date and global table contents. Reruns outside the expected month can produce different file names and subscription names. |
| Global cleanup | The setup cleanup truncates full source and target tables, not a scoped run partition. |
| Parent only checks completion | `fn_IsJobCompleted` is used for completion polling, but the parent does not verify child job success or failure. |
| Timeout continues to next job | If a child job exceeds the polling limit, the parent breaks the wait loop and proceeds. |
| Missing job names are skipped | The parent inner joins hard-coded job names to `etl_db.dbo.vw_SqlJobs`; missing jobs are silently absent from the cursor. |
| SFTP is asynchronous | Child preload procedures start SFTP jobs but do not wait for SFTP completion or status. |
| SAP lookups refresh three times | Each child job calls `sp_MyBSS_Bayan_EOM_Preload_000_LoadSapTables`, so a full run reloads the same lookup tables repeatedly. |
| Bayan transforms update a Globe table | All three transforms update `sdbTDIR2_Globe.dbo.sap_airc`, which may be a copy-paste issue or hidden dependency. |
| DP3 export column mismatch | The DP3 export selector emits `Column16` twice and omits `Column15`. |
| DP4 unconfirmed handling differs | DP4 unions `sap_glunbilled_unconf_B` into the preload view and regenerates the footer; DP2 and DP3 do not have analogous behavior in the reviewed selectors. |
| `zLoaded` not used by export filters | SAP log match status is updated but not used to filter the preload export/report rows reviewed. |
| Report cache counts can be misleading | Preload caches include header/footer rows and variance caches are summary rows, so emails may be sent even when there is no exception condition. |
| SSRS file deletion uses `xp_cmdshell` | Report export depends on file-system permissions and `xp_cmdshell` being enabled. |
| SQL Agent metadata inconsistency | `etl_pipelines.txt` does not list Bayan EOM jobs, while `sql-agent-jobs.txt` does. |

## Validation Checklist

Before running this process in an environment, validate:

| Check | Reason |
| --- | --- |
| Cleanup job completed before extract | The preload expects fresh source extract tables and empty target tables. |
| Extract job completed successfully | The preload reads from `sdbTDIR2_Bayan` source tables populated by SSIS. |
| Parent and child SQL Agent jobs exist in `etl_db.dbo.vw_SqlJobs` | The parent starts jobs by IDs looked up through this view. |
| SAP lookup refresh procedures are available | Each child preload calls the common SAP lookup refresh. |
| SSRS subscriptions exist with literal `_MMYY` descriptions | Report export joins subscriptions by the pattern, not by the dynamic month-specific name. |
| `F:\BOA\Transform\Export\...` and `F:\BOA\Transform\Report\...` paths exist | Text exports, SSRS output, and email attachments depend on these paths. |
| Database Mail profile `SSRS` is configured | Report notification procedures use this profile. |
| SFTP keys exist in the shared SFTP configuration | Domain SFTP procedures call `etl_db.dbo.sp_sftp_sap_del` and `etl_db.dbo.sp_sftp_sap_push` by file key. |
| DP3 export column mapping is acceptable | Active code outputs `Column16` twice and omits `Column15`. |
| Bayan transform update against `sdbTDIR2_Globe.dbo.sap_airc` is intentional | Active code mutates a Globe source table during Bayan EOM transforms. |

## High-Level Data Flow

```text
SQL Agent schedule
  -> Setup cleanup job
      -> truncate Bayan EOM source extracts and target tables
  -> Extract job
      -> SSIS packages populate sdbTDIR2_Bayan source tables
  -> Preload all job
      -> sp_Job_MyBSS_Bayan_EOM_Preload_All
          -> DP2 P10 job
              -> refresh SAP lookups
              -> sap_airc_B -> stBayan_Unearned_MSF_* -> ttBayan_Unearned_MSF
              -> export SAP load file
              -> prepare SSRS caches
              -> export/send reports
              -> start DP2 SFTP job
          -> DP3 P10 job
              -> refresh SAP lookups
              -> sap_aiuc_B -> stBayan_Unbilled_Char_* -> ttBayan_Unbilled_Char
              -> export SAP load file
              -> prepare SSRS caches
              -> export/send reports
              -> start DP3 SFTP job
          -> DP4 P10 job
              -> refresh SAP lookups
              -> sap_glunbilled_B -> stBayan_Unbilled_Adj_* -> ttBayan_Unbilled_Adj
              -> union unconfirmed rows in preload view
              -> export SAP load file
              -> prepare SSRS caches
              -> export/send reports
              -> start DP4 SFTP job
```
