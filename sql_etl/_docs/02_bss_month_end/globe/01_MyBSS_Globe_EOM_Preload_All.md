# sp_Job_MyBSS_Globe_EOM_Preload_All Reverse Engineering

Reverse engineered on 2026-05-18 from the SQL scripts in this repository.

## Scope

This document explains the SQL Server ETL flow driven by:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_All`

The procedure is the parent preload orchestrator for Globe end-of-month MyBSS DP2, DP3, DP4, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment flows. It starts five SQL Agent ad hoc preload jobs and waits for each one to finish before starting the next job.

This document covers the parent procedure, SQL Agent job context, setup cleanup, extract jobs that populate source tables, child preload procedures, SAP lookup refresh, transform/export/report/SFTP steps, important tables and views, and operational risks visible in the repository.

## Executive Summary

`sp_Job_MyBSS_Globe_EOM_Preload_All` does not transform data directly. It assumes upstream SQL Agent setup and SSIS extract jobs have already loaded Globe EOM source data into `sdbTDIR2_Globe` tables. The parent procedure starts five child SQL Agent preload jobs, waits for completion status after each start, and moves through the DP2 through DP5 domains in job-name order.

At a high level, the process:

1. Runs operationally after a Globe EOM setup cleanup job and an SSIS extract job.
2. Starts DP2 Unearned, DP3 Unbilled Charges, DP4 Unbilled Adjustments, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment ad hoc preload jobs.
3. Refreshes shared SAP lookup/reference tables in each child job before transformation.
4. Transforms source extract tables from `sdbTDIR2_Globe` into Globe staging and target tables in `dswTDIR2_Globe`.
5. Exports SAP preload text files under `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe`.
6. Rebuilds report cache tables, triggers SSRS subscriptions to create Excel files, and sends report notifications for nonempty caches.
7. Starts matching SFTP SQL Agent jobs asynchronously for delete and push operations.

The parent has no date, cycle, posting period, or run-id parameter. Period behavior is implicit through upstream schedule timing, global source/target tables, and report/export logic that uses the prior calendar month from `GETDATE()`.

## Source Files Reviewed

| Area | Representative files |
| --- | --- |
| Parent procedure | `dswTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOM_Preload_All.StoredProcedure.sql` |
| SQL Agent metadata | `sql-agent-jobs.txt` |
| Pipeline inventory | `etl_pipelines.txt` |
| Setup cleanup | `sdbTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03.StoredProcedure.sql` |
| Child preload jobs | `dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP2`, `dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP3`, `dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP4`, `dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed`, `dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj` |
| SAP lookup refresh | `dswTDIR2_Globe/programmability/stored_procedures/dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables.StoredProcedure.sql` |
| Transform procedures | `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Transform`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Transform`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Transform`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Transform`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Transform` |
| Export procedures and selectors | `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Export`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Export`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Export`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Export`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Export`, and their `*_LoadFileSel`, `*_ExportSel`, and aggregate views |
| Report procedures | `dbo.sp_MyBSS_Globe_EOM_Preload_DP*_Report_Prepare`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP*_Report_Export`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP*_Report_Send`, and related `sp_rpt_*_SSRS` dataset procedures |
| SFTP procedures | `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_SFTP`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_SFTP`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_SFTP`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_SFTP`, `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_SFTP` |
| Source tables | `sdbTDIR2_Globe.dbo.sap_airc`, `sap_aiuc_G`, `sap_glunbilled_G`, `sap_glunbilled_unconf_G`, `307_Unbilled_Adjustments_Report_G`, `317_Unbilled_Charges_Summary_Report_G`, `324_Unearned_MSF`, `Unconfirmed_Advanced_MSF_Charges` |
| Staging and target tables | `stGlobe_DP2_Unearned_TDIR2_Globe_saplairc`, `stGlobe_DP3_Unbilled_Char_TDIR2_Globe_sap_aiuc_G`, `stGlobe_DP4_Unbilled_Adj_TDIR2_Globe_307_Unbilled_Adjustments_Report_G`, `stGlobe_DP5_Unconfirmed_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges`, `stGlobe_DP5_Unconfirmed_Adj_TDIR2_Globe_sap_glunbilled_unconf_G`, `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, `ttGlobe_DP5_Unconfirmed_Adj` |
| SAP and mapping views | `dbo.ZTF0001S`, `dbo.ZTF0002S`, `dbo.ZFCO_UDT_MAP`, `dbo.ZTF0188S`, `dbo.ZFFI_UBADJ_SBP_010`, `dbo.ZFFI_REPORT_ODBC_LATESTLOGS`, `dbo.ZFFI_SUBTYPE`, `dbo.ZFFI_0346` |
| Report cache tables | `rpt_Preload_Report_DP2_Unearned_*_Cache`, `rpt_Preload_Report_DP3_Unbilled_Char_*_Cache`, `rpt_Preload_Report_DP4_Unbilled_Adj_*_Cache`, `rpt_Preload_Report_DP5_Unconfirmed_*_Cache`, `rpt_Preload_Report_DP5_Unconfirmed_Adj_*_Cache` |

## Databases and External Dependencies

| Dependency | Usage |
| --- | --- |
| `dswTDIR2_Globe` | Main working database for Globe EOM preload orchestration, child procedures, staging tables, target tables, SAP wrapper views, report cache tables, export selectors, and SSRS dataset procedures. |
| `sdbTDIR2_Globe` | Source/extract database populated by SSIS packages. Contains raw Globe source tables and supporting report extracts. |
| `dswTDIR2_Globe_Cache` | Listed in `etl_pipelines.txt` for the Globe EOM pipeline. The reviewed active report cache tables are scripted under `dswTDIR2_Globe`. |
| `dgS4HANA_TDIR1` | SAP lookup/reference database and SAP latest-log source used through local Globe wrapper views. |
| `etl_db` | Shared ETL helper database. Used for SQL Agent job lookup, job completion polling, execution logging, text export, text cleanup, string trimming, and SFTP helpers. |
| `msdb` | Starts SQL Agent jobs through `msdb.dbo.sp_start_job` and sends email through Database Mail. |
| `ReportServer$DACPRD` | Used to locate SSRS subscriptions, trigger `TimedSubscription` events through `AddEvent`, and poll report-server event rows. |
| `DCSTDIR2` | Supplies `dbo.TaxChargeCode` used by DP4 adjustment remark logic. |
| Windows file system | Writes SAP preload files and SSRS Excel files under `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe` and `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe`. |
| Database Mail | Sends report notifications through profile `SSRS`. |
| `xp_cmdshell` | Deletes existing report `.xlsx` files before SSRS subscription export. |

Important helper procedures and functions:

- `etl_db.dbo.vw_SqlJobs`
- `etl_db.dbo.fn_IsJobCompleted`
- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `etl_db.dbo.sp_ExportTextFile`
- `etl_db.dbo.fn_CleanTxt`
- `etl_db.dbo.fn_TrimSpaces`
- `etl_db.dbo.sp_sftp_sap_del`
- `etl_db.dbo.sp_sftp_sap_push`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFCO_UDT_MAP`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0188S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_UBADJ_SBP`
- `msdb.dbo.sp_start_job`
- `msdb.dbo.sp_send_dbmail`
- `ReportServer$DACPRD.dbo.AddEvent`

Local SAP wrapper views read from `dgS4HANA_TDIR1` and commonly filter SAP client `MANDT = N'300'`.

## SQL Agent Context

The relevant Globe EOM SQL Agent chain is defined in `sql-agent-jobs.txt`.

| Job | Schedule | Command or package |
| --- | --- | --- |
| `MyBSS_Globe_EOM_00_P01_Setup_Cleanup_03Mth` | Monthly, start date `2023-08-02 09:01:00`; description says every 3rd at 9:01 AM | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03]` |
| `MyBSS_Globe_EOM_00_P02_Extract_03Mth` | Monthly, start date `2023-08-02 11:17:00`; description says every 3rd at 11:17 AM | Runs nine SSIS extract packages into `sdbTDIR2_Globe`. |
| `MyBSS_Globe_EOM_00_P10_Preload_All_03Mth` | Monthly, start date `2023-09-01 11:40:00` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Preload_All];` |
| `MyBSS_Globe_EOM_00_P20_Postload_All_03Mth` | Monthly, start date `2023-09-01 13:40:00` | `EXEC [dbo].[sp_Job_MyBSS_Globe_EOM_Postload_All];` |

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

The parent preload job starts these child ad hoc preload jobs:

| Parent sequence | SQL Agent job | T-SQL command |
| ---: | --- | --- |
| 1 | `MyBSS_Globe_EOM_DP2_P10_Preload_Unearned_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP2` |
| 2 | `MyBSS_Globe_EOM_DP3_P10_Preload_UC_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP3` |
| 3 | `MyBSS_Globe_EOM_DP4_P10_Preload_UA_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP4` |
| 4 | `MyBSS_Globe_EOM_DP5_1_P10_Preload_Unconfirmed_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed` |
| 5 | `MyBSS_Globe_EOM_DP5_2_P10_Preload_Unconfirmed_Adj_AdHoc` | `EXEC dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj` |

Each child preload job starts a matching SFTP ad hoc job:

| Preload job | SFTP job |
| --- | --- |
| `MyBSS_Globe_EOM_DP2_P10_Preload_Unearned_AdHoc` | `MyBSS_Globe_EOM_DP2_P15_Preload_Unearned_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP3_P10_Preload_UC_AdHoc` | `MyBSS_Globe_EOM_DP3_P15_Preload_UC_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP4_P10_Preload_UA_AdHoc` | `MyBSS_Globe_EOM_DP4_P15_Preload_UA_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP5_1_P10_Preload_Unconfirmed_AdHoc` | `MyBSS_Globe_EOM_DP5_1_P15_Preload_Unconfirmed_SFTP_AdHoc` |
| `MyBSS_Globe_EOM_DP5_2_P10_Preload_Unconfirmed_Adj_AdHoc` | `MyBSS_Globe_EOM_DP5_2_P15_Preload_Unconfirmed_Adj_SFTP_AdHoc` |

`etl_pipelines.txt` lists "MyBSS Globe EOM (End of month)" with databases `sdbTDIR2_Globe`, `dswTDIR2_Globe`, and `dswTDIR2_Globe_Cache`, but its SQL Agent job list is blank. The actual job chain is present in `sql-agent-jobs.txt`.

## Cleanup Process

The setup cleanup procedure is not called by `sp_Job_MyBSS_Globe_EOM_Preload_All`. It is run by its own SQL Agent job before extract and preload.

Procedure:

`sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03`

The cleanup truncates source extract tables and Globe target tables globally:

| Database | Tables truncated |
| --- | --- |
| `sdbTDIR2_Globe` | `307_Unbilled_Adjustments_Report_G`, `307_Unbilled_Adjustments_Report_G_header`, `317_Unbilled_Charges_Summary_Report_G`, `324_Unearned_MSF`, `DP5_Unconfirmed_Advance_MSF_header`, `sap_airc`, `sap_aiuc_G`, `sap_glunbilled_G`, `sap_glunbilled_unconf_G`, `Unconfirmed_Advanced_MSF_Charges` |
| `dswTDIR2_Globe` | `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, `ttGlobe_DP5_Unconfirmed_Adj` |

