# sp_Job_MyBSS_Globe_EOC_Preload Reverse Engineering

Reverse engineered on 2026-05-08 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_Preload`

Execution starts on `sp_Job_MyBSS_Globe_EOC_Preload`. The document also covers the child procedures it calls through `etl_db.dbo.sp_ExecuteQueryAndLog`, the SQL Agent/SSIS context that feeds it, the SAP lookup refreshes, the export selector, report cache generation, SSRS subscription triggers, email sends, and the SFTP job started at the end of the process.

## Executive Summary

`sp_Job_MyBSS_Globe_EOC_Preload` is the SQL orchestration layer for the MyBSS Globe EOC DP1 Billed Preload process. It assumes upstream SQL Agent SSIS steps have already loaded the source extracts into `sdbTDIR2_Globe` staging tables.

At a high level, the procedure:

1. Refreshes SAP lookup/mapping tables from `dgS4HANA_TDIR1`.
2. Transforms one EOC cycle from `sapglbilled_ssis` into Globe DP1 billed staging and target tables.
3. Applies source rules for posting date, customer/subscriber data, charge/discount data, brand, SPA, revenue type, GL, SPB, remarks, batch number, and DSP unique key.
4. Uses SAP latest-log data to suppress records that appear to have already loaded successfully, unless current-cycle errors are detected.
5. Exports one SAP load text file for the requested cycle.
6. Rebuilds preload, manual, and control reconciliation report cache tables for the requested bill cycle.
7. Triggers SSRS subscriptions for Excel report output, sends report emails for nonempty reports, and starts the cycle-specific SFTP SQL Agent job.

The process is cycle-driven. The entry procedure receives `@CycleCode` values `EOC1` through `EOC11`; child procedures resolve those values to bill cycles such as `BC01` or `BC27` through `dbo.BillCycles`, and the export procedure also repeats the cycle-to-bill-cycle mapping in a hard-coded table variable.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Globe/programmability/stored_procedures/dbo.sp_Job_MyBSS_Globe_EOC_Preload.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Main subprocesses:

- `dbo.sp_MyBSS_Globe_EOC_Preload_LoadSapTables.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Prepare.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Control_Recon.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Manual_Report.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Preload.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_Report_Send.StoredProcedure.sql`
- `dbo.sp_MyBSS_Globe_EOC_Preload_SFTP.StoredProcedure.sql`
- `sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_CleanupBeforeProcess_12.StoredProcedure.sql`

Important tables/views:

- `sdbTDIR2_Globe/tables/dbo.sapglbilled_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.308_Billed_Adjustments_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.318_Billed_Charges_ssis.Table.sql`
- `sdbTDIR2_Globe/tables/dbo.411_Bill_Control_ssis.Table.sql`
- `dswTDIR2_Globe/tables/dbo.BillCycles.Table.sql`
- `dswTDIR2_Globe/tables/dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled.Table.sql`
- `dswTDIR2_Globe/tables/dbo.ttGlobe_DP1_Billed.Table.sql`
- `dswTDIR2_Globe/tables/dbo.rpt_Preload_Report_DP1_Billed_*_Cache.Table.sql`
- `dswTDIR2_Globe/views/dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled*UpdSel.View.sql`
- `dswTDIR2_Globe/views/dbo.ZTF0001S.View.sql`
- `dswTDIR2_Globe/views/dbo.ZTF0002S.View.sql`
- `dswTDIR2_Globe/views/dbo.ZFCO_UDT_MAP.View.sql`
- `dswTDIR2_Globe/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dbo.sp_rpt_tvGlobe_DP1_Billed_Preload_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvGlobe_DP1_Billed_ManualReport_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvGlobe_DP1_Billed_Control_Recon_SSRS.StoredProcedure.sql`

Historical reference:

- `dbo.sp_MyBSS_Globe_EOC_Preload_LoadFiles.StoredProcedure.sql`

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Globe` | SSIS landing/staging tables and the EOC cleanup procedure. |
| `dswTDIR2_Globe` | Orchestration, staging, target, export selector, SAP wrapper views, report cache tables, and SSRS report stored procedures. |
| `dgS4HANA_TDIR1` | SAP lookup/mapping tables and SAP latest-log data. |
| `etl_db` | Execution logging, text export, historical SQL Agent helpers, and SAP SFTP helper procedures. |
| `msdb` | SQL Agent job start and Database Mail. |
| `ReportServer$DACPRD` | SSRS subscription lookup and event queue. |
| Windows file system | Export and report paths on `F:\BOA\Transform\...`. |

