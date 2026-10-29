# sp_Job_MyBSS_Bayan_EOC_Preload Reverse Engineering

Reverse engineered on 2026-05-08 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOC_Preload`

Execution starts on `sp_Job_MyBSS_Bayan_EOC_Preload`. The document also covers the child procedures it calls through `etl_db.dbo.sp_ExecuteQueryAndLog`, the SQL Agent/SSIS context that feeds it, the SAP lookup refreshes, the DP1 billed transform, the SAP load-file export, report cache generation, SSRS subscription triggers, email sends, and the SFTP job started at the end of the process.

## Executive Summary

`sp_Job_MyBSS_Bayan_EOC_Preload` is the SQL orchestration layer for the MyBSS Bayan EOC DP1 Billed Preload process. It assumes upstream SQL Agent SSIS steps have already loaded the source extracts into `sdbTDIR2_Bayan` staging tables.

At a high level, the procedure:

1. Refreshes SAP lookup tables from `dgS4HANA_TDIR1`.
2. Transforms one EOC cycle from `sap_glbilled_ssis` into Bayan DP1 billed staging and target tables.
3. Applies source rules that copy the 19 SAP interface columns, derive DSP order keys, synchronize the header batch number from SAP `ZTF0001S`, and build `zDSP_UniqueKey`.
4. Updates `ttBayan_Billed.zLoaded` from SAP latest-log messages, although the current export selector does not filter on `zLoaded`.
5. Exports one SAP load text file for the requested cycle.
6. Rebuilds preload, missing charge code, missing subscriber type, PHP recon summary, and USD recon summary report caches.
7. Triggers SSRS subscriptions for Excel report output, sends report emails for nonempty reports, and starts the cycle-specific SFTP SQL Agent job.

The process is cycle-driven. The entry procedure receives `@CycleCode` values `EOC1` through `EOC11`; child procedures resolve those values to bill cycles such as `BC01` or `BC27` through `dbo.BillCycles`, and the export procedure repeats the cycle-to-bill-cycle mapping in a hard-coded table variable.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Bayan/programmability/stored_procedures/dbo.sp_Job_MyBSS_Bayan_EOC_Preload.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Main subprocesses:

- `dbo.sp_MyBSS_Bayan_EOC_Preload_LoadSapTables.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Transform.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Export_DP1_Billed_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Preload.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Send.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_SFTP.StoredProcedure.sql`
- `sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOC_CleanupBeforeProcess_12.StoredProcedure.sql`

Important generated source-rule procedures and views:

- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_zLegacyCycle_CodeUpd.StoredProcedure.sql`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_zLegacyDSP_OrderUpd.StoredProcedure.sql`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_zDSP_OrderUpd.StoredProcedure.sql`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_zColumn01Upd` through `zColumn19Upd`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_Column05_batchno_Upd.StoredProcedure.sql`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled_zDSP_UniqueKeyUpd.StoredProcedure.sql`
- Matching `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilled*UpdSel.View.sql` files

Important tables/views:

- `sdbTDIR2_Bayan/tables/dbo.sap_glbilled_ssis.Table.sql`
- `sdbTDIR2_Bayan/tables/dbo.308_Billed_Adjustments_ssis.Table.sql`
- `sdbTDIR2_Bayan/tables/dbo.318_Billed_Charges_ssis.Table.sql`
- `sdbTDIR2_Bayan/tables/dbo.411_Bill_Control_PHP_ssis.Table.sql`
- `sdbTDIR2_Bayan/tables/dbo.411_Bill_Control_USD_ssis.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.BillCycles.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.stBayan_Billed_TDIR2_Bayan_sapglbilled.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.ttBayan_Billed.Table.sql`
- `dswTDIR2_Bayan/tables/dbo.rpt_Preload_Report_Prepare_DP1_Billed_*_Cache.Table.sql`
- `dswTDIR2_Bayan/views/dbo.ZTF0001S.View.sql`
- `dswTDIR2_Bayan/views/dbo.ZTF0002S.View.sql`
- `dswTDIR2_Bayan/views/dbo.ZFFI_SUBTYPE.View.sql`
- `dswTDIR2_Bayan/views/dbo.ZFFI_0346.View.sql`
- `dswTDIR2_Bayan/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dbo.sp_rpt_tvBayan_DP1_Billed_Preload_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvBayan_DP1_Billed_Preload_ChargeCodeMissing_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvBayan_DP1_Billed_Preload_Subscriber_TypeMissing_SSRS.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Recon_Summary_PHP_SSRS.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Recon_Summary_USD_SSRS.StoredProcedure.sql`

Historical reference:

- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilledDel.StoredProcedure.sql`
- `dbo.srBayan_Billed_TDIR2_Bayan_sapglbilledIns.StoredProcedure.sql`
- `dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Send_bak.StoredProcedure.sql`

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Bayan` | SSIS landing/staging tables and the EOC cleanup procedure. |
| `dswTDIR2_Bayan` | Orchestration, staging, target, SAP wrapper views, export selector, report cache tables, and SSRS report stored procedures. |
| `dswTDIR2_Bayan_Cache` | Historical/report cache database objects exist for related Bayan billed report selectors, but the active preload procedures reviewed here use `dswTDIR2_Bayan` cache tables. |
| `dgS4HANA_TDIR1` | SAP lookup/reference tables and SAP latest-log data. |
| `etl_db` | Execution logging, text export, and SAP SFTP helper procedures. |
| `msdb` | SQL Agent job start and Database Mail. |
| `ReportServer$DACPRD` | SSRS subscription lookup and event queue. |
| Windows file system | Export and report paths on `F:\BOA\Transform\...`. |
| SSIS runtime | Extract packages under `C:\Users\dscadm\Documents\Visual Studio 2010\Projects\MyBssIntegration\...`. |

Important helper procedures outside the Bayan database:

- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `etl_db.dbo.sp_ExportTextFile`
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

Local wrapper views for `ZTF0001S`, `ZTF0002S`, `ZFFI_SUBTYPE`, `ZFFI_0346`, and `ZFFI_REPORT_ODBC_LATESTLOGS` read from `dgS4HANA_TDIR1` and filter `MANDT = '300'`.

## SQL Agent Context

The scheduled SQL Agent preload jobs are named like:

`MyBSS_Bayan_EOC01_P10_Preload_12Mth`

Based on `sql-agent-jobs.txt`, the scheduled Bayan EOC preload jobs run monthly at `11:15:00`. Most scheduled preload jobs follow this step pattern:

1. SSIS `MyBss_Bayan_sapglbilled`
2. SSIS `MyBss_Bayan_308_Billed_Adjustments`
3. SSIS `MyBss_Bayan_411_Bill_Control_USD`
4. SSIS `MyBss_Bayan_411_Bill_Control_PHP`
5. SSIS `MyBss_Bayan_318_Billed_Charges`
6. T-SQL `sp_Job_MyBSS_Bayan_EOC_Preload`

The T-SQL step calls the entry procedure through `etl_db.dbo.sp_ExecuteQueryAndLog` with:

- System: `MyBSS`
- Company/entity: `Bayan`
- Process: `Billed - Preload`
- Cycle: hard-coded per SQL Agent job, such as `EOC1`

The setup/cleanup job is:

`MyBSS_Bayan_EOC00_P01_Setup_Cleanup_12Mth`

It runs monthly at `08:30:00` based on the extracted metadata and calls `sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOC_CleanupBeforeProcess_12`.

The ad hoc extract job is:

`MyBSS_Bayan_EOC00_P02_Extract_AdHoc`

It has no schedule in `sql-agent-jobs.txt`. Its extracted steps are `sapglbilled`, `308_Billed_Adjustments`, `411_Bill_Control_PHP`, and `318_Billed_Charges`. It does not list a `411_Bill_Control_USD` step, unlike most scheduled preload jobs.

The SFTP jobs are separate ad hoc SQL Agent jobs named like:

`MyBSS_Bayan_EOC01_P15_Preload_SFTP_AdHoc`

The main preload stored procedure starts the relevant SFTP job asynchronously with `msdb.dbo.sp_start_job`.

Important observed detail:

- `EOC1` has no `411_Bill_Control_USD` step in the scheduled preload metadata. It runs `sapglbilled`, `308_Billed_Adjustments`, `411_Bill_Control_PHP`, `318_Billed_Charges`, then the stored procedure.
- `EOC10` appears to start at step 2 and has no `MyBss_Bayan_sapglbilled` step in `sql-agent-jobs.txt`.
- `etl_pipelines.txt` lists related postload labels inconsistently: `EOC01` is listed as `P20_Postload`, later cycles are listed as `P10_Postload`, and `EOC08` has the typo `Postoad`. `sql-agent-jobs.txt` consistently uses `P20_Postload` for the Bayan EOC postload jobs. This does not change the preload call chain, but it is a metadata consistency issue around related jobs.

## Cleanup Process

`sdbTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOC_CleanupBeforeProcess_12` is not called by `sp_Job_MyBSS_Bayan_EOC_Preload`, but SQL Agent metadata lists it as the EOC setup/cleanup step.

It truncates:

- `sdbTDIR2_Bayan.dbo.308_Billed_Adjustments_ssis`
- `sdbTDIR2_Bayan.dbo.411_Bill_Control_PHP_ssis`
- `sdbTDIR2_Bayan.dbo.411_Bill_Control_USD_ssis`
- `sdbTDIR2_Bayan.dbo.sap_glbilled_ssis`
- `sdbTDIR2_Bayan.dbo.318_Billed_Charges_ssis`
- `dswTDIR2_Bayan.dbo.stBayan_Billed_TDIR2_Bayan_sapglbilled`
- `dswTDIR2_Bayan.dbo.ttBayan_Billed`

This cleanup is global, not cycle-scoped.

## Cycle Mapping

`dbo.BillCycles` defines the runtime columns `BillCycle`, `CycleCode`, `Description`, `RunDay`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName`, but the repository only contains the table schema, not seed rows. `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName` are therefore data-driven live-table dependencies.