There is no period, run-id, partition, or cycle filter. The cleanup is destructive for the full Globe EOM working set.

## Parameter Mapping

The parent procedure has no input parameters. The child preload procedures also have no input parameters.

| Concept | Implementation |
| --- | --- |
| Company / operating company | Hard-coded through Globe-specific procedures, tables, jobs, paths, and SAP mapping filters such as `BUKRS = 'GLOB'`. |
| Period | Implicit. Report export and email file names use `FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`. |
| Cycle | Not applicable in the reviewed Globe EOM preload procedures. |
| Domain | Hard-coded by child jobs: DP2 Unearned, DP3 UC, DP4 UA, DP5 Unconfirmed, DP5 Unconfirmed Adj. |
| Run state | Stored in global staging, target, and report cache tables. |
| Report files | Subscription descriptions contain `_MMYY`, replaced with the previous month keyword at runtime. |
| SFTP routing | Hard-coded SFTP key names are passed to `etl_db.dbo.sp_sftp_sap_del` and `etl_db.dbo.sp_sftp_sap_push`. |

## Main Procedure Call Chain

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_All`

Behavior:

1. Declares `@MaxIteration int = 60`.
2. Creates a table variable of five ad hoc SQL Agent job names.
3. Looks up those job names in `etl_db.dbo.vw_SqlJobs`.
4. Iterates with a cursor ordered by job name.
5. Starts each job through `msdb.dbo.sp_start_job @job_id = @JobID`.
6. Polls `etl_db.dbo.fn_IsJobCompleted(@JobName)` every 5 seconds.
7. Breaks the poll loop when the job is complete or when the iteration limit is reached.
8. Moves to the next job.

Important behavior:

- Missing job names are skipped because the cursor is built from an inner join to `etl_db.dbo.vw_SqlJobs`.
- The parent checks only whether the SQL Agent job completed. It does not inspect child job success or failure status.
- If a child job does not finish before the polling limit, the parent stops waiting and proceeds to the next job.
- The active code sets `@MaxIteration = 60`. Because the loop waits 5 seconds before each completion check and breaks when the iteration counter reaches the limit, the practical wait is roughly five minutes per child job.
- The child jobs start SFTP jobs asynchronously. The parent does not wait for SFTP completion.

Each child preload procedure executes the same step pattern:

1. `sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
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
| `@ProcessGroup` | `Globe` |
| `@Step` | Domain-specific value such as `DP2_Unearned - Preload` |
| `@Others` | `EOM` |

