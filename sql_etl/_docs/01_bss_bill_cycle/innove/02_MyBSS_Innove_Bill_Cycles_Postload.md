# sp_Job_MyBSS_Innove_EOC_Postload Reverse Engineering

Reverse engineered on 2026-05-08 from the SQL scripts in this repository.

## Scope

This document covers the stored procedure:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_Postload`

Execution starts on `sp_Job_MyBSS_Innove_EOC_Postload`. The document also covers the child procedures it calls through `etl_db.dbo.sp_ExecuteQueryAndLog`, the SAP latest-log refresh, loaded-status update rules, SQL Agent context, EOC cleanup context, report cache generation, SSRS subscription triggers, and email notification flow.

## Executive Summary

`sp_Job_MyBSS_Innove_EOC_Postload` is the SQL orchestration layer for the MyBSS Innove EOC DP1 Billed Postload process. It runs after the matching preload process has built `ttInnove_Billed`, exported the SAP load file, and SAP has attempted to post that file. The postload job itself has no SSIS extract step, no SAP load-file export, and no SFTP step.

At a high level, the procedure:

1. Refreshes SAP reference/log tables from `dgS4HANA_TDIR1`.
2. Marks matched successful `ttInnove_Billed` detail rows as loaded from SAP latest-log messages.
3. Resets all rows for any bill cycle with a recognized SAP error back to unloaded.
4. Resolves `@CycleCode` to a bill cycle such as `BC01`.
5. Rebuilds Innove DP1 billed postload valid and error cache tables for that bill cycle.
6. Triggers SSRS subscriptions for valid and error Excel reports.
7. Sends report emails for subscriptions whose cache has nonzero detail rows.

## Source Files Reviewed

Main orchestration and metadata:

- `dswTDIR2_Innove/programmability/stored_procedures/dbo.sp_Job_MyBSS_Innove_EOC_Postload.StoredProcedure.sql`
- `sql-agent-jobs.txt`
- `etl_pipelines.txt`

Main subprocesses:

- `dbo.sp_MyBSS_Innove_EOC_Postload_LoadSapTables.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Transform.StoredProcedure.sql`
- `dbo.trInnove_Billed_zloaded_Upd.StoredProcedure.sql`
- `dbo.trInnove_Billed_zLoaded_0_CycleCodeUpd.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Report_Prepare.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Error.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Valid.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Report_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Postload_Report_Send.StoredProcedure.sql`

Loaded-status views and SAP log objects:

- `dswTDIR2_Innove/views/dbo.trInnove_Billed_zloaded_UpdSel.View.sql`
- `dswTDIR2_Innove/views/dbo.Innove_Billed_zLoaded_0_CycleCode.View.sql`
- `dswTDIR2_Innove/views/dbo.trInnove_Billed_zLoaded_0_CycleCodeUpdSel.View.sql`
- `dswTDIR2_Innove/views/dbo.ZFFI_REPORT_ODBC.View.sql`
- `dswTDIR2_Innove/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`
- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZTF0002S.StoredProcedure.sql`
- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZTF0001S.StoredProcedure.sql`
- `dgS4HANA_TDIR1/programmability/stored_procedures/dbo.sp_ZFFI_REPORT_ODBC_Delta.StoredProcedure.sql`
- `dgS4HANA_TDIR1/views/dbo.ZFFI_REPORT_ODBC_LATESTLOGS.View.sql`

Important tables and report dataset procedures:

- `dswTDIR2_Innove/tables/dbo.BillCycles.Table.sql`
- `dswTDIR2_Innove/tables/dbo.ttInnove_Billed.Table.sql`
- `dswTDIR2_Innove/tables/dbo.rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache.Table.sql`
- `dswTDIR2_Innove/tables/dbo.rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache.Table.sql`
- `dbo.sp_rpt_tvInnove_DP1_Billed_Postload_Error_SSRS.StoredProcedure.sql`
- `dbo.sp_rpt_tvInnove_DP1_Billed_Postload_Valid_SSRS.StoredProcedure.sql`
- `dbo.tvInnove_Billed_Cycle*_Postload_ErrorRptSel.View.sql`
- `dbo.tvInnove_Billed_Cycle*_Postload_ValidRptSel.View.sql`

Related preload, cleanup, and SFTP context:

- `sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_CleanupBeforeProcess_12.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Preload_Export.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Preload_Export_DP1_Billed_LoadFileSel.StoredProcedure.sql`
- `dbo.sp_MyBSS_Innove_EOC_Preload_SFTP.StoredProcedure.sql`
- `Linked Servers/SAP_S4.sql`

Historical reference:

- `dbo.sp_MyBSS_Innove_EOC_Postload_LoadOdbc_bak.StoredProcedure.sql`

## Databases and External Dependencies

| Database or service | Purpose |
| --- | --- |
| `sdbTDIR2_Innove` | SSIS landing/staging tables and the EOC cleanup procedure used before preload. |
| `dswTDIR2_Innove` | Postload orchestration, DP1 billed target rows, status update views/procedures, report cache tables, local SAP wrapper views, and SSRS dataset procedures. |
| `dgS4HANA_TDIR1` | SAP reference tables and ODBC/latest-load log data. |
| `SAP_S4` linked server | SAP S/4HANA ODBC linked server used by SAP refresh procedures through `OPENQUERY`. |
| `etl_db` | Execution logging through `sp_ExecuteQueryAndLog`; SAP SFTP helpers in related preload flow; historical SQL Agent helper metadata in the backup ODBC loader. |
| `ReportServer$DACPRD` | SSRS subscription lookup and timed-subscription event queue. |
| `msdb` | Database Mail through `sp_send_dbmail`; historical SQL Agent starts in the backup ODBC loader. |
| Windows file system | SSRS Excel output path on `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS`. |

Important helper procedures outside the Innove database:

- `etl_db.dbo.sp_ExecuteQueryAndLog`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
- `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
- `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`
- `ReportServer$DACPRD.dbo.AddEvent`
- `msdb.dbo.sp_send_dbmail`
- `xp_cmdshell`