The following mapping is observed from `sql-agent-jobs.txt` and from the hard-coded export procedure table variable:

| CycleCode | BillCycle | Job label | Scheduled day | Export file |
| --- | --- | --- | ---: | --- |
| `EOC1` | `BC01` | `12Mth` | 12 | `txBayan_Billed_Cycle1_LoadFileSel.txt` |
| `EOC2` | `BC06` | `14Mth` | 14 | `txBayan_Billed_Cycle2_LoadFileSel.txt` |
| `EOC3` | `BC08` | `15Mth` | 15 | `txBayan_Billed_Cycle3_LoadFileSel.txt` |
| `EOC4` | `BC10` | `16Mth` | 16 | `txBayan_Billed_Cycle4_LoadFileSel.txt` |
| `EOC5` | `BC11` | `17Mth` | 17 | `txBayan_Billed_Cycle5_LoadFileSel.txt` |
| `EOC6` | `BC13` | `19Mth` | 19 | `txBayan_Billed_Cycle6_LoadFileSel.txt` |
| `EOC7` | `BC16` | `21Mth` | 21 | `txBayan_Billed_Cycle7_LoadFileSel.txt` |
| `EOC8` | `BC18` | `24Mth` | 24 | `txBayan_Billed_Cycle8_LoadFileSel.txt` |
| `EOC9` | `BC21` | `26Mth` | 26 | `txBayan_Billed_Cycle9_LoadFileSel.txt` |
| `EOC10` | `BC24` | `30Mth` | 30 | `txBayan_Billed_Cycle10_LoadFileSel.txt` |
| `EOC11` | `BC27` | `02Mth` | 2 | `txBayan_Billed_Cycle11_LoadFileSel.txt` |