Important helper procedures outside the Globe database:

- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `etl_db.dbo.sp_ExportTextFile`
- `etl_db.dbo.sp_sftp_sap_del`
- `etl_db.dbo.sp_sftp_sap_push`
- `msdb.dbo.sp_start_job`
- `msdb.dbo.sp_send_dbmail`
- `ReportServer$DACPRD.dbo.AddEvent`
- `xp_cmdshell`

## SQL Agent Context

The scheduled SQL Agent preload jobs are named like:

`MyBSS_Globe_EOC01_P10_Preload_12Mth`

Based on `sql-agent-jobs.txt`, each scheduled preload job runs monthly at `11:15:00` and follows this step pattern:

1. SSIS `MyBss_Globe_sapglbilled`
2. SSIS `MyBss_Globe_308_Billed_Adjustments`
3. SSIS `MyBss_Globe_411_Bill_Control_PHP`
4. SSIS `MyBss_Globe_318_Billed_Charges`
5. T-SQL `sp_Job_MyBSS_Globe_EOC_Preload`

The T-SQL step calls the entry procedure through `etl_db.dbo.sp_ExecuteQueryAndLog` with:

- System: `MyBSS`
- Company/entity: `Globe`
- Process: `DP1_Billed - Preload`
- Cycle: hard-coded per SQL Agent job, such as `EOC1`

The setup/cleanup job is:

`MyBSS_Globe_EOC00_P01_Setup_Cleanup_12Mth`

It runs monthly at `08:30:00` based on the extracted metadata and calls `sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_CleanupBeforeProcess_12`.

The SFTP jobs are separate ad hoc SQL Agent jobs named like:

`MyBSS_Globe_EOC01_P15_Preload_SFTP_AdHoc`

The main preload stored procedure starts the relevant SFTP job asynchronously with `msdb.dbo.sp_start_job`.

Important observed detail:

`etl_pipelines.txt` lists `dswTDIR2_Globe_Cache` for Globe bill cycles, but the active preload code reviewed here writes report caches in `dswTDIR2_Globe`. The same metadata file also lists related postload jobs with `P10_Postload` names and a typo `Postoad`; `sql-agent-jobs.txt` uses `P20_Postload`. This does not change the preload call chain, but it is a metadata consistency issue around related jobs.

## Cleanup Process

`sdbTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_CleanupBeforeProcess_12` is not called by `sp_Job_MyBSS_Globe_EOC_Preload`, but SQL Agent metadata lists it as the EOC setup/cleanup step.

It truncates:

- `sdbTDIR2_Globe.dbo.411_Bill_Control_ssis`
- `sdbTDIR2_Globe.dbo.sapglbilled_ssis`
- `sdbTDIR2_Globe.dbo.318_Billed_Charges_ssis`
- `sdbTDIR2_Globe.dbo.308_Billed_Adjustments_ssis`
- `dswTDIR2_Globe.dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled`
- `dswTDIR2_Globe.dbo.ttGlobe_DP1_Billed`

This cleanup is global, not cycle-scoped.

## Cycle Mapping