Important observed detail:

The variable name `@Proccess` is spelled with two `c` characters in the reviewed child procedures. The spelling is preserved here because it appears in source.

## Step 1: Start DP2-DP5 Ad Hoc Preload Jobs

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_All`

The parent starts these jobs sequentially:

| Sequence | Job name | Purpose |
| ---: | --- | --- |
| 1 | `MyBSS_Globe_EOM_DP2_P10_Preload_Unearned_AdHoc` | Runs DP2 Unearned preload. |
| 2 | `MyBSS_Globe_EOM_DP3_P10_Preload_UC_AdHoc` | Runs DP3 Unbilled Charges preload. |
| 3 | `MyBSS_Globe_EOM_DP4_P10_Preload_UA_AdHoc` | Runs DP4 Unbilled Adjustments preload. |
| 4 | `MyBSS_Globe_EOM_DP5_1_P10_Preload_Unconfirmed_AdHoc` | Runs DP5 Unconfirmed preload. |
| 5 | `MyBSS_Globe_EOM_DP5_2_P10_Preload_Unconfirmed_Adj_AdHoc` | Runs DP5 Unconfirmed Adjustment preload. |

The order comes from the hard-coded job names joined to `etl_db.dbo.vw_SqlJobs` and then ordered by `[name]`.

## Step 2: Refresh SAP Lookup Tables

Procedure:

`dswTDIR2_Globe.dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`

Each child preload procedure calls this procedure before transforming its own domain. Therefore, a full parent run refreshes the same SAP lookup/reference tables five times.

Called procedures:

| Procedure | Purpose inferred from name and usage |
| --- | --- |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0002S` | Refreshes SAP transfer/reference table used for GL and SPB lookup. |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0001S` | Refreshes SAP transfer/reference table used by SAP interface logic. |
| `dgS4HANA_TDIR1.dbo.sp_ZFCO_UDT_MAP` | Refreshes user-defined mapping data used for brand, SPA, and revenue type derivation. |
| `dgS4HANA_TDIR1.dbo.sp_ZTF0188S` | Refreshes charge-code reference data used by DP2 rules. |
| `dgS4HANA_TDIR1.dbo.sp_ZFFI_UBADJ_SBP` | Refreshes unbilled-adjustment SAP mapping data used by DP4 rules. |

Important mapping views include `ZTF0001S`, `ZTF0002S`, `ZFCO_UDT_MAP`, `ZTF0188S`, `ZFFI_UBADJ_SBP_010`, and `ZFFI_REPORT_ODBC_LATESTLOGS`.

## Step 3: DP2 Unearned Preload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP2`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Globe` |
| `@Step` | `DP2_Unearned - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Transform`
3. `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Export`
4. `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Report_Prepare`
5. `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Report_Export`
6. `dbo.sp_MyBSS_Globe_EOM_Preload_DP2_Report_Send`
7. Starts `MyBSS_Globe_EOM_DP2_P15_Preload_Unearned_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Globe.dbo.stGlobe_DP2_Unearned_TDIR2_Globe_saplairc`

It cleans and loads source rows from:

`sdbTDIR2_Globe.dbo.sap_airc`

Active source behavior:

- Trims `Column7` through `etl_db.dbo.fn_TrimSpaces`.
- Casts `Column7` to `decimal(18,2)` for detail rows where `Column1 = '01'`.
- Converts blank `Column8`, `Column9`, and `Column10` values to `NULL`.
- Inserts `zrownumber` and `Column1` through `Column10`.
- Loads only source rows where `Column1 IN ('00', '01', '99')`.

### Source Rule Updates

Generated rule procedures populate:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_Order`, `zDSP_Order` | Set from `zrownumber`. |
| Source column mapping | Copies `Column1` to `zData`, `Column2` to `zPosting_Date`, `Column3` to `zSAPFIGL`, `Column4` to `zCT`, `Column5` to `zST`, `Column6` to `zCH_Code`, `Column7` to `zAmount`, `Column8` to `zCC`, `Column9` to `zGL_Code`, and `Column10` to `zNB_IND`. |
| `zBRAND`, `zSPA`, `zRev_Type` | Derived from `ZFCO_UDT_MAP` for `FROM_SYSTEM = 'AINV'`, `EVENT = 'AIRC'`, `TO_SYSTEM = 'SAPFIGL'`, `BUKRS = 'GLOB'`, and dimensions such as `BRAND`, `CFU`, and `PRODUCT`. |
| `zSPA_Rule2` | Uses `Column4` when `zSPA` is still null for detail rows. |
| `zSPB` | Joins `ZTF0188S` on charge code and uses `SGROUP`. |
| `zRemarks` | Sets `For posting` when `zSPA <> 'I'` and `ZTF0188S.GLCode` is not blank; otherwise `Not for posting`. |
| `zDSP_UniqueKey` | Builds detail-row keys as `Left('GUnearned' + '-' + zrownumber + '-' + Column2, 44)`. |