The SFTP job name is built from `@CycleCode` by removing `EOC`, formatting the number as two digits, then creating:

`MyBSS_Bayan_EOC{NN}_P15_Preload_SFTP_AdHoc`

Example: `EOC1` becomes `MyBSS_Bayan_EOC01_P15_Preload_SFTP_AdHoc`.

## Main Procedure Call Chain

`sp_Job_MyBSS_Bayan_EOC_Preload @CycleCode`

1. `sp_MyBSS_Bayan_EOC_Preload_LoadSapTables`
2. `sp_MyBSS_Bayan_EOC_Preload_Transform @CycleCode`
3. `sp_MyBSS_Bayan_EOC_Preload_Export @CycleCode`
4. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare @CycleCode`
5. `sp_MyBSS_Bayan_EOC_Preload_Report_Export @CycleCode`
6. `sp_MyBSS_Bayan_EOC_Preload_Report_Send @CycleCode`
7. `msdb.dbo.sp_start_job @JobName = 'MyBSS_Bayan_EOC{NN}_P15_Preload_SFTP_AdHoc'`

Steps 1 through 6 are executed through `etl_db.dbo.sp_ExecuteQueryAndLog` with these logging dimensions:

- System: `MyBSS`
- Company/entity: `Bayan`
- Process: `Billed - Preload`
- Cycle: `@CycleCode`
- Procedure name and dynamic command text

Important observed detail:

The stored procedure contains a commented-out SFTP block that would call `sp_MyBSS_Bayan_EOC_Preload_SFTP` through `sp_ExecuteQueryAndLog`. The active implementation does not use that block; it builds a SQL Agent job name and starts the job directly.

## Step 1: Load SAP Lookup Tables

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_LoadSapTables`

This procedure has no cycle parameter. It refreshes SAP lookup/reference tables by calling:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_SUBTYPE`
4. `dgS4HANA_TDIR1.dbo.sp_ZFFI_0346`

Business purpose:

- `ZTF0001S` is used during transform to update the header row batch number from `BATCH_NO + 1` for `BUKRS = 'BAYN'`.
- `ZFFI_SUBTYPE` is used by the missing subscriber type preload report cache.
- `ZFFI_0346` is used by the missing charge code preload report cache.
- `ZTF0002S` is refreshed, but the reviewed active DP1 billed preload transform does not use it directly.

## Step 2: Transform

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Transform @CycleCode`

### Parameter Resolution

The procedure resolves:

`@BillCycle = BillCycles.BillCycle WHERE CycleCode = @CycleCode`

There is no explicit validation or error if `@CycleCode` is missing from `BillCycles`.

### Input and Staging

Main input table:

`sdbTDIR2_Bayan.dbo.sap_glbilled_ssis`

The table has generic `Column1` through `Column19`, plus `BillCycle`, `RowNumber`, `FileName`, `SequencialID`, and `DateProcessed`.

Destination staging table:

`dswTDIR2_Bayan.dbo.stBayan_Billed_TDIR2_Bayan_sapglbilled`

Primary key:

- `zrownumber`
- `Cycle_Code`

The transform first deletes existing staging rows for the current bill cycle:

`DELETE FROM stBayan_Billed_TDIR2_Bayan_sapglbilled WHERE Cycle_Code = @BillCycle`

Then it inserts rows from `sap_glbilled_ssis` where `BillCycle = @BillCycle`. Source `Column8` and `Column9` are cast through `DECIMAL(18,2)` and back to `NVARCHAR(50)` during this insert; the other source columns are copied as-is.

### Source Rule Updates

After loading staging rows, the transform runs generated update procedures:

| Target field | Rule |
| --- | --- |
| `zLegacyCycle_Code` | `Cycle_Code` from staging. |
| `zLegacyDSP_Order` | `zrownumber` from staging. |
| `zDSP_Order` | `zrownumber` from staging. |
| `zColumn01` through `zColumn19` | Source `Column1` through `Column19` when the target `zColumn` is null. |
| `zColumn05` for header rows | For rows where `Column1 = '00'`, set to `ZTF0001S.BATCH_NO + 1` joined by `Column2 = FROM_SYSTEM`, `Column3 = TO_SYSTEM`, `Column4 = EVENT`, and `BUKRS = 'BAYN'`. |
| `zDSP_UniqueKey` | For detail rows where `Column1 = '01'`, `LEFT('BBilled-' + zrownumber + '-' + Column2, 44)`; otherwise null. |

Important observed detail:

The generated source-rule procedures have no `@CycleCode` or `@BillCycle` parameter. They update rows through views that filter for null target fields, so the active current-cycle rows are updated after insertion, but any pre-existing staging rows with null derived fields could also be affected.

### Target Load

Target table:

`dswTDIR2_Bayan.dbo.ttBayan_Billed`

Primary key:

- `zLegacyDSP_Order`
- `zLegacyCycle_Code`
- `zSource`

The active transform deletes target rows for the current bill cycle and source:

`DELETE FROM ttBayan_Billed WHERE zSource = 'TDIR2_Bayan' AND zLegacyCycle_Code = @BillCycle`

It then inserts all staging rows for the current bill cycle into `ttBayan_Billed`. The staging and target tables define these defaults:

| Field | Default |
| --- | --- |
| `zActive` | `0` |
| `zSource` | `TDIR2_Bayan` in staging; inserted into target. |
| `zDuplicate` | `0` |
| `zLoaded` | `0` |

Historical reference:

Generated `srBayan_Billed_TDIR2_Bayan_sapglbilledDel` and `srBayan_Billed_TDIR2_Bayan_sapglbilledIns` procedures exist, but the active transform uses inline cycle-scoped delete and insert statements instead of those generated procedures. The generated delete view would delete all target rows where `zSource = 'TDIR2_Bayan'`, not one cycle.

### Loaded Status Update

The transform attempts to prevent double posting by updating `ttBayan_Billed.zLoaded` from SAP latest logs:

- Join target rows to `[dgS4HANA_TDIR1].dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` by `zDSP_Order = ZDSP_ORDER` and `zDSP_UniqueKey = ZDSP_UNIQUEKEY`.
- Set `zLoaded = 1` for detail rows where `Column01 = '01'`, the cycle is current, and the SAP message does not contain these error phrases:
  - `does not exist for`
  - `is not allowed for characteristic`
  - `requires an assignment to a CO object`
  - `Error in document`
  - `is not found in table`

Important observed detail:

The transform comments say this flag should prevent already-loaded records from being exported again. The export selector reviewed below does not filter on `zLoaded`, `zActive`, or `zDuplicate`; the active Bayan preload export still selects all rows for the bill cycle.

### Row and Column Semantics

The file layout is generic, but the code implies these meanings:

| Field | Meaning inferred from logic |
| --- | --- |
| `Column01` | Record type. `00` = header, `01` = detail, `99` = trailer/control. |
| `Column02` | Header/date/cycle-like field. It is used in the detail unique key and receives special date handling for `BC01`. |
| `Column05` | Subscriber type. Validated against `ZFFI_SUBTYPE`; header row `zColumn05` is overwritten with next batch number. |
| `Column06` | Charge code. Validated against `ZFFI_0346.ZCCODE`. |
| `Column08` | Amount used for trailer total and `sap_glbilled_ssis` reconciliation. |
| `Column09` | Amount-like field formatted in the SSRS preload dataset, but not used in the main trailer total. |
| `Column12` | Currency in `sap_glbilled_ssis`; used for PHP/USD reconciliation. |
| `zDSP_Order` | SAP header/order identifier, set to row number for detail rows in this process. |
| `zDSP_UniqueKey` | SAP unique key, generated for detail rows only. |

## Step 3: Export SAP Interface File

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Export @CycleCode`

Export path:

`F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Billed_New`

The export procedure builds a hard-coded table variable for `EOC1` through `EOC11`. Each row contains:

- `CycleCode`
- Dynamic SQL command for `sp_MyBSS_Bayan_EOC_Preload_Export_DP1_Billed_LoadFileSel`
- Export path
- Output file name

It selects the row matching `@CycleCode`, then calls:

`etl_db.dbo.sp_ExportTextFile @SqlQuery, @Path, @FileName`

### Export Selector

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Export_DP1_Billed_LoadFileSel @BillCycle`

The selector reads `ttBayan_Billed` for the requested bill cycle and stages `Column01` through `Column19`, `zDSP_Order`, and `zDSP_UniqueKey` into a temp table. It sets `zDSP_Order` to null for non-detail records:

`CASE WHEN Column01 <> '01' THEN NULL ELSE zDSP_Order END`

Output behavior:

- Detail and header rows are selected where `Column01 <> '99'`.
- A footer row where `Column01 = '99'` is unioned back with:
  - `Column02` = count of detail rows where `Column01 = '01'`
  - `Column03` = sum of `Column08` from the temp table