`dbo.BillCycles` defines the runtime columns `BillCycle`, `CycleCode`, `Description`, `RunDay`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName`, but the repository only contains the table schema, not seed rows. `Keyword_SSRS` and `ExportFileKey` are therefore data-driven live-table dependencies.

The following mapping is observed from `sql-agent-jobs.txt` and from the hard-coded export procedure table variable:

| CycleCode | BillCycle | Job label | Scheduled day | Export file |
| --- | --- | --- | ---: | --- |
| `EOC1` | `BC01` | `12Mth` | 12 | `txGlobe_DP1_Billed_Cycle1LoadFileSel.txt` |
| `EOC2` | `BC06` | `14Mth` | 14 | `txGlobe_DP1_Billed_Cycle2LoadFileSel.txt` |
| `EOC3` | `BC08` | `15Mth` | 15 | `txGlobe_DP1_Billed_Cycle3LoadFileSel.txt` |
| `EOC4` | `BC10` | `16Mth` | 16 | `txGlobe_DP1_Billed_Cycle4LoadFileSel.txt` |
| `EOC5` | `BC11` | `17Mth` | 17 | `txGlobe_DP1_Billed_Cycle5LoadFileSel.txt` |
| `EOC6` | `BC13` | `19Mth` | 19 | `txGlobe_DP1_Billed_Cycle6LoadFileSel.txt` |
| `EOC7` | `BC16` | `21Mth` | 21 | `txGlobe_DP1_Billed_Cycle7LoadFileSel.txt` |
| `EOC8` | `BC18` | `24Mth` | 24 | `txGlobe_DP1_Billed_Cycle8LoadFileSel.txt` |
| `EOC9` | `BC21` | `26Mth` | 26 | `txGlobe_DP1_Billed_Cycle9LoadFileSel.txt` |
| `EOC10` | `BC24` | `30Mth` | 30 | `txGlobe_DP1_Billed_Cyc10LoadFileSel.txt` |
| `EOC11` | `BC27` | `02Mth` | 2 | `txGlobe_DP1_Billed_Cyc11LoadFileSel.txt` |

The SFTP job name is built from `@CycleCode` by removing `EOC`, formatting the number as two digits, then creating:

`MyBSS_Globe_EOC{NN}_P15_Preload_SFTP_AdHoc`

Example: `EOC1` becomes `MyBSS_Globe_EOC01_P15_Preload_SFTP_AdHoc`.

## Main Procedure Call Chain

`sp_Job_MyBSS_Globe_EOC_Preload @CycleCode`

1. `sp_MyBSS_Globe_EOC_Preload_LoadSapTables`
2. `sp_MyBSS_Globe_EOC_Preload_Transform @CycleCode`
3. `sp_MyBSS_Globe_EOC_Preload_Export @CycleCode`
4. `sp_MyBSS_Globe_EOC_Preload_Report_Prepare @CycleCode`
5. `sp_MyBSS_Globe_EOC_Preload_Report_Export @CycleCode`
6. `sp_MyBSS_Globe_EOC_Preload_Report_Send @CycleCode`
7. `msdb.dbo.sp_start_job @JobName = 'MyBSS_Globe_EOC{NN}_P15_Preload_SFTP_AdHoc'`

Steps 1 through 6 are executed through `etl_db.dbo.sp_ExecuteQueryAndLog` with these logging dimensions:

- System: `MyBSS`
- Company/entity: `Globe`
- Process: `DP1_Billed - Preload`
- Cycle: `@CycleCode`
- Procedure name and dynamic command text

Important observed detail:

The stored procedure contains a commented-out SFTP block that would call `sp_MyBSS_Globe_EOC_Preload_SFTP` through `sp_ExecuteQueryAndLog`. The active implementation does not use that block; it builds a SQL Agent job name and starts the job directly.

Historical reference:

The entry procedure also contains a commented-out load-files block for `sp_MyBSS_Globe_EOC_Preload_LoadFiles`. That procedure starts four SSIS jobs and polls `etl_db.dbo.fn_IsJobCompleted` every 3 seconds up to 25 attempts. It is not active in the current entry procedure; the active path relies on the SQL Agent preload job's SSIS steps.

## Step 1: Load SAP Lookup Tables

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_LoadSapTables`

This procedure has no cycle parameter. It refreshes SAP lookup/mapping data by calling:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFCO_UDT_MAP`

Business purpose:

- `ZTF0001S` is used during transform to update the header row batch number from `BATCH_NO + 1` for `BUKRS = 'GLOB'`.
- `ZTF0002S` is used to derive `zGL_Code` from `GLCODE` and `zSPB` from `SGROUP`, joined by charge code and discount plan code.
- `ZFCO_UDT_MAP` is used to map brand, SPA, and revenue type values for `FROM_SYSTEM = 'AMAR'`, `EVENT = 'ARBC'`, `TO_SYSTEM = 'SAPFIGL'`, `BUKRS = 'GLOB'`.

Local wrapper views for `ZTF0001S`, `ZTF0002S`, `ZFCO_UDT_MAP`, and `ZFFI_REPORT_ODBC_LATESTLOGS` filter `MANDT = '300'`.

## Step 2: Transform

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Transform @CycleCode`

### Parameter Resolution

The procedure resolves:

`@BillCycle = BillCycles.BillCycle WHERE CycleCode = @CycleCode`

There is no explicit validation or error if `@CycleCode` is missing from `BillCycles`.

### Input and Staging

Main input table:

`sdbTDIR2_Globe.dbo.sapglbilled_ssis`

The table has generic `Column1` through `Column14`, plus `BillCycle`, `RowNumber`, `FileName`, `SequencialID`, and `DateProcessed`.

Destination staging table:

`dswTDIR2_Globe.dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled`

Primary key:

- `Cycle_Code`
- `zrownumber`

The transform first deletes existing staging rows for the current bill cycle:

`DELETE FROM stGlobe_DP1_Billed_TDIR2_Globe_saplbilled WHERE Cycle_Code = @BillCycle`

Then it inserts rows from `sapglbilled_ssis` where `BillCycle = @BillCycle`.

Column handling during the insert:

- `Cycle_Code` gets `sapglbilled_ssis.BillCycle`.
- `zrownumber` gets `sapglbilled_ssis.RowNumber`.
- `Column1` through `Column10` are copied.
- `Column8` and `Column9` are cast to `DECIMAL(18,2)` and converted back to `NVARCHAR(50)`.
- `Column11` through `Column14` exist in `sapglbilled_ssis` but are not inserted into this staging table.

Historical reference:

The transform contains a disabled block that adjusted header batch numbers for `BC06` and `BC08`. The active code does not run that adjustment.

### Source Rules Applied to Staging

The transform calls generated source-rule update procedures and then applies one inline batch-number update. The practical mappings are:

| Target field | Rule |
| --- | --- |
| `zLegacyCycle_Code` | `Cycle_Code` |
| `zLegacyDSP_Order` | `zrownumber` |
| `zDSP_Order` | `zrownumber` |
| `zData` | `Column1` |
| `zPosting_Date` | `Column2` |
| `zSAPFIGL` | `Column3` |
| `zCT` | `Column4` |
| `zST` | Initially `Column5`; header rows are later overwritten from `ZTF0001S.BATCH_NO + 1`. |
| `zCH_Code` | `Column6` |
| `zDP_Code` | `Column7` |
| `zAmount` | `Column8` |
| `zHits` | `Column9` |
| `zUOM` | `Column10` |
| `zBrand` | `ZFCO_UDT_MAP.TARGET_VAL` for dimension `BRAND`, mapped from `Column3`. |
| `zSPA` | `ZFCO_UDT_MAP.TARGET_VAL` for dimension `CFU`, mapped from `Column4`; if still null on detail rows, `Column4 = 'I'` becomes `Internal`, otherwise `Column4`. |
| `zRev_type` | `ZFCO_UDT_MAP.TARGET_VAL` for dimension `PRODUCT`, mapped from `Column5`. |
| `zGL_Code` | `ZTF0002S.GLCODE`, joined on `Column6 = CHCODE` and `Column7 = DPCODE`. |
| `zSPB` | `ZTF0002S.SGROUP`, joined on `Column6 = CHCODE` and `Column7 = DPCODE`. |
| `zRemarks` | Detail rows only: `Internal` when `zSPA = 'Internal'`; `For posting` when `zGL_Code <> ''`; otherwise `Not for posting`. |
| `zDSP_UniqueKey` | Detail rows only: `LEFT('GBilled-' + zrownumber + '-' + Column2, 44)`. Non-detail rows get `NULL`. |

The inline batch-number update applies to rows where:

- `Column1 = '00'`
- `zLegacyCycle_Code = @BillCycle`
- `Column2 = ZTF0001S.FROM_SYSTEM`
- `Column3 = ZTF0001S.TO_SYSTEM`
- `Column4 = ZTF0001S.EVENT`
- `ZTF0001S.BUKRS = 'GLOB'`

It sets:

`zST = CAST(CAST(ZTF0001S.BATCH_NO AS int) + 1 AS nvarchar)`

Important observed detail:

A generated `srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_BatchNoUpd` procedure exists, but the active transform does not call it. The transform uses the inline, cycle-scoped update instead.

### Target Insert

Target table:

`dswTDIR2_Globe.dbo.ttGlobe_DP1_Billed`

Primary key:

- `zLegacyDSP_Order`
- `zLegacyCycle_Code`
- `zSource`

Before inserting, the transform deletes existing target rows for the current bill cycle and source:

`DELETE FROM ttGlobe_DP1_Billed WHERE zSource = 'TDIR2_Globe' AND zLegacyCycle_Code = @BillCycle`

It then inserts the transformed rows from staging for the current bill cycle into `ttGlobe_DP1_Billed`.

### Preload-Time Loaded Status Logic

The active transform contains custom logic to suppress rows that appear to have already loaded into SAP.

It updates `ttGlobe_DP1_Billed.zLoaded = '1'` for detail rows where:

- `ttGlobe_DP1_Billed.ZDSP_ORDER = dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER`
- `ttGlobe_DP1_Billed.ZDSP_UNIQUEKEY = dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY`
- `Data = '01'`
- `zLegacyCycle_Code = @BillCycle`
- `Z_MESSAGE` does not match any configured error pattern