### Target Load and zLoaded

The transform deletes existing target rows where:

`ttGlobe_DP2_Unearned.zSource = 'TDIR2_Globe'`

It then inserts staged rows into:

`dswTDIR2_Globe.dbo.ttGlobe_DP2_Unearned`

The reviewed insert does not apply an explicit `zActive` filter.

`trGlobe_DP2_Unearned_zLoaded_1Upd` marks detail rows as loaded when they match `ZFFI_REPORT_ODBC_LATESTLOGS` on `ZDSP_ORDER` and `ZDSP_UNIQUEKEY` and the SAP message is not one of the handled error patterns. `trGlobe_DP2_Unearned_zLoaded_0_Error_LineUpd` marks rows not loaded when they appear in the DP2 error-line view.

### Export, Reports, and SFTP

The export writes:

| Item | Value |
| --- | --- |
| Output directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP2_Unearned_New` |
| Output file | `txGlobe_DP2_Unearned_LoadFileSel.txt` |
| Export selector | `sp_MyBSS_Globe_EOM_Preload_DP2_Export_Unearned_LoadFileSel` |
| Selector source | `tvGlobe_DP2_Unearned_Preload_RptSel` |

The DP2 preload report selector filters rows where the recon difference is between `-100000` and `100000` and `zLoaded = '0'`.

Report preparation rebuilds these report areas:

- `Unearned_Manual_Report`
- `Unearned_Preload`
- `Unearned_Recon_Amount`

The SFTP procedure deletes and pushes with these SFTP keys:

| Action | SFTP key |
| --- | --- |
| Delete | `03_txGlobe_DP2_Unearned_Del` |
| Push | `01_txGlobe_DP2_Unearned_Push` |

Historical reference:

The DP2 child procedure contains a commented historical EOC load-SAP block. It is not active in the reviewed EOM call chain.

## Step 4: DP3 Unbilled Charges Preload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP3`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Globe` |
| `@Step` | `DP3_Unbilled_Char - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Transform`
3. `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Export`
4. `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Report_Prepare`
5. `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Report_Export`
6. `dbo.sp_MyBSS_Globe_EOM_Preload_DP3_Report_Send`
7. Starts `MyBSS_Globe_EOM_DP3_P15_Preload_UC_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Globe.dbo.stGlobe_DP3_Unbilled_Char_TDIR2_Globe_sap_aiuc_G`

It loads source rows from:

`sdbTDIR2_Globe.dbo.sap_aiuc_G`

Active source behavior:

- Trims `sap_aiuc_G.Column7`.
- Converts blank `Column8` through `Column12` values to `NULL`.
- Inserts `zrownumber` and `Column1` through `Column12`.
- Loads only source rows where `Column1 IN ('00', '01', '99')`.
- Casts `Column7` to `decimal(18,2)` for detail rows where `Column1 = '01'`.

Important observed detail:

The reviewed transform trims `sdbTDIR2_Globe.dbo.sap_aiuc_G.Column7`, but one subsequent cast update references `sdbTDIR2_Globe.dbo.sap_airc.Column7`. That cross-table reference is active in source and should be validated before changing DP3 amount-cleaning behavior.

### Source Rule Updates

Generated rule procedures populate:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_Order`, `zDSP_Order` | Set from `zrownumber`. |
| `zPosting_Date` | Set from `Column2`. |
| `zSum_of_Amount` and `zDiff` | Derived for recon and preload output. |
| Charge summary fields | Joins `sdbTDIR2_Globe.dbo.DP3_317_Unbilled_Charges_Summary_Report_G` on customer type, service type, and charge code to derive unbilled charge amounts. |
| `zGL`, `zSPB` | Derived from `ZTF0002S` using charge code and `DPCODE = ''`. |
| `zTax_Rate` | Set to `0.12` when `zGL = '240111'`. |
| `zNet_of_Tax` | Uses rounded gross amount, or gross amount divided by `1 + zTax_Rate` when tax applies. |
| Mapping fields | Derives SPA, revenue type, and remarks through SAP mapping/reference logic. |
| `zDSP_UniqueKey` | Builds detail-row keys as `Left('GUnbilledChg' + '-' + zrownumber + '-' + Column2, 44)`. |
| `zActive` | Set to `1` for staged rows by the active update rule. |

### Target Load and zLoaded

The transform deletes existing target rows where:

`ttGlobe_DP3_Unbilled_Char.zSource = 'DP3_Unbilled_Char'`

It inserts active staged rows into:

`dswTDIR2_Globe.dbo.ttGlobe_DP3_Unbilled_Char`

DP3 also updates `zLoaded` based on SAP latest-log matching and error-line classification. The export selector filters unloaded rows.

### Export, Reports, and SFTP

The export writes:

| Item | Value |
| --- | --- |
| Output directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP3_Unbilled_Char_New` |
| Output file | `txGlobe_DP3_Unbilled_Char_ExportSel.txt` |
| Export selector | `sp_MyBSS_Globe_EOM_Preload_DP3_Export_Unbilled_Char_LoadFileSel` |
| Selector source | `txGlobe_DP3_Unbilled_Char_ExportSel` / `tvGlobe_DP3_Unbilled_Char_PreloadRptSel` |

The DP3 preload selector filters rows where the recon difference is between `-100000` and `100000` and `zLoaded = '0'`.

Report preparation rebuilds these report areas:

- `Unbilled_Char_Manual_agg`
- `Unbilled_Char_Preload`
- `Unbilled_Char_Recon_Amount`

The SFTP procedure deletes and pushes with these SFTP keys:

| Action | SFTP key |
| --- | --- |
| Delete | `03_txGlobe_DP3_Unbilled_Char_Del` |
| Push | `01_txGlobe_DP3_Unbilled_Char_Push` |

## Step 5: DP4 Unbilled Adjustments Preload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP4`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Globe` |
| `@Step` | `DP4_Unbilled_Adj - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Transform`
3. `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Export`
4. `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Report_Prepare`
5. `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Report_Export`
6. `dbo.sp_MyBSS_Globe_EOM_Preload_DP4_Report_Send`
7. Starts `MyBSS_Globe_EOM_DP4_P15_Preload_UA_SFTP_AdHoc`

Important observed detail:

The DP4 child procedure header contains a copy-paste description that refers to "MybssEOC DP3" even though the active procedure is the Globe EOM DP4 preload job.

### Input and Staging

The transform deletes from:

`dswTDIR2_Globe.dbo.stGlobe_DP4_Unbilled_Adj_TDIR2_Globe_307_Unbilled_Adjustments_Report_G`

It loads source rows from:

`sdbTDIR2_Globe.dbo.307_Unbilled_Adjustments_Report_G`

The source columns include customer type, customer sub type, primary subscriber type, adjustment type, adjustment date, adjustment code/tax code, adjustment reason, amount, legal entity, currency, and write-off activity indicator.

### Source Rule Updates

Generated rule procedures populate:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_Order`, `zDSP_Order` | Set from `zrownumber`. |
| Source fields | Map customer, subscriber, adjustment, amount, legal entity, currency, and write-off source fields into normalized columns. |
| `zPosting_Date` | Set from `DP4_PostingDate0111.PostingDate`, not directly from source adjustment date. |
| `zGL`, `zSPB`, `zTax` | Derived first from `ZFFI_UBADJ_SBP_010` by adjustment code/tax code and reason. |
| Special write-off mapping | `UNCRWOAR` with `CCWOAA` and customer types `C`, `E`, or `S` maps to GL `127101`, `127102`, or `127103`; `UNCRWOAR` with blank adjustment reason maps to GL `450200`. |
| Fallback GL/SPB | Uses `ZTF0002S` on adjustment code when SAP unbilled-adjustment mapping is not found. |
| `zAmount_Net` | Rounds amount directly when tax is null; otherwise divides by `1 + zTax`. |
| `zRemark` | Sets `Not for Posting` for customer type `I`, missing GL, tax charge codes, or nonnumeric GL; otherwise `For Posting`. |
| `zActive` | Set to `1` when `zRemark = 'For Posting'` and primary subscriber type is not `BBWL`. |

### Target Load and Export Shape

The transform deletes existing target rows where:

`ttGlobe_DP4_Unbilled_Adj.zSource = 'DP4_Unbilled_Adj'`

It inserts active staged rows into:

`dswTDIR2_Globe.dbo.ttGlobe_DP4_Unbilled_Adj`

The reviewed transform does not set row-level `zDSP_UniqueKey` before target insert. The aggregate export views synthesize export keys using row number and posting date.

DP4 export is aggregate, not a direct raw source row export. `tvGlobe_DP4_Unbilled_Adj_aggRptSel` groups target rows by posting date, brand, SPA, revenue type, GL, and SPB, then sums `Amount_Net`. `DP4_Unbilled_Adj_agg_Union` formats SAP journal rows with:

| Field | Behavior |
| --- | --- |
| Reference | `UNBILLED ADJUSTMENT` |
| Document type | `SA` |
| Company code | `GLOB` |
| Currency | `PHP` |
| Profit center | `MCG` |
| Balance GL | `120102` |
| Posting key | Detail and balancing posting keys are chosen from the sign of the net amount. |
| Unique key | Prefix `GUnbilledAdj` plus row number and post date. |

### Export, Reports, and SFTP

The export writes:

| Item | Value |
| --- | --- |
| Output directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP4_Unbilled_Adj_New` |
| Output file | `txGlobe_DP4_Unbilled_Adj_ExportSel.txt` |
| Export selector | `sp_MyBSS_Globe_EOM_Preload_DP4_Export_Unbilled_Adj_LoadFileSel` |
| Selector source | `txGlobe_DP4_Unbilled_Adj_ExportSel` |

Report preparation rebuilds these report areas:

- `Unbilled_Adj_Manual`
- `Unbilled_Adj_agg_Preload`
- `Unbilled_Adj_Recon_Amount`

The SFTP procedure deletes and pushes with these SFTP keys:

| Action | SFTP key |
| --- | --- |
| Delete | `03_txGlobe_DP4_Unbilled_Adj_Del` |
| Push | `01_txGlobe_DP4_Unbilled_Adj_Push` |

## Step 6: DP5 Unconfirmed Preload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Globe` |
| `@Step` | `DP5_Unconfirmed - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Transform`
3. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Export`
4. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Report_Prepare`
5. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Report_Export`
6. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Report_Send`
7. Starts `MyBSS_Globe_EOM_DP5_1_P15_Preload_Unconfirmed_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Globe.dbo.stGlobe_DP5_Unconfirmed_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges`

It loads source rows from:

`sdbTDIR2_Globe.dbo.Unconfirmed_Advanced_MSF_Charges`

Source fields include customer type, service type, revenue type, charge code, offer ID, offer description, charge type, and amount.

### Source Rule Updates