- For `BC01` only, if `Column02` contains `/`, the selector adds one day to `Column02` and formats it using style `101`.
- For `BC01`, output is ordered by `Column01`; for other cycles, output is ordered by `Column01, zDSP_Order`.

Important observed detail:

The selector has commented-out formatting for `Column08` and `Column09`. Current export returns the stored string values, except for the transform-time decimal normalization of `Column8` and `Column9`.

Important observed detail:

The selector does not filter `zLoaded`, `zActive`, or `zDuplicate`. Any suppression of already-loaded rows would need to happen before rows enter `ttBayan_Billed` or by changing this selector.

## Step 4: Report Prepare

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare @CycleCode`

This procedure resolves `@CycleCode` to `@BillCycle`, then executes these cache builders:

1. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing`
2. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing`
3. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Preload @BillCycle`
4. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP`
5. `sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD`

### Missing Charge Code Cache

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing`

The procedure truncates:

`rpt_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing_Cache`

Then it inserts distinct missing charge codes:

- Source: `ttBayan_Billed`
- Detail filter: `Column01 = '01'`
- Charge code column: `Column06`
- Lookup: `dbo.ZFFI_0346`
- Join: `LTRIM(RTRIM(ZCCODE)) = LTRIM(RTRIM(Column06)) AND MANDT = '300'`
- Missing condition: `ZCCODE IS NULL`

Important observed detail:

This cache is truncated and rebuilt globally. It is not filtered to the current `@BillCycle`.

Important observed detail:

This missing-charge-code check does not filter `ZFFI_0346` by `BUKRS = 'BAYN'`. If a charge code exists for another company code but not for Bayan, this check may not flag it.

### Missing Subscriber Type Cache

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing`

The procedure truncates:

`rpt_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing_Cache`

Then it inserts distinct missing subscriber types:

- Source: `ttBayan_Billed`
- Detail filter: `Column01 = '01'`
- Subscriber type column: `Column05`
- Lookup: `dbo.ZFFI_SUBTYPE`
- Join: `Column05 = ZSUBTYPE AND ZBUKRS = 'BAYN' AND MANDT = '300'`
- Missing condition: `ZSUBTYPE IS NULL`

Important observed detail:

This cache is also truncated and rebuilt globally. It is not filtered to the current `@BillCycle`.

### Preload Report Cache

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_Preload @BillCycle`

The procedure deletes only current-cycle rows from:

`rpt_Preload_Report_Prepare_DP1_Billed_Preload_Cache`

Then it inserts rows from `ttBayan_Billed` where `zLegacyCycle_Code = @BillCycle`.

It writes:

- `Column01` through `Column19`
- `zDSP_Order`, but only when `Column01 = '01'`; otherwise null
- `zDSP_UniqueKey`
- `BillCycle`

The related SSRS dataset procedure `sp_rpt_tvBayan_DP1_Billed_Preload_SSRS @CycleCode` reads this cache for the bill cycle, formats `Column08` and `Column09`, and orders by `Column01` and numeric `zDSP_Order`.

### PHP Recon Summary Cache

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP`

This procedure truncates and rebuilds:

`rpt_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP_Cache`

Inputs:

- `sdbTDIR2_Bayan.dbo.sap_glbilled_ssis`
- `sdbTDIR2_Bayan.dbo.411_Bill_Control_PHP_ssis`
- `sdbTDIR2_Bayan.dbo.318_Billed_Charges_ssis`
- `sdbTDIR2_Bayan.dbo.308_Billed_Adjustments_ssis`

Summary rules:

- Header dates come from distinct `sap_glbilled_ssis.Column2` values for each bill cycle where `Column2 LIKE '%/%'`.
- Bill-control rows are pivoted by cycle using `Column1` as description and rounded `Column3` as amount.
- The hard-coded report layout contains 22 descriptions from `Total Previous Balance` through `Total Amount Due`.
- `318_Billed_Charges_ssis` rows are split into cycle header rows (`Column1 LIKE '%Cycle%'`) and item rows (`LEN(Column1) = 1`), then summarized where `Currency = 'PHP'`.
- `308_Billed_Adjustments_ssis` rows are split the same way and summarized where `Currency = 'PHP'`.
- `sap_glbilled_ssis` is summarized from `Column8` where `Column12 = 'PHP'`.
- `Current Charges` sums these bill-control descriptions:
  - `Total Rental`
  - `Total Promotion/Discount`
  - `Total Traffic Processed`
  - `Total VAS Charge`
  - `Total Onetime Charges`
  - `Total Overseas Communication Tax`
  - `Total Overseas Tax (ECONOCALL)`
  - `Total Surcharge`
  - `Total VAT`
- `Current Adjustments` sums `Total Adjustments` and `Total Adjustment VAT`.
- `Total Billed` sums current charges plus current adjustments.
- Difference rows compare:
  - billed charges plus billed adjustments versus `sapglbilled`
  - current charges versus billed charges report
  - current adjustments versus billed adjustment report
  - total billed versus `sapglbilled`
- Zero difference values are displayed as `-`.

Important observed detail:

This cache is global across all EOC bill cycles. Running one cycle rebuilds the PHP recon summary for all cycles using whatever staged data is currently present.

Important observed detail:

The PHP recon procedure contains a copy-paste alias named `A_Innove_EOC_Clubbed_Data_Calculation` in the final difference calculation block. The active table references are still Bayan objects.

### USD Recon Summary Cache

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD`