Configured error patterns:

- `%is not found%`
- `%requires an assignment to a CO object%`
- `%does not exist in chart of accounts%`
- `%Error in document%`
- `%not defined in chart of accounts%`
- `%not allowed for characteristic%`
- `%Balance in Transaction Currency%`
- `%Header Control on Amount is Invalid%`

After that, a CTE checks for current-cycle matching SAP logs with any of those error patterns. If at least one such error exists for the bill cycle, the procedure sets `zLoaded = '0'` for all `ttGlobe_DP1_Billed` rows in that bill cycle.

Important observed detail:

The final reset is cycle-scoped but not row-scoped. One detected SAP error for the bill cycle can reset every row in that cycle to not loaded.

## Step 3: Export SAP Load File

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Export @CycleCode`

Export directory:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_New`

The procedure builds a table variable with the hard-coded `CycleCode`, SQL query, export path, and output file name. It selects the row for `@CycleCode` and calls:

`etl_db.dbo.sp_ExportTextFile @SqlQuery, @Path, @FileName`

Important observed detail:

The cursor fetches `[Path]` into `@path_current`, but the export call passes the constant `@Path`. The current table variable uses the same path for every row, so this does not change behavior in the reviewed source.

### Export Selector

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel @BillCycle`

This procedure returns the rows that become the SAP load text file. It reconstructs the same control reconciliation logic used by the report prepare procedure:

- `308_Billed_Adjustments_ssis` detail rows where `LEN(Column1) = 1`, plus header cycle metadata.
- `318_Billed_Charges_ssis` detail rows where `LEN(Column1) = 1`, plus header cycle metadata.
- `411_Bill_Control_ssis` totals for billed adjustments.
- `411_Bill_Control_ssis` totals for billed charges.
- `sapglbilled_ssis` total from `Column8`.

The export rowset comes from `ttGlobe_DP1_Billed` for the selected bill cycle where:

- `zLoaded = '0'`
- the `sapglbilled` reconciliation difference is between `-100000.00` and `100000.00`

Output behavior:

- The output includes `Column01` through `Column14`, plus `zDSP_Order` and `zDSP_UniqueKey`.
- `Data` becomes `Column01`.
- `Posting_Date` becomes `Column02`.
- `SAPFIGL` becomes `Column03`, except trailer rows where `Column01 = '99'`; for those, `Column03` is recomputed as the sum of selected detail `Column08` values.
- `Amount` is formatted with `FORMAT(CAST(Column08 AS DECIMAL(18,2)), '0.##')`.
- `Hits` is cast through `DECIMAL(18,2)` and back to text.
- `GL` is emitted as blank in `Column13`.
- Rows are ordered by `Column01` and `zDSP_Order`.

## Step 4: Report Prepare

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Report_Prepare @CycleCode`

This resolves:

`@BillCycle = BillCycles.BillCycle WHERE CycleCode = @CycleCode`

Then it executes:

1. `sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Control_Recon @BillCycle`
2. `sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Manual_Report @BillCycle`
3. `sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Preload @BillCycle`

### Control Reconciliation Cache

Procedure:

`sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Control_Recon @BillCycle`

Cache table:

`rpt_Preload_Report_DP1_Billed_Control_Recon_Cache`

Behavior:

- Deletes cache rows for the selected bill cycle.
- Inserts formatted rows from `411_Bill_Control_ssis`, excluding `Column1 = 'Report Creator : Amdocs BI Team'`.
- Adds reconciliation section rows for billed charges, billed adjustment, and `sapglbilled`.

Reconciliation calculations:

| Row | Report-side value | Source-side value | Difference |
| --- | --- | --- | --- |
| `Billed Charges` | Sum of selected `411_Bill_Control_ssis.Column3` charge totals. | Sum of `318_Billed_Charges_ssis.Column8` as `Total Amount`. | Report-side minus source-side. |
| `Billed Adjustment` | Sum of selected `411_Bill_Control_ssis.Column3` adjustment totals. | Sum of `308_Billed_Adjustments_ssis.Column9` as `Amount`. | Report-side minus source-side. |
| `sapglbilled` | Sum of billed charges plus billed adjustments from the source extracts. | Sum of `sapglbilled_ssis.Column8`. | Source-extract sum minus `sapglbilled` total. |

### Manual Report Cache

Procedure:

`sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Manual_Report @BillCycle`

Cache table:

`rpt_Preload_Report_DP1_Billed_ManualReport_Cache`