Generated rule procedures populate:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_Order`, `zDSP_Order` | Set from `zrownumber`. |
| Posting and mapping fields | Derives posting date, brand, SPA, revenue type, GL, SPB, and net amount. |
| `zRemark` | Classifies source rows for posting. |
| `zActive` | Active rows require service type not equal to `BBWL`, a `For Posting` remark, and no prior active value. |

The transform deletes and reloads `dswTDIR2_Globe.dbo.ttGlobe_DP5_Unconfirmed` from active staging rows. The reviewed transform does not set row-level `zDSP_UniqueKey`; aggregate export views synthesize keys.

### Export, Reports, and SFTP

The DP5 Unconfirmed export writes two SAP journal load files:

| File | Selector | Business shape |
| --- | --- | --- |
| `txGlobe_DP5_Unconfirmed_CH_ExporSel.txt` | `txGlobe_DP5_Unconfirmed_CH_ExporSel` | Unconfirmed charges aggregate journal. |
| `txGlobe_DP5_Unconfirmed_MSF_ExpSel.txt` | `txGlobe_DP5_Unconfirmed_MSF_ExpSel` | Unconfirmed advance MSF aggregate journal. |

Output directory:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_New`

Aggregate union behavior:

| Area | Detail rows | Balancing row | Unique key prefix |
| --- | --- | --- | --- |
| Charges | Reference `UNBILLED REVENUE`, posting key `50`, text includes `UNBILLED BILLING_Unconfirmed` | GL `120102`, posting key `40` | `GUnconfChg` |
| MSF | Reference `Unconfirmed Adv MSF`, posting key `40`, text includes `Unconfirmed Advance MSF` | GL `240120`, posting key `50` | `GUnconfMSF` |

Report preparation rebuilds these report areas:

- `Unconfirmed_Advanced_MSF_Charges_Manual`
- `Unconfirmed_Charges_agg`
- `Unconfirmed_MSF_agg`

The SFTP procedure deletes and pushes two file groups:

| File group | Delete key | Push key |
| --- | --- | --- |
| Charges | `03_txGlobe_DP5_Unconfirmed_CH_Del` | `01_txGlobe_DP5_Unconfirmed_CH_Push` |
| MSF | `03_txGlobe_DP5_Unconfirmed_MSF_Del` | `01_txGlobe_DP5_Unconfirmed_MSF_Push` |

## Step 7: DP5 Unconfirmed Adjustment Preload

Procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj`

Logging metadata:

| Field | Value |
| --- | --- |
| `@Proccess` | `MyBSS` |
| `@ProcessGroup` | `Globe` |
| `@Step` | `DP5_Unconfirmed_Adj - Preload` |
| `@Others` | `EOM` |

The child procedure calls:

1. `dbo.sp_MyBSS_Globe_EOM_Preload_000_LoadSapTables`
2. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Transform`
3. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Export`
4. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Report_Prepare`
5. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Report_Export`
6. `dbo.sp_MyBSS_Globe_EOM_Preload_DP5_Unconfirmed_Adj_Report_Send`
7. Starts `MyBSS_Globe_EOM_DP5_2_P15_Preload_Unconfirmed_Adj_SFTP_AdHoc`

### Input and Staging

The transform deletes from:

`dswTDIR2_Globe.dbo.stGlobe_DP5_Unconfirmed_Adj_TDIR2_Globe_sap_glunbilled_unconf_G`

It loads source rows from:

`sdbTDIR2_Globe.dbo.sap_glunbilled_unconf_G`

The transform inserts `zrownumber` and `Column1` through `Column7` from the source table ordered by `zrownumber`. Unlike DP2 and DP3, the reviewed staging insert does not filter to `Column1 IN ('00', '01', '99')`.

### Source Rule Updates

Generated rule procedures populate:

| Rule group | Effect |
| --- | --- |
| `zLegacyDSP_Order`, `zDSP_Order` | Set from `zrownumber`. |
| Posting and mapping fields | Derives posting date, brand, SPA, revenue type, GL/SPB, secondary GL, tax, and net amount. |
| `zRemark` | Classifies source rows for posting. |
| `zActive` | Active rows require `Column5 <> 'BBWL'`, `zRemark = 'For Posting'`, and `Column1 = '01'`. |

The source default for this flow is `zSource = 'sap_glunbilled_unconf_G'`, and the transform inserts active rows into:

`dswTDIR2_Globe.dbo.ttGlobe_DP5_Unconfirmed_Adj`

As with DP4 and DP5 Unconfirmed, the aggregate export view synthesizes export keys instead of relying on a row-level transform key.

### Export, Reports, and SFTP

The export writes:

| Item | Value |
| --- | --- |
| Output directory | `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_Adj_New` |
| Output file | `txGlobe_DP5_Unconfirmed_Adj_LoadFile.txt` |
| Export selector | `sp_MyBSS_Globe_EOM_Preload_DP5_Export_Unconfirmed_Adj_agg_LoadFileSel` |
| Selector source | `txGlobe_DP5_Unconfirmed_Adj_agg_ExportSel` / `tvGlobe_DP5_Unconfirmed_Adj_agg_Preload_RptSel` |

`DP5_Unconfirmed_Adj_agg_Union` formats aggregate SAP journal rows with reference `UNBILLED ADJUSTMENT_Unconfirmed`, text containing `MOBILE UNBILLED ADJUSTMENT_Unconfirmed.`, balance GL `120102`, posting keys based on amount sign, and unique keys prefixed with `GUnconfAdj`.

Report preparation rebuilds these report areas:

- `Unconfirmed_Adj_Manual`
- `Unconfirmed_Adj`

The SFTP procedure deletes and pushes with these SFTP keys:

| Action | SFTP key |
| --- | --- |
| Delete | `03_txGlobe_DP5_Unconfirmed_Adj_Del` |
| Push | `01_txGlobe_DP5_Unconfirmed_Adj_Push` |

## Shared Reporting Behavior

Each report export procedure computes:

`FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy')`

The procedures use literal SSRS subscription descriptions containing `_MMYY`, replace `_MMYY` with the computed month/year keyword, then join `ReportServer$DACPRD.dbo.Subscriptions` by `Description`.

Before triggering each subscription, report export procedures delete the expected `.xlsx` file through `xp_cmdshell`:

`del /Q {report-directory}\{dynamic-subscription-name}.xlsx`

They then call:

`ReportServer$DACPRD.dbo.AddEvent @EventType = 'TimedSubscription'`

The report export procedures poll `ReportServer$DACPRD.dbo.Event` every 3 seconds and break after the fixed iteration limit. They do not validate the generated file contents.