`sp_ZFFI_REPORT_ODBC_Delta` reads recent SAP `SAPPRD.ZFFI_REPORT_ODBC` rows through `OPENQUERY([SAP_S4], ...)`, keeps the latest row per `ZDSP_UNIQUEKEY`, `Z_PROG_NAME`, and `Z_LINE_ITEM`, deletes matching local rows by unique key/order/program, and inserts the refreshed rows into `dgS4HANA_TDIR1.dbo.ZFFI_REPORT_ODBC`.

## SQL Agent Context

The scheduled SQL Agent postload jobs are named like:

`MyBSS_Innove_EOC01_P20_Postload_12Mth`

Based on `sql-agent-jobs.txt`, each scheduled Innove EOC postload job has one T-SQL step that invokes:

`dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_Postload @CycleCode`

through:

`etl_db.dbo.sp_ExecuteQueryAndLog`

The SQL Agent step uses these logging dimensions:

- System: `MyBSS`
- Company/entity: `Innove`
- Process: `Billed - Postload`
- Cycle: hard-coded per SQL Agent job, such as `EOC1`
- Procedure name and dynamic command text

The extracted SQL Agent metadata shows the postload jobs running monthly at `13:45:00`.

The setup/cleanup job is:

`MyBSS_Innove_EOC00_P01_Setup_Cleanup_12Mth`

It runs monthly at `08:30:00` based on `sql-agent-jobs.txt` and calls `sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_CleanupBeforeProcess_12`.

The related scheduled preload jobs run at `11:15:00` and execute SSIS extracts before calling `sp_Job_MyBSS_Innove_EOC_Preload`. The related preload SFTP jobs are ad hoc SQL Agent jobs named like:

`MyBSS_Innove_EOC01_P15_Preload_SFTP_AdHoc`

Important observed detail:

`etl_pipelines.txt` lists Innove as `dswTDIR2_Innnove` in the database list, with an extra `n`. It also lists most postload labels as `P10_Postload` and has the typo `Postoad` for EOC08. `sql-agent-jobs.txt` consistently uses `P20_Postload` for all Innove EOC postload jobs, so the SQL Agent extract should be treated as the operational source of truth.

## Cleanup Process

`sdbTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_CleanupBeforeProcess_12` is not called by `sp_Job_MyBSS_Innove_EOC_Postload`, but SQL Agent metadata lists it as the EOC setup/cleanup job that runs before the preload/postload cycle.

It truncates:

- `sdbTDIR2_Innove.dbo.308_Billed_Adjustments_ssis`
- `sdbTDIR2_Innove.dbo.318_Billed_Charges_ssis`
- `sdbTDIR2_Innove.dbo.411_Bill_Control_PHP_ssis`
- `sdbTDIR2_Innove.dbo.411_Bill_Control_USD_ssis`
- `sdbTDIR2_Innove.dbo.sap_glbilled_ssis`
- `dswTDIR2_Innove.dbo.stInnove_Billed_TDIR2_Innove_sapglbilled`
- `dswTDIR2_Innove.dbo.ttInnove_Billed`

This cleanup is global, not cycle-scoped. Running it between preload and postload would remove the `ttInnove_Billed` rows that postload needs.

## Cycle Mapping

`dbo.BillCycles` defines the runtime columns `BillCycle`, `CycleCode`, `Description`, `RunDay`, `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName`, but the repository only contains the table schema, not seed rows. `Keyword_SSRS`, `ExportFileKey`, and `ExportFileName` are therefore live-table dependencies.

The following mapping is observed from `sql-agent-jobs.txt`, the related preload export procedure, and the cycle-specific postload views:

| CycleCode | BillCycle | Job label | Scheduled day | Preload export file | Postload subscription pattern |
| --- | --- | --- | ---: | --- | --- |
| `EOC1` | `BC01` | `12Mth` | 12 | `txInnove_Billed_Cycle1_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC2` | `BC06` | `14Mth` | 14 | `txInnove_Billed_Cycle2_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC3` | `BC08` | `15Mth` | 15 | `txInnove_Billed_Cycle3_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC4` | `BC10` | `16Mth` | 16 | `txInnove_Billed_Cycle4_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC5` | `BC11` | `17Mth` | 17 | `txInnove_Billed_Cycle5_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC6` | `BC13` | `19Mth` | 19 | `txInnove_Billed_Cycle6_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC7` | `BC16` | `21Mth` | 21 | `txInnove_Billed_Cycle7_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC8` | `BC18` | `24Mth` | 24 | `txInnove_Billed_Cycle8_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC9` | `BC21` | `26Mth` | 26 | `txInnove_Billed_Cycle9_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC10` | `BC24` | `30Mth` | 30 | `txInnove_Billed_Cycle10_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |
| `EOC11` | `BC27` | `02Mth` | 2 | `txInnove_Billed_Cycle11_LoadFileSel.txt` | `Inov_Billed_Postload_DP1{Keyword_SSRS}_{Valid/Error}` |

The active postload procedure does not construct or start an SFTP job. The related preload SFTP jobs are ad hoc jobs named:

`MyBSS_Innove_EOC{NN}_P15_Preload_SFTP_AdHoc`

`sp_MyBSS_Innove_EOC_Preload_SFTP` deletes prior SAP-side files through `etl_db.dbo.sp_sftp_sap_del` with `txInnove_Billed_Cycle_Del`, then pushes the cycle's `BillCycles.ExportFileKey` through `etl_db.dbo.sp_sftp_sap_push`.

## Main Procedure Call Chain

`sp_Job_MyBSS_Innove_EOC_Postload @CycleCode`

1. `sp_MyBSS_Innove_EOC_Postload_LoadSapTables`
2. `sp_MyBSS_Innove_EOC_Postload_Transform`
3. `sp_MyBSS_Innove_EOC_Postload_Report_Prepare @CycleCode`
4. `sp_MyBSS_Innove_EOC_Postload_Report_Export @CycleCode`
5. `sp_MyBSS_Innove_EOC_Postload_Report_Send @CycleCode`

Every active child stored procedure is executed through `etl_db.dbo.sp_ExecuteQueryAndLog` with:

- System: `MyBSS`
- Company/entity: `Innove`
- Process: `Billed - Postload`
- Cycle: `@CycleCode`
- Procedure name and dynamic command text

Historical reference:

`sp_MyBSS_Innove_EOC_Postload_LoadOdbc_bak` starts SQL Agent jobs named `SapS4Hana_ZFFI_REPORT_ODBC` and `SapS4Hana_ZTF0001S`, then polls `etl_db.dbo.fn_IsJobCompleted` every 3 seconds up to 100 iterations. This backup procedure is not in the active postload call chain; the active path refreshes ODBC/latest-log data through `sp_MyBSS_Innove_EOC_Postload_LoadSapTables`.

## Step 1: Load SAP Tables and Logs

Procedure:

`dbo.sp_MyBSS_Innove_EOC_Postload_LoadSapTables`

This step has no cycle parameter. It refreshes SAP reference/log tables by calling:

1. `dgS4HANA_TDIR1.dbo.sp_ZTF0002S`
2. `dgS4HANA_TDIR1.dbo.sp_ZTF0001S`
3. `dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta`

Business purpose:

- `ZFFI_REPORT_ODBC`/latest logs provide SAP posting feedback used by the postload transform and reports.
- `ZTF0001S` and `ZTF0002S` are refreshed for consistency with the broader billed process, though the active postload status update and report caches primarily depend on latest ODBC logs.
- `sp_ZFFI_REPORT_ODBC_Delta` only pulls recent SAP rows using a `Z_DATE >= ADD_DAYS(CURRENT_DATE, -1)` filter in its `OPENQUERY`.

Local wrapper views:

- `dbo.ZFFI_REPORT_ODBC`
- `dbo.ZFFI_REPORT_ODBC_LATESTLOGS`

Both read from `dgS4HANA_TDIR1` and filter `MANDT = '300'`.

## Step 2: Transform / Loaded Status Update

Procedure:

`dbo.sp_MyBSS_Innove_EOC_Postload_Transform`

This procedure does not accept `@CycleCode`. The active implementation runs:

1. `dbo.trInnove_Billed_zloaded_Upd`
2. `dbo.trInnove_Billed_zLoaded_0_CycleCodeUpd`

The source-rule block that would rerun generated source rules and reload `ttInnove_Billed` is commented out. Active postload consumes target rows already built by preload.

### Mark Successful Detail Rows Loaded

Procedure:

`dbo.trInnove_Billed_zloaded_Upd`

This updates through:

`dbo.trInnove_Billed_zloaded_UpdSel`

The update sets:

`ttInnove_Billed.zLoaded = '1'`

for detail rows where:

- A latest SAP log matches on `zDSP_Order = ZDSP_ORDER`.
- A latest SAP log matches on `zDSP_UniqueKey = ZDSP_UNIQUEKEY`.
- `Column01 = '01'`.
- `Z_MESSAGE` does not match any of these error patterns:
  - `%does not exist for%`
  - `%is not allowed for characteristic%`
  - `%requires an assignment to a CO object%`
  - `%Error in document%`
  - `%is not found in table%`

Important observed detail:

The success update uses `dbo.ZFFI_REPORT_ODBC_LatestLogs` and does not filter `Z_SOURCE_NAME = 'txInnove'`.

### Reset Cycles With SAP Errors

Procedure:

`dbo.trInnove_Billed_zLoaded_0_CycleCodeUpd`

This updates through:

`dbo.trInnove_Billed_zLoaded_0_CycleCodeUpdSel`

The update sets:

`ttInnove_Billed.zLoaded = '0'`

for every row whose `zLegacyCycle_Code` appears in:

`dbo.Innove_Billed_zLoaded_0_CycleCode`

The cycle-level error view joins `ttInnove_Billed` to `ZFFI_REPORT_ODBC_LATESTLOGS` on:

- `ttInnove_Billed.ZDSP_ORDER = ODBC.ZDSP_ORDER`
- `ttInnove_Billed.ZDSP_UNIQUEKEY = ODBC.ZDSP_UNIQUEKEY`

It groups by `zLegacyCycle_Code`, counts SAP messages, and keeps cycles with at least one detail row where `Column01 = '01'` and `Z_MESSAGE` matches one of these error patterns:

- `%does not exist for%`
- `%is not allowed for characteristic%`
- `%requires an assignment to a CO object%`
- `%Error in document%`
- `%is not found in table%`

Important observed details:

- The reset runs after the success update. If one detail row in a bill cycle has a recognized SAP error, all rows in `ttInnove_Billed` for that bill cycle are reset to `zLoaded = 0`.
- The active reset sets `zLoaded`, not `zLegacyCycle_Code`. A commented historical block in the transform shows an older inline approach that would have set `zLegacyCycle_Code = '0'`; that block is not active.
- Neither update writes `zLoad_Message`; later report cache logic reads `Z_MESSAGE` from SAP latest logs.
- Success classification is a negative text filter. New SAP error messages that do not match the fixed list can first be marked loaded, unless another recognized error resets the whole cycle afterward.

## Step 3: Report Prepare

Procedure:

`dbo.sp_MyBSS_Innove_EOC_Postload_Report_Prepare @CycleCode`

This resolves:

`@BillCycle = BillCycles.BillCycle WHERE CycleCode = @CycleCode`

Then it executes:

1. `sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Error @BillCycle`
2. `sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Valid @BillCycle`

There is no explicit validation or error if `@CycleCode` is missing from `BillCycles`.

### Error Report Cache

Procedure:

`sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Error @BillCycle`

Cache table:

`rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache`

Behavior:

- Deletes cache rows only for the current bill cycle.
- Inserts rows from `ttInnove_Billed`.
- Joins directly to `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` on `zDSP_UniqueKey` and `zDSP_Order`.
- Filters `zLegacyCycle_Code = @BillCycle`.
- Filters `zLoaded = '0'`.
- Filters `Column01 = '01'`.
- Filters `Z_SOURCE_NAME = 'txInnove'`.
- Orders by `Column01`.

Inserted columns:

- `Column01` through `Column19`
- `zDSP_Order`
- `zDSP_UniqueKey`
- `BillCycle`

Important observed details:

- The error cache does not store `Z_MESSAGE`; the cache table has no posting log message column.
- The error cache does not filter for error-text patterns. After the cycle-wide reset, every matched detail row in a failed cycle can appear in the error cache, even if that row's individual SAP message is not one of the recognized error strings.
- A row with `zLoaded = 0` and no matching latest SAP log will not be inserted into the error cache.

### Valid Report Cache

Procedure:

`sp_MyBSS_Innove_EOC_Postload_Report_Prepare_DP1_Billed_Valid @BillCycle`

Cache table:

`rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache`

Behavior:

- Deletes cache rows only for the current bill cycle.
- Inserts distinct rows from `ttInnove_Billed`.
- Left joins directly to `dgS4HANA_TDIR1.dbo.vw_ZFFI_REPORT_ODBC_LATESTLOGS` on `zDSP_UniqueKey` and `zDSP_Order`.
- Includes loaded rows where:
  - `zLegacyCycle_Code = @BillCycle`
  - `zLoaded = '1'`
  - `Z_SOURCE_NAME = 'txInnove'`
- Also includes header/trailer rows where:
  - `Column01 IN ('00','99')`
  - `zLegacyCycle_Code = @BillCycle`

Inserted columns:

- `Column01` through `Column19`
- `zDSP_Order`, but non-detail rows get `NULL`
- `zDSP_UniqueKey`
- `Posting_Log_Message` from `Z_MESSAGE`
- `BillCycle`

Important observed detail:

The `WHERE` predicate mixes `AND` and `OR`. With SQL Server operator precedence, the active behavior is:

`(loaded row from txInnove for the bill cycle) OR (00/99 row for the bill cycle)`

That preserves header/trailer rows in the valid cache even when their `zLoaded` value is not `1`.

## Step 4: SSRS Dataset Procedures

The SSRS report dataset procedures read from the postload cache tables.

Error dataset:

`sp_rpt_tvInnove_DP1_Billed_Postload_Error_SSRS @CycleCode`

Behavior:

- Defaults `@BCCode` to `BC01`.
- Resolves `@BCCode = BillCycles.BillCycle WHERE CycleCode = @CycleCode`.
- Reads `rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache`.
- Filters `BillCycle = @BCCode`.
- Orders by `Column01`, then `TRY_CAST(zDSP_Order AS INT)`.
- Does not return a posting log message column.

Valid dataset:

`sp_rpt_tvInnove_DP1_Billed_Postload_Valid_SSRS @CycleCode = NULL`

Behavior:

- Resolves `@BCCode = BillCycles.BillCycle WHERE CycleCode = @CycleCode`.
- Reads `rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache`.
- Filters with `BillCycle = COALESCE(@BCCode, BillCycle)`.
- Formats `Column08` and `Column09` with `FORMAT(TRY_PARSE(... AS DECIMAL(18,2)), '0.##')`.
- Returns `Posting_Log_Message`.
- Orders by `BillCycle`, `Column01`, then `TRY_CAST(zDSP_Order AS INT)`.

Important observed detail:

The valid dataset's default `NULL` cycle can return all bill cycles because of `COALESCE(@BCCode, BillCycle)`. The error dataset defaults to `BC01` when the cycle does not resolve.

There are also direct cycle-specific views named like:

- `tvInnove_Billed_Cycle1_Postload_ErrorRptSel`
- `tvInnove_Billed_Cycle1_Postload_ValidRptSel`

Those views reproduce similar hard-coded bill-cycle logic. The active postload prepare/export/send path is cache-driven and parameterized by `@CycleCode`.

## Step 5: Report Export

Procedure:

`dbo.sp_MyBSS_Innove_EOC_Postload_Report_Export @CycleCode`

This step triggers SSRS subscriptions to generate Excel files.

It resolves:

`@Keyword_SSRS = BillCycles.Keyword_SSRS WHERE CycleCode = @CycleCode`

Then it builds these SSRS subscription description names:

- `Inov_Billed_Postload_DP1{Keyword_SSRS}_Valid`
- `Inov_Billed_Postload_DP1{Keyword_SSRS}_Error`

For each matching subscription in `ReportServer$DACPRD.dbo.Subscriptions`:

1. Deletes the previous Excel file:
   - `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS\{SubscriptionDescription}.xlsx`
2. Calls:
   - `ReportServer$DACPRD.dbo.AddEvent @EventType = 'TimedSubscription', @EventData = @SubsID`
3. Polls `ReportServer$DACPRD.dbo.Event` every 3 seconds.
4. Stops waiting after 25 iterations, or about 75 seconds.

Important observed detail:

The file delete uses `xp_cmdshell`:

`del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS\{SubscriptionDescription}.xlsx`

If `BillCycles.Keyword_SSRS` is missing, the generated subscription names become `NULL`, and no subscriptions are selected.

## Step 6: Report Send

Procedure:

`dbo.sp_MyBSS_Innove_EOC_Postload_Report_Send @CycleCode`

This step emails generated report files through Database Mail profile `SSRS`.

It resolves:

- `@Keyword_SSRS`
- `@BillCycle`

Record-count rules:

| Report | Record count source |
| --- | --- |
| `Inov_Billed_Postload_DP1{Keyword_SSRS}_Valid` | Detail rows in valid cache for the current bill cycle where `Column01 = '01'`. |
| `Inov_Billed_Postload_DP1{Keyword_SSRS}_Error` | Detail rows in error cache for the current bill cycle where `Column01 = '01'`. |

Reports are emailed only when the computed detail record count is greater than zero. Unlike the Globe postload send procedure, this Innove send procedure does not suppress the valid report when the error count is nonzero. In practice, the cycle-wide reset normally prevents loaded detail rows from remaining valid when a recognized error exists for the cycle, but the send procedure itself does not enforce all-or-nothing behavior.

Attachment path:

`F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS\{SubscriptionDescription}.xlsx`

Email subject:

`Report Notif: MyBSS {SubscriptionDescription} - {RecordCount} Record(s) Generated`

Recipients:

- `harvey.tiong@globe.com.ph`
- `mkguillermo@globe.com.ph`
- `ma.lai@globe.com.ph`
- `princess.ortilano@globe.com.ph`
- `jpdacquil@globe.com.ph`

CC:

- `wmadiano@globe.com.ph`
- `neevangelista@globe.com.ph`
- `isg-eso-support@globe.com.ph`

The body is HTML and includes a Report Server link:

`http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx`

The procedure waits 5 seconds before sending each mail.

## Business Logic Summary

Core business behavior:

- The process starts on `sp_Job_MyBSS_Innove_EOC_Postload`.
- Active postload does not call SSIS packages, does not export SAP load text files, and does not SFTP files.
- Postload consumes `ttInnove_Billed` rows created by the matching preload process.
- SAP feedback comes from ODBC latest-log data in `dgS4HANA_TDIR1`.
- Detail rows are identified by `Column01 = '01'`; header/trailer rows are identified in report logic by `Column01 IN ('00','99')`.
- SAP row matching uses `zDSP_Order` and `zDSP_UniqueKey`.
- `trInnove_Billed_zloaded_Upd` marks matched successful detail rows loaded when `Z_MESSAGE` does not match the fixed error-text list.
- `trInnove_Billed_zLoaded_0_CycleCodeUpd` then resets every row in any bill cycle that has at least one recognized SAP error detail.
- Report preparation is cycle-scoped through `BillCycles`.
- Error report cache rows require `zLoaded = 0`, `Column01 = '01'`, `Z_SOURCE_NAME = 'txInnove'`, and a matching latest SAP log.
- Valid report cache rows include loaded rows from `txInnove` plus `00`/`99` header/trailer rows for the bill cycle.
- Postload valid reports include `Posting_Log_Message`; postload error reports do not.
- SSRS Excel files are generated through timed subscriptions named with `Inov_Billed_Postload_DP1`.
- Emails are sent only for reports with nonzero detail record counts.

## Operational Risks and Gaps

1. Loaded-status updates are not scoped to the input cycle.

   `sp_MyBSS_Innove_EOC_Postload_Transform` has no `@CycleCode` parameter. It can update `zLoaded` for any matching row in `ttInnove_Billed`, not just the cycle being reported by the current SQL Agent job.

2. The cycle-wide reset can turn successful rows into error report rows.

   If one detail row in a bill cycle has a recognized SAP error, `trInnove_Billed_zLoaded_0_CycleCodeUpd` sets `zLoaded = 0` for all rows in that cycle after the success update has already run. The error cache then selects all matched unloaded detail rows for `txInnove`, without rechecking the error-message text.

3. Success and failure classification depend on fixed message text.

   The loaded update and reset view classify SAP messages with hard-coded `LIKE` patterns. New or changed SAP error wording can be missed.

4. Status update views do not filter `Z_SOURCE_NAME = 'txInnove'`.

   The postload report caches filter `Z_SOURCE_NAME = 'txInnove'`, but the transform status updates match latest logs by DSP order and unique key only.

5. Error report cache does not include SAP error text.

   `rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache` has no `Posting_Log_Message` column, and the SSRS error dataset does not return `Z_MESSAGE`. Operators may see rows flagged as errors without the specific SAP message in the report output.

6. Error report requires a matching latest SAP log.

   A target row with `zLoaded = 0` but no matching latest log will not be inserted into the error cache.

7. SAP log refresh is a one-day delta.

   `sp_ZFFI_REPORT_ODBC_Delta` pulls SAP `ZFFI_REPORT_ODBC` rows where `Z_DATE >= ADD_DAYS(CURRENT_DATE, -1)`. Older SAP feedback needed for delayed postload runs may not be refreshed by this step.

8. Missing `BillCycles` mapping fails silently.

   Report prepare, export, and send do not raise an explicit error when `@CycleCode` cannot resolve `BillCycle` or `Keyword_SSRS`; they simply delete/insert no rows, trigger no subscriptions, or send no emails.

9. Report export uses a fixed wait.

   SSRS export waits up to about 75 seconds per subscription. If export is slower, the procedure continues, and email send may look for a missing or stale attachment.

10. Report files and report server are hard-coded.

    The Excel output path and report server link are environment-specific:

    - `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS`
    - `http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx`

11. `xp_cmdshell` is required for housekeeping.

    `sp_MyBSS_Innove_EOC_Postload_Report_Export` deletes prior files through `xp_cmdshell`. SQL Server configuration and the execution/security context must allow it.

12. Global cleanup is dangerous after preload.

    The EOC setup/cleanup job truncates `ttInnove_Billed` globally. Running it after preload but before postload would remove the target rows needed for SAP feedback reconciliation.

13. Job list metadata is inconsistent.

    `etl_pipelines.txt` has `P10_Postload` labels, an EOC08 `Postoad` typo, and `dswTDIR2_Innnove` with an extra `n`, while `sql-agent-jobs.txt` shows `P20_Postload` jobs and the correct `dswTDIR2_Innove` database in the T-SQL calls.

## Validation Checklist

Before running or changing this process, verify:

- The matching Innove EOC preload job completed for the target cycle.
- SAP has attempted to load the preload-generated `txInnove_Billed_Cycle*_LoadFileSel.txt` file.
- The target `BillCycles` row exists for the input `@CycleCode`.
- `BillCycles.Keyword_SSRS` is populated for the cycle.
- `BillCycles.ExportFileKey` and related preload SFTP metadata are aligned with the file SAP processed.
- `ttInnove_Billed` contains rows for the resolved `BillCycle`.
- Detail rows have populated `zDSP_Order` and `zDSP_UniqueKey`.
- `sp_ZFFI_REPORT_ODBC_Delta` has refreshed current SAP feedback, especially if the run is delayed beyond the one-day delta window.
- Latest SAP logs contain matching `ZDSP_ORDER`, `ZDSP_UNIQUEKEY`, `Z_MESSAGE`, and `Z_SOURCE_NAME = 'txInnove'` values for the cycle's records.
- `rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache` and `rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache` are refreshed for the bill cycle.
- Error report users understand that the error cache does not expose `Z_MESSAGE`.
- SSRS subscriptions exist for:
  - `Inov_Billed_Postload_DP1{Keyword_SSRS}_Valid`
  - `Inov_Billed_Postload_DP1{Keyword_SSRS}_Error`
- Excel files are generated in:
  - `F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS`
- Database Mail profile `SSRS` is configured and can send attachments.
- `xp_cmdshell` is enabled and authorized for the SQL Server account running the export procedure.
- The scheduled `13:45:00` postload start is late enough for SAP to finish processing the cycle's load file.
- The global cleanup job is not rerun between successful preload and postload.

## High-Level Data Flow

```text
SQL Agent P20 Postload job
  -> dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_Postload @CycleCode
       -> refresh SAP reference/log tables
          -> dgS4HANA_TDIR1.dbo.sp_ZTF0002S
          -> dgS4HANA_TDIR1.dbo.sp_ZTF0001S
          -> dgS4HANA_TDIR1.dbo.sp_ZFFI_REPORT_ODBC_Delta
             -> SAP_S4 linked server / SAPPRD.ZFFI_REPORT_ODBC
       -> update loaded flags in ttInnove_Billed
          -> trInnove_Billed_zloaded_Upd
          -> trInnove_Billed_zloaded_UpdSel
          -> Innove_Billed_zLoaded_0_CycleCode
          -> trInnove_Billed_zLoaded_0_CycleCodeUpd
          -> ZFFI_REPORT_ODBC_LATESTLOGS
       -> resolve @CycleCode to BillCycle
       -> prepare postload report caches
          -> rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache
          -> rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache
       -> trigger SSRS Excel exports
          -> Inov_Billed_Postload_DP1{Keyword_SSRS}_Error
          -> Inov_Billed_Postload_DP1{Keyword_SSRS}_Valid
          -> F:\BOA\Transform\Report\TDIR2-MyBSS\Innove\ttInnove_Billed_SSRS
       -> send report emails for reports with nonzero detail counts

Related upstream context:
  SQL Agent P01 cleanup job
    -> global truncates of sdbTDIR2_Innove SSIS tables, staging table, and ttInnove_Billed

  SQL Agent P10 preload job
    -> SSIS extracts into sdbTDIR2_Innove
    -> dswTDIR2_Innove.dbo.sp_Job_MyBSS_Innove_EOC_Preload @CycleCode
    -> SAP load text file export

  SQL Agent P15 preload SFTP ad hoc job
    -> dswTDIR2_Innove.dbo.sp_MyBSS_Innove_EOC_Preload_SFTP @CycleCode
    -> etl_db.dbo.sp_sftp_sap_del / sp_sftp_sap_push
```