Behavior:

- Selects detail rows from `ttGlobe_DP1_Billed` where `Data = '01'` and `zLegacyCycle_Code = @BillCycle`.
- Deletes cache rows for the selected bill cycle.
- Inserts the detail rows with posting, customer/subscriber, charge, amount, brand, SPA, revenue type, GL, SPB, and remarks columns.

Important observed detail:

The manual report cache is not filtered by `zLoaded`. It includes all detail rows for the selected bill cycle.

### Preload Report Cache

Procedure:

`sp_MyBSS_Globe_EOC_Preload_Report_Prepare_DP1_Billed_Preload @BillCycle`

Cache table:

`rpt_Preload_Report_DP1_Billed_Preload_Cache`

Behavior:

- Recomputes the control reconciliation CTEs.
- Selects rows from `ttGlobe_DP1_Billed` for the bill cycle where `zLoaded = '0'`.
- Applies the same `sapglbilled` reconciliation threshold used by the export selector: difference between `-100000.00` and `100000.00`.
- Deletes cache rows for the selected bill cycle.
- Inserts the selected preload rows.

## Step 5: Report Export

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Report_Export @CycleCode`

The procedure reads `BillCycles.Keyword_SSRS` for `@CycleCode` and builds these SSRS subscription descriptions:

- `Glob_Billed_Preload_DP1{Keyword_SSRS}`
- `Glob_Billed_ManualReport_DP1{Keyword_SSRS}`
- `Glob_Billed_Control_Recon_DP1{Keyword_SSRS}`

It looks up matching rows in `ReportServer$DACPRD.dbo.Subscriptions`.

For each matching subscription:

1. Deletes the previous Excel output with `xp_cmdshell`.
2. Triggers the SSRS timed subscription with `ReportServer$DACPRD.dbo.AddEvent`.
3. Polls `ReportServer$DACPRD.dbo.Event` for the subscription ID every 3 seconds.
4. Stops polling when the event row disappears or after 25 iterations.

Report output path:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\{SubscriptionDescription}.xlsx`

The SSRS stored procedures reviewed for these reports read the report cache tables by resolving `@CycleCode` back to `BillCycles.BillCycle`.

## Step 6: Report Send

Procedure:

`dbo.sp_MyBSS_Globe_EOC_Preload_Report_Send @CycleCode`

The procedure reads `BillCycles.Keyword_SSRS` and `BillCycles.BillCycle`, then builds the same three SSRS subscription descriptions used by report export.

Record-count rules:

| Report subscription description | Record count source |
| --- | --- |
| `Glob_Billed_Preload_DP1{Keyword_SSRS}` | Count rows in `rpt_Preload_Report_DP1_Billed_Preload_Cache` where `BillCycle = @BillCycle` and `Data = '01'`. |
| `Glob_Billed_ManualReport_DP1{Keyword_SSRS}` | Count rows in `rpt_Preload_Report_DP1_Billed_ManualReport_Cache` where `BillCycle = @BillCycle`. |
| `Glob_Billed_Control_Recon_DP1{Keyword_SSRS}` | Count rows in `rpt_Preload_Report_DP1_Billed_Control_Recon_Cache` where `BillCycle = @BillCycle`. |

Only reports with `recordcount > 0` are emailed.

Email settings:

- Mail profile: `SSRS`
- Recipients: `rosoldevilla@globe.com.ph;rnvillar@globe.com.ph`
- Copy recipients: `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph`
- Subject format: `Report Notif: MyBSS {SubscriptionDescription} - {RecordCount} Record(s) Generated`
- Body format: HTML
- Report server link in body: `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx`
- Attachment: `F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\{SubscriptionDescription}.xlsx`

## Step 7: SFTP

The entry procedure starts the SFTP SQL Agent job after report send:

`MyBSS_Globe_EOC{NN}_P15_Preload_SFTP_AdHoc`

The job executes:

`dbo.sp_MyBSS_Globe_EOC_Preload_SFTP @CycleCode`

SFTP procedure behavior:

1. Sets `@FileDelKey = 'txGlobe_DP1_Billed_Cycle_Del'`.
2. Calls `etl_db.dbo.sp_sftp_sap_del @FileDelKey`.
3. Reads `BillCycles.ExportFileKey` for the requested `@CycleCode`.
4. Calls `etl_db.dbo.sp_sftp_sap_push @FileKey` for each matching key.

Important observed detail:

`ExportFileKey` is live data from `dbo.BillCycles`. The repository contains the table schema, but not the seed data that maps cycle codes to SFTP file keys.

## Business Logic Summary

### Source and Target Tables

| Role | Object |
| --- | --- |
| Main SAP billed source extract | `sdbTDIR2_Globe.dbo.sapglbilled_ssis` |
| Billed adjustments source extract | `sdbTDIR2_Globe.dbo.308_Billed_Adjustments_ssis` |
| Billed charges source extract | `sdbTDIR2_Globe.dbo.318_Billed_Charges_ssis` |
| Bill control source extract | `sdbTDIR2_Globe.dbo.411_Bill_Control_ssis` |
| Transform staging | `dswTDIR2_Globe.dbo.stGlobe_DP1_Billed_TDIR2_Globe_saplbilled` |
| Transform target | `dswTDIR2_Globe.dbo.ttGlobe_DP1_Billed` |
| Control reconciliation report cache | `dswTDIR2_Globe.dbo.rpt_Preload_Report_DP1_Billed_Control_Recon_Cache` |
| Manual report cache | `dswTDIR2_Globe.dbo.rpt_Preload_Report_DP1_Billed_ManualReport_Cache` |
| Preload report cache | `dswTDIR2_Globe.dbo.rpt_Preload_Report_DP1_Billed_Preload_Cache` |

### Core Rules

- The runtime bill cycle is resolved from `BillCycles` using `@CycleCode`.
- Staging and target reloads are cycle-scoped.
- The separate cleanup job truncates the shared SSIS, staging, and target tables globally.
- Header batch numbers come from `ZTF0001S.BATCH_NO + 1` for Globe rows.
- Brand, SPA, and revenue type are mapped through `ZFCO_UDT_MAP` for Globe SAPFIGL/ARBC rules.
- GL and SPB are mapped through `ZTF0002S` using charge code plus discount plan code.
- Detail unique keys are `GBilled-{zrownumber}-{Column2}`, truncated to 44 characters.
- Rows with matching successful SAP latest logs are marked loaded before export.
- If any matching SAP latest-log error is detected for the bill cycle, all target rows for that bill cycle are reset to not loaded.
- Export and preload report output are suppressed unless the `sapglbilled` reconciliation difference is within `+/-100000.00`.
- Manual report output includes all detail rows for the cycle, regardless of `zLoaded`.
- Report emails are sent only for reports with nonzero record counts.

## Operational Risks and Gaps

- `@CycleCode` is not validated. If `BillCycles` has no matching row, `@BillCycle` becomes null and the cycle-scoped deletes/inserts/report steps can silently affect no rows.
- The entry procedure does not run the SSIS extracts itself. The historical load-files path is commented out, so SQL Agent step ordering is required for correct input data.
- The cleanup procedure uses `TRUNCATE TABLE` on shared SSIS, staging, and target tables. It is not cycle-scoped.
- `sapglbilled_ssis.Column11` through `Column14` exist in the source table but are not loaded by the transform.
- The transform casts `Column8` and `Column9` to `DECIMAL(18,2)`. Non-numeric source values would fail the transform.
- The preload loaded-status logic uses SAP latest logs from `dgS4HANA_TDIR1` and does not join on upload filename. A previous matching log can affect current export eligibility.
- The final SAP-error reset sets `zLoaded = '0'` for every row in the bill cycle when any configured error exists for that cycle.
- The SAP success/error classification depends on string pattern filters. New SAP error messages outside the configured patterns could be misclassified.
- Export and preload report selection return no rows when the `sapglbilled` reconciliation difference falls outside `+/-100000.00`; the reviewed code does not raise a hard error for that condition.
- File paths are hard-coded to `F:\BOA\Transform\...`.
- Report export uses `xp_cmdshell` to delete prior Excel files.
- SSRS export polling stops after 25 three-second iterations and only prints a message when the maximum is reached.
- The entry procedure starts the SFTP SQL Agent job asynchronously. It does not wait for completion or log SFTP execution through the same `sp_ExecuteQueryAndLog` wrapper.
- SFTP file keys are data-driven in `BillCycles.ExportFileKey`, but no seed data is scripted in this repository.
- Report recipients and copy recipients are hard-coded in `sp_MyBSS_Globe_EOC_Preload_Report_Send`.

## Validation Checklist

Before running or changing the process:

- Confirm the `BillCycles` row exists for the requested `@CycleCode`.
- Confirm `BillCycles.BillCycle`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName` are populated for the cycle.
- Confirm SQL Agent preload steps run in order: `sapglbilled`, `308_Billed_Adjustments`, `411_Bill_Control_PHP`, `318_Billed_Charges`, then `sp_Job_MyBSS_Globe_EOC_Preload`.
- Confirm cleanup timing will not truncate data needed by another run or cycle.
- Confirm the four `sdbTDIR2_Globe` SSIS tables contain rows for the expected `BillCycle`.
- Confirm `sapglbilled_ssis.Column8` and `Column9` contain numeric values for rows being transformed.
- Confirm SAP lookup refresh procedures for `ZTF0001S`, `ZTF0002S`, and `ZFCO_UDT_MAP` completed successfully.
- Confirm `ZTF0001S` has the expected Globe header mapping for `Column2`, `Column3`, `Column4`, and `BUKRS = 'GLOB'`.
- Confirm `ZFCO_UDT_MAP` contains Globe mapping rows for dimensions `BRAND`, `CFU`, and `PRODUCT`.
- Confirm `ZTF0002S` contains mappings for charge code and discount plan code combinations used by the cycle.
- Review SAP latest logs before reruns, because matching `ZDSP_ORDER` and `ZDSP_UNIQUEKEY` can mark rows loaded before export.
- Check the control reconciliation cache, especially the `sapglbilled` difference, before expecting preload export rows.
- Confirm SSRS subscription descriptions match `Glob_Billed_*_DP1{Keyword_SSRS}`.
- Confirm the report output directory and export directory exist on the SQL Server host.
- Confirm Database Mail profile `SSRS` and the hard-coded recipients are still valid.
- Confirm the SFTP ad hoc SQL Agent job exists for the cycle and that `BillCycles.ExportFileKey` maps to the expected SAP file key.

## High-Level Data Flow

```text
SQL Agent monthly preload job
  |
  |-- SSIS MyBss_Globe_sapglbilled
  |       -> sdbTDIR2_Globe.dbo.sapglbilled_ssis
  |
  |-- SSIS MyBss_Globe_308_Billed_Adjustments
  |       -> sdbTDIR2_Globe.dbo.308_Billed_Adjustments_ssis
  |
  |-- SSIS MyBss_Globe_411_Bill_Control_PHP
  |       -> sdbTDIR2_Globe.dbo.411_Bill_Control_ssis
  |
  |-- SSIS MyBss_Globe_318_Billed_Charges
  |       -> sdbTDIR2_Globe.dbo.318_Billed_Charges_ssis
  |
  `-- etl_db.dbo.sp_ExecuteQueryAndLog
       -> dswTDIR2_Globe.dbo.sp_Job_MyBSS_Globe_EOC_Preload @CycleCode
            |
            |-- sp_MyBSS_Globe_EOC_Preload_LoadSapTables
            |     -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
            |     -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
            |     -> dgS4HANA_TDIR1.dbo.sp_ZFCO_UDT_MAP
            |
            |-- sp_MyBSS_Globe_EOC_Preload_Transform
            |     -> stGlobe_DP1_Billed_TDIR2_Globe_saplbilled
            |     -> ZTF0001S / ZTF0002S / ZFCO_UDT_MAP rules
            |     -> ttGlobe_DP1_Billed
            |     -> dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS loaded-status checks
            |
            |-- sp_MyBSS_Globe_EOC_Preload_Export
            |     -> sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel
            |     -> etl_db.dbo.sp_ExportTextFile
            |     -> F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_New
            |
            |-- sp_MyBSS_Globe_EOC_Preload_Report_Prepare
            |     -> rpt_Preload_Report_DP1_Billed_Control_Recon_Cache
            |     -> rpt_Preload_Report_DP1_Billed_ManualReport_Cache
            |     -> rpt_Preload_Report_DP1_Billed_Preload_Cache
            |
            |-- sp_MyBSS_Globe_EOC_Preload_Report_Export
            |     -> ReportServer$DACPRD.dbo.Subscriptions
            |     -> ReportServer$DACPRD.dbo.AddEvent
            |     -> F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS
            |
            |-- sp_MyBSS_Globe_EOC_Preload_Report_Send
            |     -> msdb.dbo.sp_send_dbmail
            |
            `-- msdb.dbo.sp_start_job
                  -> MyBSS_Globe_EOC{NN}_P15_Preload_SFTP_AdHoc
                       -> sp_MyBSS_Globe_EOC_Preload_SFTP
                            -> etl_db.dbo.sp_sftp_sap_del
                            -> etl_db.dbo.sp_sftp_sap_push
```