Report directories and subscription patterns:

| Domain | Report directory | Subscription descriptions |
| --- | --- | --- |
| DP2 | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP2_Unearned_SSRS` | `Glob_Unearned_Preload_DP2_MMYY_Manual_Report`, `Glob_Unearned_Preload_DP2_MMYY_Preload`, `Glob_Unearned_Preload_DP2_MMYY_Recon_Amount` |
| DP3 | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP3_Unbilled_Char_SSRS` | `Glob_UC_Preload_DP3_MMYY_Manual_agg`, `Glob_UC_Preload_DP3_MMYY_Manual_agg_Preload`, `Glob_UC_Preload_DP3_MMYY_Manual_agg_Recon_Amount` |
| DP4 | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP4_Unbilled_Adj_SSRS` | `Glob_UA_DP4_MMYY_Manual`, `Glob_UA_Preload_DP4_MMYY_agg_Preload`, `Glob_UA_Preload_DP4_MMYY_Recon_Amount` |
| DP5 Unconfirmed | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_ALL_SSRS` | `Glob_Unconfirmed_Adv_MSF_DP5_MMYY_Manual`, `Glob_Unconfirmed_Charges_Preload_DP5_MMYY_agg`, `Glob_Unconfirmed_MSF_Preload_DP5_MMYY_agg` |
| DP5 Unconfirmed Adj | `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP5_Unconfirmed_ALL_SSRS` | `Glob_Unconfirmed_Adj_DP5_MMYY_Manual`, `Glob_Unconfirmed_Adj_Preload_DP5_MMYY_agg` |

Report send procedures use the same prior-month keyword and send email only when the corresponding report cache count is greater than zero.

| Email field | Value |
| --- | --- |
| Mail profile | `SSRS` |
| To | `rosoldevilla@globe.com.ph;rnvillar@globe.com.ph` |
| Cc | `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph` |
| Subject pattern | `Report Notif: MyBSS ... - N Record(s) Generated` |
| Attachment | Dynamic SSRS `.xlsx` file under the domain report directory |
| Body | Includes the report server folder link `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx` |

## Business Logic Summary

- The parent procedure is a job orchestrator only. It does not call transform/export/report procedures directly.
- The full Globe EOM preload run is global, not cycle-scoped. No reviewed parent or child procedure accepts period, posting date, bill cycle, or run-id parameters.
- Upstream SSIS extracts are expected to populate `sdbTDIR2_Globe` before the parent preload job runs.
- Cleanup truncates source extract and target working tables globally before extract and preload.
- Each child job refreshes SAP lookup/reference tables before its transform, so a full parent run refreshes shared SAP data five times.
- DP2 and DP3 load SAP-like input rows with `Column1 IN ('00', '01', '99')`, derive detail unique keys in transform, update `zLoaded`, and export only unloaded rows within a fixed recon threshold.
- DP4, DP5 Unconfirmed, and DP5 Unconfirmed Adjustment transform active rows into target tables and use aggregate journal views to create SAP preload files.
- DP4 active rows require `For Posting` and non-`BBWL` primary subscriber type.
- DP5 Unconfirmed active rows require non-`BBWL` service type and `For Posting`.
- DP5 Unconfirmed Adjustment stages all source rows but only active detail rows where `Column1 = '01'`, `Column5 <> 'BBWL'`, and `zRemark = 'For Posting'`.
- Report cache procedures truncate and rebuild cache tables globally.
- SSRS report exports use subscription descriptions, prior-month `MMyy` filenames, `xp_cmdshell` delete commands, `ReportServer$DACPRD.dbo.AddEvent`, and fixed polling loops.
- Report emails are sent when cache counts are greater than zero. A nonzero count is not necessarily an exception count; several preload/aggregate reports are expected to contain data.
- SFTP jobs are started asynchronously by child procedures and are not waited on by the child or parent procedure.

## Operational Risks and Gaps

- No runtime period parameter: The process depends on schedule timing and `GETDATE()` for report month naming. A manual rerun in a later calendar month can generate different report names for the same extracted data.
- Global cleanup and reload scope: Cleanup, staging deletes, target deletes, and report cache rebuilds are not run-scoped. Concurrent or overlapping runs can overwrite each other.
- Parent checks completion only: `fn_IsJobCompleted` tells the parent when a job is complete, but the parent does not validate success/failure status before starting the next domain.
- Timeout continues processing: If a child job reaches the fixed polling limit, the parent prints a timeout message and proceeds to the next child job.
- Missing job metadata is silent: A child job absent from `etl_db.dbo.vw_SqlJobs` is skipped because the cursor uses an inner join.
- SFTP is asynchronous: Preload jobs start SFTP jobs but do not wait for delete/push completion or validate remote delivery.
- Repeated SAP lookup refresh: The shared SAP refresh runs once per child job. A full parent run refreshes the same lookup tables five times, and changes between child jobs can make domains use different lookup snapshots.
- DP3 source-cleaning anomaly: The DP3 transform references `sap_airc.Column7` during a cast update after trimming `sap_aiuc_G.Column7`. This should be treated as an active observed detail, not corrected without validation.
- Copy-paste procedure descriptions: Some procedure headers refer to EOC or the wrong DP domain, such as the DP4 child header referencing "MybssEOC DP3".
- DP4 and DP5 key generation differs from DP2/DP3: DP4 and DP5 aggregate exports synthesize unique keys in export views rather than relying on transform-populated row-level `zDSP_UniqueKey`.
- Export filter differences: DP2 and DP3 reviewed selectors filter on `zLoaded = '0'` and recon thresholds. DP4 and DP5 aggregate selectors reviewed here do not use the same `zLoaded` gate.
- SSRS subscription dependency: Report export requires exact subscription descriptions in `ReportServer$DACPRD`; a renamed subscription prevents the event from being triggered.
- `xp_cmdshell` and file-system dependency: Report export deletes existing `.xlsx` files before triggering subscriptions. Missing permissions or unavailable paths can break report generation.
- Metadata inventory gap: `etl_pipelines.txt` lists databases for Globe EOM but does not list the SQL Agent jobs. Operational job detail must be taken from `sql-agent-jobs.txt`.