This procedure truncates and rebuilds:

`rpt_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD_Cache`

The USD logic mirrors the PHP recon summary, with these differences:

- It reads `sdbTDIR2_Bayan.dbo.411_Bill_Control_USD_ssis`.
- It builds and left joins the same 22-description report layout.
- It filters billed charges, billed adjustments, and `sap_glbilled_ssis` to `Currency = 'USD'` / `Column12 = 'USD'`.

Important observed detail:

This cache is also global across all EOC bill cycles. The current `EOC1` scheduled preload metadata and `EOC00_P02_Extract_AdHoc` metadata do not show a `411_Bill_Control_USD` extract step, so USD recon completeness should be verified against live job definitions and staging data.

### Report Dataset Procedures

The SSRS dataset procedures read the report caches:

| Dataset procedure | Runtime behavior |
| --- | --- |
| `sp_rpt_tvBayan_DP1_Billed_Preload_SSRS @CycleCode` | Resolves `@CycleCode` to `BillCycle`, reads preload cache for that bill cycle, formats `Column08` and `Column09`, and orders by `Column01`, numeric `zDSP_Order`. |
| `sp_rpt_tvBayan_DP1_Billed_Preload_ChargeCodeMissing_SSRS` | Reads all rows from the missing charge code cache and orders by charge code. |
| `sp_rpt_tvBayan_DP1_Billed_Preload_Subscriber_TypeMissing_SSRS` | Reads all rows from the missing subscriber type cache and orders by subscriber type. |
| `sp_MyBSS_Bayan_EOC_Recon_Summary_PHP_SSRS` | Recomputes the PHP recon summary directly from staging tables rather than reading the prepared cache. |
| `sp_MyBSS_Bayan_EOC_Recon_Summary_USD_SSRS` | Recomputes the USD recon summary directly from staging tables rather than reading the prepared cache. |

Important observed detail:

The report-send procedure counts rows from the prepared recon cache tables, but the reviewed recon SSRS dataset procedures recompute from source staging tables directly. If staging changes between report prepare, SSRS export, and report send, counts and report contents can diverge.

## Step 5: Report Export

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Export @CycleCode`

The procedure resolves:

`@Keyword_SSRS = BillCycles.Keyword_SSRS WHERE CycleCode = @CycleCode`

It then builds these expected SSRS subscription descriptions:

| Report | Subscription description pattern |
| --- | --- |
| Missing charge code | `Bayn_Billed_Preload_DP1{Keyword_SSRS}_ChargeCodeMissing` |
| Missing subscriber type | `Bayn_Billed_Preload_DP1{Keyword_SSRS}_SubsTypeMissing` |
| Preload detail | `Bayn_Billed_Preload_DP1{Keyword_SSRS}` |
| PHP recon summary | `Bayn_Billed_Recon_Summary_PHP_DP1{Keyword_SSRS}` |
| USD recon summary | `Bayn_Billed_Recon_Summary_USD_DP1{Keyword_SSRS}` |

For each matching subscription in `ReportServer$DACPRD.dbo.Subscriptions`, it:

1. Deletes the prior Excel file with `xp_cmdshell`.
2. Triggers the SSRS subscription with `ReportServer$DACPRD.dbo.AddEvent`.
3. Polls `ReportServer$DACPRD.dbo.Event` for the subscription id every 3 seconds.
4. Stops polling after 25 iterations and prints a break message.

Report output path:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Billed_SSRS\{SubscriptionName}.xlsx`

Important observed detail:

The procedure does not raise an error if the SSRS event remains queued after 25 checks. It prints `Breaking - reached maximum iteration.` and moves on.

## Step 6: Report Send

Procedure:

`dbo.sp_MyBSS_Bayan_EOC_Preload_Report_Send @CycleCode`

The procedure resolves both `@Keyword_SSRS` and `@BillCycle` from `BillCycles`, then builds report subscription names. It calculates record counts from the report caches and sends email only for rows where `recordcount > 0`.

| Report | Record-count rule |
| --- | --- |
| Preload detail | Count rows in `rpt_Preload_Report_Prepare_DP1_Billed_Preload_Cache` where `BillCycle = @BillCycle` and `Column01 = '01'`. |
| Missing charge code | Count all rows in `rpt_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing_Cache`. |
| Missing subscriber type | Count all rows in `rpt_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing_Cache`. |
| PHP recon summary | Count all rows in `rpt_Preload_Report_Prepare_DP1_Billed_ReconSummaryPHP_Cache`. |
| USD recon summary | Present in source but commented out; no USD recon email is sent by the active procedure. |

Email details:

| Field | Value |
| --- | --- |
| Database Mail profile | `SSRS` |
| To | `princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph` |
| CC | `wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph` |
| Subject | `Report Notif: MyBSS {SubscriptionName} - {RecordCount} Record(s) Generated` |
| Body format | HTML |
| Attachment | Report file under `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Billed_SSRS\` |
| Report server link | `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx` |

Important observed detail:

The send procedure waits 5 seconds before sending each email, although the inline comment says "3 seconds". It also counts the missing-code and recon caches globally, not only for the requested cycle.

## Step 7: SFTP

Active entry-procedure behavior:

`sp_Job_MyBSS_Bayan_EOC_Preload` builds a cycle-specific SQL Agent job name and starts it:

`MyBSS_Bayan_EOC{NN}_P15_Preload_SFTP_AdHoc`

The ad hoc job step calls:

`dbo.sp_MyBSS_Bayan_EOC_Preload_SFTP @CycleCode`

SFTP procedure behavior:

1. Sets `@FileDelKey = 'txBayan_Billed_Cycle_Del'`.
2. Calls `etl_db.dbo.sp_sftp_sap_del @FileDelKey`.
3. Reads `ExportFileKey` from `BillCycles` for the requested `CycleCode`.
4. Calls `etl_db.dbo.sp_sftp_sap_push @FileKey` for each matching row.

Important observed detail:

The SFTP delete key is not cycle-specific. It may delete prior outbound files before pushing the current file, depending on how `sp_sftp_sap_del` is configured.

Important observed detail:

The export procedure uses a hard-coded cycle-to-file-name table variable, while SFTP uses the live `BillCycles.ExportFileKey`. These two sources must stay aligned operationally.

## Business Logic Summary

- `@CycleCode` is the runtime parameter throughout the entry procedure; transform/report procedures resolve it to a bill cycle through `BillCycles`.
- SQL Agent scheduled preload jobs load SSIS extracts before calling the SQL entry procedure. Most cycles include `sapglbilled`, `308_Billed_Adjustments`, `411_Bill_Control_USD`, `411_Bill_Control_PHP`, and `318_Billed_Charges`.
- Cleanup is a separate SQL Agent setup job and truncates all Bayan EOC staging and DP1 billed target rows.
- Transform is cycle-scoped for staging delete, staging load, target delete, target insert, and SAP latest-log status update.
- The staging load copies source `Column1` through `Column19`, with numeric normalization for `Column8` and `Column9`.
- Generated source-rule procedures copy source columns into `zColumn` fields only when the target `zColumn` is null.
- Header `zColumn05` is synchronized from `ZTF0001S.BATCH_NO + 1` for `BUKRS = 'BAYN'`.
- `zDSP_Order` and `zLegacyDSP_Order` are both derived from source row number.
- Detail `zDSP_UniqueKey` is built as `BBilled-{zrownumber}-{Column2}` and truncated to 44 characters.
- `zLoaded` is set from SAP latest-log messages, but current export output is not filtered by `zLoaded`.
- SAP text export is one file per requested cycle under `F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Billed_New`.
- The export selector rebuilds the footer count and amount fields before writing the file.
- `BC01` has a special plus-one-day adjustment for date-like `Column02` values during load-file export.
- Missing charge code and missing subscriber type report caches are global, not cycle-scoped.
- The preload detail report cache is cycle-scoped.
- PHP and USD recon summary caches are global across all 11 bill cycles.
- SSRS subscriptions are selected by `BillCycles.Keyword_SSRS` and `ReportServer$DACPRD.dbo.Subscriptions.Description`.
- Email sends are gated by cache record counts.
- USD recon is prepared and exported, but the USD recon email is commented out in the active report-send procedure.
- SFTP is asynchronous from the main preload procedure because it starts a SQL Agent job and does not wait for completion.

## Operational Risks and Gaps

- The active export selector does not filter `zLoaded`. This conflicts with the transform comment that loaded SAP rows are flagged to avoid double posting.
- `BillCycles` seed data is not scripted in the repository. `@BillCycle`, `Keyword_SSRS`, `ExportFileKey`, and SFTP behavior depend on live table data.
- The export mapping is duplicated: export file names and bill-cycle mapping are hard-coded in `sp_MyBSS_Bayan_EOC_Preload_Export`, while SFTP uses `BillCycles.ExportFileKey`.
- The cleanup procedure globally truncates source staging, work staging, and target tables. It is not cycle-scoped.
- Missing charge code and missing subscriber type caches are globally truncated and rebuilt without a bill-cycle filter.
- PHP and USD recon summary caches are globally truncated and rebuilt for all cycles. A run with only one cycle loaded may produce incomplete cross-cycle summaries.
- Report send counts missing-code and recon caches globally, so emails can be triggered by rows outside the requested cycle.
- The recon SSRS dataset procedures recompute from staging tables instead of reading the prepared recon caches, so report contents can diverge from the counts used by `Report_Send`.
- Report export uses `xp_cmdshell` to delete prior Excel output. This requires SQL Server file-system permissions and exposes operational risk if the subscription name/path is wrong.
- Report export waits up to 25 polling iterations but does not fail the job if the SSRS event remains queued.
- Report send waits a fixed 5 seconds before attaching files. It does not verify that the expected `.xlsx` exists before calling `sp_send_dbmail`.
- The entry procedure starts the SFTP SQL Agent job asynchronously and does not verify SFTP job success.
- `EOC1` scheduled preload metadata and the `EOC00_P02_Extract_AdHoc` metadata do not show the USD bill-control extract step, while USD recon still runs.
- `EOC10` scheduled preload metadata does not show the `sapglbilled` extract step and starts at step 2.
- Hard-coded file paths, recipients, report server link, and process labels are embedded in stored procedures.
- Invalid or missing `@CycleCode` handling is weak. Some steps would silently affect no rows; the SFTP job-name formatting can also fail if the value is not in the expected `EOC{number}` format.
- `etl_pipelines.txt` has related postload metadata inconsistencies (`P10` versus `P20`, plus `Postoad`) compared with `sql-agent-jobs.txt`.

## Validation Checklist

Before running or changing the process:

- Confirm `dbo.BillCycles` has rows for `EOC1` through `EOC11` with correct `BillCycle`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName` values.
- Confirm the requested SQL Agent preload job has completed all expected SSIS extract steps before `sp_Job_MyBSS_Bayan_EOC_Preload` runs.
- Confirm `sdbTDIR2_Bayan.dbo.sap_glbilled_ssis` has rows for the requested `BillCycle`.
- Confirm `411_Bill_Control_PHP_ssis`, `411_Bill_Control_USD_ssis`, `318_Billed_Charges_ssis`, and `308_Billed_Adjustments_ssis` have the expected cycle data before recon reports are generated.
- Verify whether the current `EOC1`, `EOC10`, and ad hoc extract job metadata differences match live SQL Agent behavior.
- Confirm SAP refresh procedures for `ZTF0001S`, `ZFFI_SUBTYPE`, and `ZFFI_0346` are succeeding and wrapper views show `MANDT = '300'` data.
- Verify the header row batch number after transform, especially `zColumn05` for `Column01 = '00'`.
- Verify `ttBayan_Billed` row counts by `zLegacyCycle_Code` after transform and before export.
- Decide whether the current no-`zLoaded` export behavior is intended before relying on SAP latest-log suppression.
- Validate the export selector output count and footer amount against `ttBayan_Billed` for the requested cycle.
- Confirm the export path exists and SQL Server can write `txBayan_Billed_Cycle{N}_LoadFileSel.txt`.
- Confirm SSRS subscription descriptions match the `Bayn_...{Keyword_SSRS}` patterns.
- Confirm report output files are generated under `F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Billed_SSRS`.
- Confirm missing charge code and missing subscriber type caches are acceptable as global caches, not cycle-only caches.
- Confirm PHP and USD recon summary reports are expected to summarize all EOC cycles from current staging data.
- Check whether recon SSRS procedures should read prepared cache tables or recompute directly from staging tables.
- Confirm Database Mail profile `SSRS` can send to the configured recipients and attach the generated `.xlsx` files.
- Confirm the cycle-specific SFTP ad hoc SQL Agent job is enabled and that `BillCycles.ExportFileKey` points to the file just exported.
- Review `sql-agent-jobs.txt` rather than `etl_pipelines.txt` if there is a question about live job step names or schedules.