## Validation Checklist

- Confirm the setup cleanup job ran before extract, and verify the intended `sdbTDIR2_Globe` and `dswTDIR2_Globe` tables were truncated for the current run.
- Confirm the extract job completed all nine SSIS package steps and populated the expected Globe source tables.
- Verify the five parent child jobs exist in `etl_db.dbo.vw_SqlJobs` with the exact names used by `sp_Job_MyBSS_Globe_EOM_Preload_All`.
- Check child job history for success, not just completion, after each domain run.
- Validate source row counts before transform for `sap_airc`, `sap_aiuc_G`, `307_Unbilled_Adjustments_Report_G`, `Unconfirmed_Advanced_MSF_Charges`, and `sap_glunbilled_unconf_G`.
- Validate target row counts after transform for `ttGlobe_DP2_Unearned`, `ttGlobe_DP3_Unbilled_Char`, `ttGlobe_DP4_Unbilled_Adj`, `ttGlobe_DP5_Unconfirmed`, and `ttGlobe_DP5_Unconfirmed_Adj`.
- Check SAP lookup refresh status and expected rows in `ZTF0002S`, `ZTF0001S`, `ZFCO_UDT_MAP`, `ZTF0188S`, `ZFFI_UBADJ_SBP_010`, and `ZFFI_REPORT_ODBC_LATESTLOGS`.
- Review DP2 and DP3 recon thresholds and `zLoaded` counts before relying on exported load files.
- Review DP4 and DP5 aggregate export totals against source and report cache totals.
- Confirm export files exist under the expected `F:\BOA\Transform\Export\TDIR2-MyBSS\Globe` domain folders.
- Confirm SSRS subscription descriptions exist with the expected `_MMYY` patterns before the report export step.
- Confirm generated `.xlsx` attachments exist under the expected `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe` folders.
- Confirm report cache counts match the report email subjects and are understood as data counts or exception counts per report.
- Confirm SFTP ad hoc jobs were started and completed successfully for each exported file group.
- Before changing DP3 amount cleanup, explicitly test the active `sap_airc` reference in the DP3 transform.

## High-Level Data Flow

```text
SQL Agent schedule
  |
  |-- MyBSS_Globe_EOM_00_P01_Setup_Cleanup_03Mth
  |     `-- sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_CleanupBeforeProcess_03
  |           `-- Global truncates in sdbTDIR2_Globe and dswTDIR2_Globe
  |
  |-- MyBSS_Globe_EOM_00_P02_Extract_03Mth
  |     `-- SSIS packages load Globe EOM source tables in sdbTDIR2_Globe
  |
  `-- MyBSS_Globe_EOM_00_P10_Preload_All_03Mth
        `-- dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOM_Preload_All
              |
              |-- Start and wait: MyBSS_Globe_EOM_DP2_P10_Preload_Unearned_AdHoc
              |     |-- Refresh SAP lookups in dgS4HANA_TDIR1
              |     |-- sap_airc -> stGlobe_DP2_Unearned -> ttGlobe_DP2_Unearned
              |     |-- Export txGlobe_DP2_Unearned_LoadFileSel.txt
              |     |-- Build SSRS caches, trigger subscriptions, send email
              |     `-- Start DP2 SFTP job
              |
              |-- Start and wait: MyBSS_Globe_EOM_DP3_P10_Preload_UC_AdHoc
              |     |-- Refresh SAP lookups in dgS4HANA_TDIR1
              |     |-- sap_aiuc_G and charge summary -> stGlobe_DP3_Unbilled_Char -> ttGlobe_DP3_Unbilled_Char
              |     |-- Export txGlobe_DP3_Unbilled_Char_ExportSel.txt
              |     |-- Build SSRS caches, trigger subscriptions, send email
              |     `-- Start DP3 SFTP job
              |
              |-- Start and wait: MyBSS_Globe_EOM_DP4_P10_Preload_UA_AdHoc
              |     |-- Refresh SAP lookups in dgS4HANA_TDIR1
              |     |-- 307_Unbilled_Adjustments_Report_G -> stGlobe_DP4_Unbilled_Adj -> ttGlobe_DP4_Unbilled_Adj
              |     |-- Aggregate SAP journal export txGlobe_DP4_Unbilled_Adj_ExportSel.txt
              |     |-- Build SSRS caches, trigger subscriptions, send email
              |     `-- Start DP4 SFTP job
              |
              |-- Start and wait: MyBSS_Globe_EOM_DP5_1_P10_Preload_Unconfirmed_AdHoc
              |     |-- Refresh SAP lookups in dgS4HANA_TDIR1
              |     |-- Unconfirmed_Advanced_MSF_Charges -> stGlobe_DP5_Unconfirmed -> ttGlobe_DP5_Unconfirmed
              |     |-- Aggregate CH and MSF SAP journal exports
              |     |-- Build SSRS caches, trigger subscriptions, send email
              |     `-- Start DP5 Unconfirmed SFTP job
              |
              `-- Start and wait: MyBSS_Globe_EOM_DP5_2_P10_Preload_Unconfirmed_Adj_AdHoc
                    |-- Refresh SAP lookups in dgS4HANA_TDIR1
                    |-- sap_glunbilled_unconf_G -> stGlobe_DP5_Unconfirmed_Adj -> ttGlobe_DP5_Unconfirmed_Adj
                    |-- Aggregate SAP journal export txGlobe_DP5_Unconfirmed_Adj_LoadFile.txt
                    |-- Build SSRS caches, trigger subscriptions, send email
                    `-- Start DP5 Unconfirmed Adj SFTP job

External services used during the flow:
  - dgS4HANA_TDIR1 SAP lookup and latest-log data
  - etl_db logging, export, cleanup, and SFTP helpers
  - ReportServer$DACPRD SSRS subscriptions and event queue
  - msdb SQL Agent and Database Mail
  - Windows F:\BOA\Transform export and report folders
```