## High-Level Data Flow

```text
SQL Agent preload job
  -> SSIS MyBss_Bayan_sapglbilled
       -> sdbTDIR2_Bayan.dbo.sap_glbilled_ssis
  -> SSIS MyBss_Bayan_308_Billed_Adjustments
       -> sdbTDIR2_Bayan.dbo.308_Billed_Adjustments_ssis
  -> SSIS MyBss_Bayan_411_Bill_Control_PHP
       -> sdbTDIR2_Bayan.dbo.411_Bill_Control_PHP_ssis
  -> SSIS MyBss_Bayan_411_Bill_Control_USD
       -> sdbTDIR2_Bayan.dbo.411_Bill_Control_USD_ssis
  -> SSIS MyBss_Bayan_318_Billed_Charges
       -> sdbTDIR2_Bayan.dbo.318_Billed_Charges_ssis
  -> etl_db.dbo.sp_ExecuteQueryAndLog
       -> dswTDIR2_Bayan.dbo.sp_Job_MyBSS_Bayan_EOC_Preload @CycleCode
            -> Refresh SAP lookup tables in dgS4HANA_TDIR1
            -> Transform selected BillCycle
                 -> dswTDIR2_Bayan.dbo.stBayan_Billed_TDIR2_Bayan_sapglbilled
                 -> dswTDIR2_Bayan.dbo.ttBayan_Billed
                 -> SAP latest-log zLoaded update
            -> Export SAP load file
                 -> etl_db.dbo.sp_ExportTextFile
                 -> F:\BOA\Transform\Export\TDIR2-MyBSS\Bayan\ttBayan_Billed_New
            -> Prepare report caches
                 -> preload detail cache
                 -> charge code missing cache
                 -> subscriber type missing cache
                 -> PHP recon summary cache
                 -> USD recon summary cache
            -> Trigger SSRS subscriptions
                 -> ReportServer$DACPRD.dbo.AddEvent
                 -> F:\BOA\Transform\Report\TDIR2-MyBSS\Bayan\ttBayan_Billed_SSRS
            -> Send nonempty report emails
                 -> msdb.dbo.sp_send_dbmail
            -> Start cycle SFTP job
                 -> msdb.dbo.sp_start_job
                 -> dswTDIR2_Bayan.dbo.sp_MyBSS_Bayan_EOC_Preload_SFTP @CycleCode
                 -> etl_db.dbo.sp_sftp_sap_del / sp_sftp_sap_push
```
