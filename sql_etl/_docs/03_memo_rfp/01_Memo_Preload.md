# Memo Preload ETL Reverse Engineering

Reverse engineered on: `2026-06-01`

## Scope

This document describes the SQL ETL process whose standard preload entry point is:

```sql
[dswTDIR1].[dbo].[sp_Job_Memo_Preload]
```

The implementation is a weekday Memo standard-template preload. It ingests a MemoApp
request file, derives SAP posting scenarios, builds line-level posting rows, validates
those rows against SAP reference data, exports successful posting rows, prepares and
sends SSRS reports, and asynchronously starts SFTP and summary-notification jobs.

The main procedure has no runtime parameters. The execution is global for the current
landing data and shared working tables. Scenario selection is data-driven.

This document covers:

- SQL Agent context around the standard Memo preload.
- The direct call chain from `sp_Job_Memo_Preload`.
- Important upstream landing and cleanup steps.
- Scenario routing and line-generation rules.
- Validation, export, report, SFTP, and summary behavior.
- Related DCS jobs that are scheduled separately from the standard preload.
- Operational risks and checks for production support.

## Executive Summary

The normal weekday flow is:

1. `Memo_Preload_P01_Setup_Cleanup_WkDays` truncates the SSIS landing table.
2. `Memo_Preload_P02_Extract_WkDays_v2` renames or fetches source files, runs the
   `Memo_Format03_38Columns` SSIS package, and emails an extraction summary.
3. `Memo_Preload_P10_WkDays` executes `sp_Job_Memo_Preload`.
4. `sp_Job_Memo_Preload` refreshes selected SAP lookup tables, transforms source
   records into scenarios, generates line-level posting records, remediates and
   validates them, exports valid rows, prepares SSRS report caches, triggers report
   subscriptions, and emails available reports.
5. The same entry procedure starts SFTP and stage-summary jobs asynchronously.

The standard preload is not a batch-isolated pipeline. Several procedures truncate or
update shared tables without a run identifier, processing date predicate, or explicit
transaction boundary. SQL Agent timing and single-run discipline are therefore part of
the operational contract.

## Source Files Reviewed

### Pipeline Metadata

- `etl_pipelines.txt`
- `sql-agent-jobs.txt`
- `MyBSS_Innove_Bill_Cycles_Preload.md` as the repository documentation pattern

### Main Orchestration

- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Preload.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Scenario_LoadSapTables.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Scenario_Transform.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Scenario_Transform_Rules.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Transform.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Transform_Rules.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Remediation.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Export.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Report_Prepare.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Report_Export.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Memo_Preload_Line_Report_Send.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Preload_SFTP.StoredProcedure.sql`
- `dswTDIR1/programmability/stored_procedures/dbo.sp_Job_Memo_Preload_Notif_Summary.StoredProcedure.sql`

### Upstream Landing and Extraction

- `sdbTDIR1_MemoApp/programmability/stored_procedures/dbo.sp_MemoRFP_Job_Cleanup.StoredProcedure.sql`
- `sdbTDIR1_MemoApp/programmability/stored_procedures/dbo.sp_MemoRFP_Job_FetchSourceFiles.StoredProcedure.sql`
- `sdbTDIR1_MemoApp/programmability/stored_procedures/dbo.sp_MemoRFP_Job_SourceFilesCount_V2.StoredProcedure.sql`
- `sdbTDIR1_MemoApp/programmability/stored_procedures/dbo.sp_Clean_PaymentRequests_38Cols.StoredProcedure.sql`
- `sdbTDIR1_MemoApp/tables/dbo.PaymentRequests_38Cols_ssis.Table.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.vw_MemoApp_Source_AllProponents_ssis.View.sql`

### Scenario Routing

- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario1_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario2_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario3_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario4_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario5_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario6.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario8R_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario8M_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario9_R2.View.sql`
- `sdbTDIR1_MemoApp/views/dbo.MemoApp_Source_AllProponents_Scenario10_R2.View.sql`
- Supporting grouping and VAT-category view families under `sdbTDIR1_MemoApp/views`

### Generated Line, Validation, Export, and Report Objects

- Scenario-specific `sp_Memo_Preload_Line_Transform_Scn*` procedures under
  `dswTDIR1/programmability/stored_procedures`
- Generated `trMEMOAPP_*`, `srMEMOAPP_*`, `txMEMOAPP_*`, and `tvMEMOAPP_*` procedure
  and view families under `dswTDIR1`
- Standard Memo preload report-cache tables under `dswTDIR1_Cache/tables`
- Related DCS procedure families under `dswTDIR1/programmability/stored_procedures`

## Databases and External Dependencies

| Dependency | Purpose |
| --- | --- |
| `sdbTDIR1_MemoApp` | SSIS landing table, source cleanup, consolidated source view, scenario-routing views, extraction summary |
| `dswTDIR1` | Main orchestration, working tables, posting target tables, SAP wrapper views, validation logic, exports, and reports |
| `dswTDIR1_Cache` | Shared Memo report-cache tables, including standard preload and related DCS caches |
| `dgS4HANA_TDIR1` | SAP reference-data refresh procedures and underlying SAP lookup data |
| `etl_db` | Procedure logging, batch execution, text export, SFTP helpers, string-cleanup helpers, and latest-processed-date function |
| `msdb` | SQL Agent job startup through `sp_start_job` and Database Mail through `sp_send_dbmail` |
| `ReportServer$DACPRD` | SSRS subscriptions, event queue, and `AddEvent` execution |
| `F:\Scripts` | Batch-file location used by source-file preparation |
| `F:\BOA\Transform\Export\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_New` | Posting-file export root; the deployed path contains `MEMEOAPP` |
| `F:\BOA\Transform\Report\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_SSRS` | SSRS report-output folder |
| SQL Server `xp_cmdshell` | Deletes previous `.xlsx` report output before SSRS subscriptions run |
| SSIS package `Memo_Format03_38Columns.dtsx` | Loads the MemoApp 38-column source format |

The SQL Agent metadata for the SSIS package contains a deployed connection to the
MemoApp database. The checked-in metadata masks the password as `xxxx`.

## SQL Agent Context

### Standard Memo Jobs

| Job | Step | Command or package | Schedule |
| --- | --- | --- | --- |
| `Memo_Preload_P01_Cleanup_ErrorPage_WkDays` | `sp_Job_DCMemoApp_Archive` | `EXEC dbo.sp_Job_DCMemoApp_Archive` | Daily at `8:00 AM` |
| `Memo_Preload_P01_Setup_Cleanup_WkDays` | `sp_MemoRFP_Job_Cleanup` | `EXEC dbo.sp_MemoRFP_Job_Cleanup` | Weekdays at `2:30 PM` |
| `Memo_Preload_P02_Extract_WkDays_v2` | `MemoRFP_Job_FetchSourceFiles` | `EXEC dbo.sp_MemoRFP_Job_FetchSourceFiles` | Weekdays at `2:40 PM` |
| `Memo_Preload_P02_Extract_WkDays_v2` | `Memo_Format03_38Columns` | SSIS package | Weekdays at `2:40 PM` |
| `Memo_Preload_P02_Extract_WkDays_v2` | `sp_MemoRFP_Job_SourceFilesCount_V2` | `EXEC dbo.sp_MemoRFP_Job_SourceFilesCount_V2` | Weekdays at `2:40 PM` |
| `Memo_Preload_P10_WkDays` | `sp_Job_Memo_Preload` | `EXEC dbo.sp_Job_Memo_Preload` | Weekdays at `2:55 PM` |
| `Memo_Preload_P15_SFTP_AdHoc` | `sp_Job_Memo_Preload_SFTP` | `EXEC dbo.sp_Job_Memo_Preload_SFTP` | No direct schedule |
| `Memo_Preload_P17_Notif_Summary_AdHoc` | `sp_Job_Memo_Preload_Notif_Summary` | `EXEC dbo.sp_Job_Memo_Preload_Notif_Summary` | No direct schedule |

The standard preload procedure starts the two ad hoc jobs after its synchronous work.
They are separate SQL Agent executions, so the parent procedure does not wait for or
verify their completion.

### Related DCS Jobs

| Job | Step | Command | Schedule |
| --- | --- | --- | --- |
| `Memo_Preload_DCS_P02_Extract_WkDays` | `sp_Job_Memo_Preload_DCS_Extract_ErrorPage` | `EXEC dbo.sp_Job_Memo_Preload_DCS_Extract_ErrorPage` | Weekdays at `3:15 PM` |
| `Memo_Preload_DCS_P10_WkDays` | `sp_Job_Memo_Preload_DCS` | `EXEC dbo.sp_Job_Memo_Preload_DCS` | Weekdays at `2:50 PM` and `6:01 PM` |
| `Memo_Preload_DCS_P15_SFTP_AdHoc` | `sp_Job_Memo_Preload_DCS_SFTP` | `EXEC dbo.sp_Job_Memo_Preload_DCS_SFTP` | No direct schedule |

These DCS jobs are related Memo workflows but are not called by
`sp_Job_Memo_Preload`. They have their own transform, export, report, and SFTP chain.

### Metadata Gap

`etl_pipelines.txt` lists `Memo Standard Template` with databases
`sdbTDIR1_MemoApp`, `dswTDIR1`, and `dswTDIR1_Cache`, but its `sql agent jobs`
section is empty. The concrete SQL Agent inventory is present in `sql-agent-jobs.txt`.

## Upstream Landing Process

### Cleanup

`sdbTDIR1_MemoApp.dbo.sp_MemoRFP_Job_Cleanup` performs:

```sql
TRUNCATE TABLE PaymentRequests_38Cols_ssis;
```

This is a global landing-table cleanup. There is no batch predicate.

The separately scheduled `Memo_Preload_P01_Cleanup_ErrorPage_WkDays` job references
`dbo.sp_Job_DCMemoApp_Archive`, but that procedure definition was not present in the
reviewed repository files.

### Source-File Preparation

`sdbTDIR1_MemoApp.dbo.sp_MemoRFP_Job_FetchSourceFiles` calls:

```sql
[etl_db].[dbo].[sp_ExecBatchFile]
    @Path = 'F:\Scripts',
    @Filename = 'memoapp_file_rename2025.bat'
```

Comments identify this as the preparation step for moving or renaming uploaded MemoApp
source files into the final source location used by the SSIS package. The batch-file
implementation is outside this SQL repository.

### SSIS Load and Source Cleanup

The SQL Agent extraction job executes `Memo_Format03_38Columns.dtsx`. Its landing
table is `sdbTDIR1_MemoApp.dbo.PaymentRequests_38Cols_ssis`.

The supporting procedure `sp_Clean_PaymentRequests_38Cols` normalizes text fields in
that landing table by trimming spaces and converting empty strings to `NULL`. It also
normalizes the 2025 fields and formats `RFP_Approval_Date`. The reviewed SQL Agent
metadata does not expose whether SSIS invokes this helper internally, so its exact
position inside the package should be verified in the `.dtsx` deployment source.

`sdbTDIR1_MemoApp.dbo.MemoApp_Source_AllProponents` exposes the consolidated source
payload through `vw_MemoApp_Source_AllProponents_ssis`.

### Input Payload

The consolidated source view exposes these columns:

| Group | Fields |
| --- | --- |
| File identity | `zInputFileName`, `zRowNumber` |
| Invoice identity | `Invoice_Date`, `Invoice_Number`, `MemoApp_Ref_No_or_Proponents_Name`, `Vendor_Code`, `Vendor_Name`, `Currency` |
| Amount and tax | `WHT_Base`, `VAT_Code`, `Gross_Invoice_Amount`, `Input_VAT_Amount`, `WHT_Type` |
| Accrual and company | `Accrual_Doc_Number`, `Company_Code`, `Accrual_Doc_Fiscal_Year` |
| Accounting assignment | `GL_Natural_Code`, `Cost_Center_Code`, `IO_Code`, `WBS_Code`, `Link_Reference`, `Link_Ref_Period`, `Product_Line` |
| Payment metadata | `Payment_Method`, `Payment_Terms`, `Payment_Block_Code` |
| Descriptive fields | `Description`, `Assignment` |
| Revenue metadata | `Brand`, `Sub_Prod_A`, `Revenue_Type`, `Profit_Center`, `Sub_Prod_B` |
| Real-estate and business metadata | `Site_PLA_ID`, `RFP_Approval_Date`, `Business_Entity`, `Building`, `Land`, `Rental_Object`, `Contract` |

### Extraction Notification

`sp_MemoRFP_Job_SourceFilesCount_V2` sends a stage-1 extraction email. It reports:

- Current-day import failures from `PaymentRequests_Failed`.
- Successful source records from the MemoApp source view.
- Duplicate counts from `temp_vw_MemoApp_Source_AllProponents_ssis_duplicates`.
- A changed subject and body when failures are present.

The email is sent through Database Mail profile `SSRS`.

## Main Procedure Call Chain

`dswTDIR1.dbo.sp_Job_Memo_Preload` sets logging metadata:

```text
@Proccess     = Memo
@ProcessGroup = All
@Step         = Preload
@Others       = Daily
```

The source spelling `@Proccess` is preserved here because it is part of the deployed
logging contract.

The procedure invokes each synchronous child through
`etl_db.dbo.sp_ExecuteQueryAndLog`:

| Order | Procedure | Role |
| --- | --- | --- |
| 1 | `sp_Memo_Preload_Scenario_LoadSapTables` | Refresh selected SAP lookups |
| 2 | `sp_Memo_Preload_Scenario_Transform` | Stage source rows and assign scenarios |
| 3 | `sp_Memo_Preload_Line_Transform` | Build line-level posting rows |
| 4 | `sp_Memo_Preload_Line_Remediation` | Validate and mark failed rows |
| 5 | `sp_Memo_Preload_Line_Export` | Write valid posting files |
| 6 | `sp_Memo_Preload_Line_Report_Prepare` | Refresh report-cache tables |
| 7 | `sp_Memo_Preload_Line_Report_Export` | Trigger SSRS subscriptions |
| 8 | `sp_Memo_Preload_Line_Report_Send` | Email available reports |

After the synchronous chain, it starts:

| Order | SQL Agent job | Role |
| --- | --- | --- |
| 9 | `Memo_Preload_P15_SFTP_AdHoc` | Push posting files |
| 10 | `Memo_Preload_P17_Notif_Summary_AdHoc` | Send stage-2 reconciliation summary |

## Step 1: Refresh SAP Lookup Data

`sp_Memo_Preload_Scenario_LoadSapTables` refreshes these
`dgS4HANA_TDIR1.dbo` source tables:

| Procedure | SAP object role |
| --- | --- |
| `sp_T007A` | Tax-code attributes |
| `sp_SKB1` | Company-code GL master |
| `sp_SKA1` | Chart-of-accounts GL master |
| `sp_SKAT` | GL descriptions |
| `sp_T030K` | Tax-account determination |
| `sp_T042Z` | Payment methods |
| `sp_T25A1` | Brand mapping |
| `sp_T25A2` | Product-line mapping |
| `sp_T25A4` | Sub-product mapping |
| `sp_T25A9` | Revenue-type mapping |
| `sp_TVZBT` | Payment-term descriptions |
| `sp_LFB1` | Vendor company-code data |
| `sp_CSKS` | Cost centers |
| `sp_AUFK` | Internal orders |
| `sp_LFBW` | Vendor withholding-tax data |

The local `dswTDIR1` wrapper views expose SAP data used by validation. Several wrapper
views filter SAP client `MANDT = '300'`.

Three large SAP refreshes are commented out in the active procedure:

| Inactive refresh | Commented approximate record count |
| --- | --- |
| `sp_PRPS` | `6,537,724` |
| `sp_BSAK` | `15,788,298` |
| `sp_BSIK` | `48,951,763` |

This is operationally important because remediation still reads PRPS, BSAK, and BSIK
wrapper views. Their freshness depends on another refresh path or an off-peak process
outside this entry procedure.

## Step 2: Transform Source Rows into Scenarios

### Stage the Consolidated Source

`sp_Memo_Preload_Scenario_Transform`:

1. Truncates
   `stMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents`.
2. Inserts the consolidated 40-column MemoApp source payload ordered by input filename
   and row number.
3. Executes `sp_Memo_Preload_Scenario_Transform_Rules`.

### Apply Scenario Rules

The active scenario-rule procedure:

- Pads and derives internal GL and SAP lookup fields.
- Derives scenario-specific flags, grouped counts, gross-amount sums, VAT-amount sums,
  minimum rows, and maximum rows.
- Assigns the selected initial scenario.
- Generates document counters and counter line items.
- Trims invoice-date suffixes.
- Deletes invalid-length source groups.
- Replaces target scenario records for `zSource = 'TDIR1_MemoApp'`.

A refactored procedure block exists in comments, but the active executable block is
the original inline sequence.

### Scenario Mapping

Scenarios are selected from the source data. They are not SQL Agent parameters.

| Scenario | Confirmed routing condition |
| --- | --- |
| `Scenario1` | VAT category in `0A`, `0C`, or `0E`; one to 996 grouped rows; VAT amount category is `VALUE` |
| `Scenario2` | VAT category in `0A`, `0C`, or `0E`; exactly one grouped row; VAT amount category is `BLANK` |
| `Scenario3` | VAT category `0D`; exactly one grouped row; VAT amount category is `BLANK` |
| `Scenario4` | VAT category in `0A`, `0C`, or `0E`; more than one and at most 996 grouped rows; VAT amount category is `BLANK` |
| `Scenario5` | VAT category `0D`; more than one and at most 996 grouped rows; VAT amount category is `BLANK` |
| `Scenario6` | `Accrual_Doc_Number` is not blank; later split into `2_inScn6`, `3_inScn6`, `4_inScn6`, and `5_inScn6` |
| `Scenario8R` | VAT category `O1` using letter `O`; two to 996 grouped rows; blank VAT amount; contains both GL `230160` and a nonblank non-`230160` GL |
| `Scenario8M` | VAT category `BL`; one to 996 grouped rows; blank VAT amount |
| `Scenario9` | VAT combinations of `0D` with `0A`, `0C`, or `0E`, in either order; two to 996 grouped rows |
| `Scenario10` | A blank VAT entry combined with `0A`, `0C`, `0D`, or `0E`, including supported three-value combinations with `0D`; two to 996 grouped rows |

### Counter Generation

The scenario rules build document counters used to keep related line items together.
Comments describe a custom counter based on a year/day component and the last six
digits of an incrementing value to support up to `999999` records per process while
retaining uniqueness for DCS usage. Scenario 6 has a dedicated counter path.

### Invalid-Length Deletion

Before scenario target insertion, the rules delete an entire counter when a grouped
source record exceeds one of these lengths:

| Source field | Maximum length |
| --- | --- |
| `Vendor_Code` | `10` |
| `Invoice_Number` | `16` |
| `VAT_Code` | `2` |
| `GL_Natural_Code` | `10` |
| `Company_Code` | `4` |
| `Currency` | `5` |
| `MemoApp_Ref_No_or_Proponents_Name` | `25` |
| `Link_Reference` | `12` |
| `Link_Ref_Period` | `12` |
| `WBS_Code` | `24` |
| `Payment_Terms` | `4` |
| `IO_Code` | `12` |
| `Product_Line` | `10` |
| `WHT_Type` | `2` |

The deletion joins bad source data back by invoice number, vendor code, and company
code, then removes all scenario staging rows for the affected counter. This is broader
than deleting only the individual bad line.

## Step 3: Generate Line-Level Posting Rows

`sp_Memo_Preload_Line_Transform` executes scenario-specific loaders and then applies
shared line rules.

### Active Scenario Loaders

| Scenario | Generated posting lines |
| --- | --- |
| `Scenario1` | Vendor, GL, VAT |
| `Scenario2` | Vendor, GL |
| `Scenario3` | Vendor, GL |
| `Scenario4` | Vendor, GL |
| `Scenario5` | Vendor, GL |
| `Scenario8R` | Vendor, VAT, GL |
| `Scenario8M` | Vendor, GL |
| `Scenario9` | Vendor, VAT, GL |
| `Scenario10` | Vendor, VAT, GL |

Each loader follows the same generated pattern:

1. Truncate its scenario-and-line-type staging table.
2. Insert from the corresponding `sdbTDIR1_MemoApp.dbo.MemoApp_AllProps_*` source
   view.
3. Run generated transformation procedures for SAP posting fields, source identity,
   dates, counters, ordering, and derived keys.
4. Delete the existing target slice for that generated `zSource`.
5. Insert only active rows into `dswTDIR1.dbo.ttMEMOAPP_Preload`.

The line target is therefore replaced by generated source slice, not by a global target
truncate.

### Shared Line Rules

After scenario loaders run, shared rules:

- Trim posting-date suffixes.
- Convert posting amounts and withholding-tax bases to absolute values.
- Stamp added-on and added-by metadata.
- Set the initial BOA status and proponent.
- Stamp input-file processed dates, including a current-date custom override.
- Build legacy and current DSP unique keys.
- Derive GL account type from SKA1.
- Update VAT-related behavior from SKB1.
- Blank revenue-only fields on Vendor and VAT lines.
- Map manual profit centers for Scenario 8 revenue GL rows:

| Company code | Profit center |
| --- | --- |
| `GLOB` | `MCG` |
| `INOV` | `IC_WVL` |
| `BAYN` | `BT_WVL` |
| Other | Blank |

- Set final DSP ordering.

### Scenario 6 Observation

Scenario 6 source, transform, and export objects exist, including source groups such as
`2_inScn6`, `3_inScn6`, `4_inScn6`, and `5_inScn6`, and generated sources for new
accrual-document Vendor and GL rows.

However, the active `sp_Memo_Preload_Line_Transform` call list does not directly invoke
a Scenario 6 loader while the standard export procedures still select Scenario 6
rows. This should be verified against the deployed database definition and recent run
data. In the reviewed scripts, Scenario 6 target slices may depend on another path or
may remain stale.

## Step 4: Remediate and Validate Posting Rows

`sp_Memo_Preload_Line_Remediation` applies validations directly to
`dswTDIR1.dbo.ttMEMOAPP_Preload`.

The procedure is global: it does not restrict updates by source filename, processed
date, run identifier, or current counter range.

### SAP Master-Data Checks

| Validation group | SAP data used |
| --- | --- |
| GL existence, creation, posting block, deletion, and company extension | `SKA1`, `SKB1` |
| Vendor existence, company extension, posting block, and deletion | `LFB1` |
| Payment method | `T042Z`, restricted to country `PH` |
| Payment terms | `TVZBT`, restricted to language `E` |
| Withholding type and code | `LFBW` |
| Cost center existence, company, validity date, and block state | `CSKS` |
| Internal-order close state | `AUFK` |
| WBS element existence | `PRPS` |
| VAT code | `T007A` |
| Tax-account determination | `T030K`, restricted to chart `GLOB` |
| Product line | `T25A2` |
| Brand | `T25A1` |
| Sub-product A | `T25A4` |
| Revenue type | `T25A9` |

### Document and Scenario Checks

The remediation layer also checks:

- Required reference and document dates.
- Invalid dates.
- Duplicate invoice/vendor/company combinations, with Scenario 6 treated specially.
- Scenario overlap and unsupported source-value combinations.
- Balance-sheet and revenue-GL constraints.
- Invalid revenue withholding.
- Scenario 8 revenue and non-revenue rules.
- Scenario 8 file classification.
- Scenario 9 restrictions for GL `140621`.
- Scenario 10 restrictions and duplicates.
- The rule that GL `140621` is allowed only for Scenario 10.
- Nonblank accrual document handling.
- Scenario-specific VAT amount and VAT-sign rules.
- Credit and debit equality.
- Multiple withholding, payment-method, and payment-term values.
- Required cost center.
- Required Scenario 8 revenue metadata.
- Scenario 8M mixed revenue and non-revenue restrictions.
- Profit-center requirements for revenue GL lines.

### Previously Posted Document Checks

Existing-document remediation checks BSAK and BSIK data using:

- Vendor code padded to 10 characters.
- Normalized invoice reference.
- Company code.
- Document-date year.

Because BSAK and BSIK refresh calls are inactive in the parent SAP-load step, this
validation depends on externally maintained reference freshness.

### Error Propagation

After rule-specific error flags are set:

1. A line receives `zError_LineItem = 1` when any relevant validation fails.
2. All lines in the same counter receive `zError_Counter = 1`.
3. The process builds line error messages from the active flags.
4. Successful lines remain eligible for export only when both error indicators are
   zero.

## Step 5: Export Successful Posting Files

`sp_Memo_Preload_Line_Export` loops over a hard-coded export list and calls:

```sql
[etl_db].[dbo].[sp_ExportTextFile]
```

### Export Folders

| Export type | Folder |
| --- | --- |
| With tax | `F:\BOA\Transform\Export\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_New\WithTax` |
| Without tax | `F:\BOA\Transform\Export\TDIR1-MEMEOAPP_V2\MEMOAPP_V2_New\NoTax` |

### Active Export Files

| Order | Selector procedure | Folder | Output file |
| --- | --- | --- | --- |
| 1 | `sp_Memo_Preload_Line_Export_01_Scn01_NoTax` | NoTax | `OB_Scn1_NoTax.txt` |
| 2 | `sp_Memo_Preload_Line_Export_02_Scn02To05_WithTax` | WithTax | `OB_Scn2To5_WithTax.txt` |
| 3 | `sp_Memo_Preload_Line_Export_03_Scn02To5_NoTax` | NoTax | `OB_Scn2To5_NoTax.txt` |
| 4 | `sp_Memo_Preload_Line_Export_05_Scn06_Acc2To5BNewAcc_NoTax` | NoTax | `OB_Scn6_2To5B_NewAccDoc_NoTax.txt` |
| 5 | `sp_Memo_Preload_Line_Export_06_Scn06_Acc2To5C_WithTax` | WithTax | `OB_Scn6_Acc2To5C_Inv_WithTax.txt` |
| 6 | `sp_Memo_Preload_Line_Export_07_Scn06_Acc2To5C_NoTax` | NoTax | `OB_Scn6_Acc2To5C_Inv_NoTax.txt` |
| 7 | `sp_Memo_Preload_Line_Export_08_Scn08_M_NoTax` | NoTax | `OB_Scn8M_NoTax.txt` |
| 8 | `sp_Memo_Preload_Line_Export_09_Scn08_R_NoTax` | NoTax | `OB_Scn8R_NoTax.txt` |
| 9 | `sp_Memo_Preload_Line_Export_10_Scn09_NoTax` | NoTax | `OB_Scn9_NoTax.txt` |
| 10 | `sp_Memo_Preload_Line_Export_11_Scn10_NoTax` | NoTax | `OB_Scn10_NoTax.txt` |

The Scenario 6 reversal export
`sp_Memo_Preload_Line_Export_04_Scn06_Acc2To5A_Reversal` is commented out and marked
as not in use.

### Export Eligibility

All active export selectors ultimately read the passed-record selector:

```text
tvMEMOAPP_Preload_From_Input_Files_Scnarios1To6_RptSel
```

It filters:

```sql
zError_LineItem = 0
AND zError_Counter = 0
```

### Export Mapping

| Output group | Additional selector logic |
| --- | --- |
| Scenario 1 no tax | `Scenario1`, VAT tax code in `0A`, `0C`, `0D` |
| Scenario 2 to 5 with tax | Scenario 2 to 5, VAT tax code in `0A`, `0C`, `0E` |
| Scenario 2 to 5 no tax | Scenario 2 to 5, VAT tax code `0D` |
| Scenario 6 new accrual document | Scenario 6 split rows; `zSource` is `Scenario6_NewAccDoc_GL` or `Scenario6_NewAccDoc_Vendor` |
| Scenario 6 invoice with tax | Scenario 6 split rows excluding new-accrual sources; VAT tax code in `0A`, `0C`, `0E` |
| Scenario 6 invoice no tax | Scenario 6 split rows excluding new-accrual sources; VAT tax code `0D` |
| Scenario 8M | `Scenario8M` |
| Scenario 8R | `Scenario8R` |
| Scenario 9 | `Scenario9` |
| Scenario 10 | `Scenario10` |

Export procedures prepend a header row and sanitize selected text fields with
`dbo.fn_RemoveTab` to protect tab-delimited output.

Most export procedures include the 2025 payload additions:

```text
zSite_PLA_ID
zRFP_Approval_Date
zPayment_Block_Code
zProfit_Center
zSub_Prod_B
zBusiness_Entity
zBuilding
zLand
zRental_Object
zContract
```

The Scenario 6 new-accrual export should be compared with receiving-system
expectations because its reviewed output shape does not clearly include the same
extended payload.

## Step 6: Prepare Report Caches

`sp_Memo_Preload_Line_Report_Prepare` refreshes shared cache tables by truncating each
cache and inserting from the corresponding reporting selector.

| Order | Cache purpose | Main selector |
| --- | --- | --- |
| 1 | All preload rows | `tvMEMOAPP_Preload_From_Input_Files_AllData_Scnarios1To6_RptSel` |
| 2 | Failed rows | `tvMEMOAPP_Preload_From_Input_Files_Scnarios1To6_ErrorRecords_RptSel` |
| 3 | Passed rows | `tvMEMOAPP_Preload_From_Input_Files_Scnarios1To6_RptSel` |
| 4 | Invalid source lengths | `tvMemoApp_Preload_Invalid_Length_SourceValues_R2RptSel` |
| 5 | Scenario overlaps | `tvMEMOAPP_Preload_zError_ScenarioOverlap_RptSel` |
| 6 | Invalid length or format | `tvMEMOAPP_Preload_zError_SourceValues_R2_RptSel` |
| 7 | Unrecognized scenarios | `tvMEMOAPP_Scenario_NOT_Identified_Error_RptSel` |

The cache tables live in `dswTDIR1_Cache`. They are shared tables, not run-scoped
snapshots.

## Step 7: Trigger SSRS Report Exports

`sp_Memo_Preload_Line_Report_Export` triggers these SSRS subscriptions:

| Subscription description |
| --- |
| `Preload_Scenario_1To6_AllData` |
| `Preload_Scenario_1To6_Failed` |
| `Preload_Scenario_1To6_Passed` |
| `Preload_InvalidFormat` |
| `Preload_InvalidLength` |
| `Preload_Overlap` |
| `Preload_NotRecognized` |
| `Preload_Scenario_1To6_Summary` |

For each subscription, the procedure:

1. Deletes the previous `.xlsx` file from the report folder through `xp_cmdshell`.
2. Looks up the matching subscription in `ReportServer$DACPRD.dbo.Subscriptions`.
3. Calls `ReportServer$DACPRD.dbo.AddEvent` with `TimedSubscription`.
4. Polls `ReportServer$DACPRD.dbo.Event` every three seconds until the subscription
   event disappears or the loop reaches 100 iterations.

The comment describes a five-minute wait. The implemented timeout is approximately
five minutes.

All eight subscriptions are triggered even when a report category has no records.

## Step 8: Email Available Reports

`sp_Memo_Preload_Line_Report_Send` counts passed and failed rows from the report caches,
then emails selected report attachments through Database Mail profile `SSRS`.

The all-data report attachment is intentionally commented out. A source comment dated
`2023-11-23` states that passed and failed reports can be combined instead.

| Report attachment | Sent when |
| --- | --- |
| Failed | Failed-row count is greater than zero |
| Passed | Passed-row count is greater than zero |
| Invalid length | Invalid-length cache count is greater than zero |
| Overlap | Overlap cache count is greater than zero |
| Invalid format | Invalid-format cache count is greater than zero |
| Not recognized | Unrecognized-scenario cache count is greater than zero |
| Summary | Passed plus failed count is greater than zero |

The procedure waits five seconds before sending each report email. A nearby comment
still says three seconds.

The email body links to:

```text
http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx
```

## Step 9: Start the SFTP Push

The parent procedure asynchronously starts `Memo_Preload_P15_SFTP_AdHoc`, which runs
`sp_Job_Memo_Preload_SFTP`.

The active SFTP procedure calls:

```text
etl_db.dbo.sp_sftp_sap_push('01_OB_Scn_WithTax_Push')
etl_db.dbo.sp_sftp_sap_push('01_OB_Scn_NoTax_Push')
```

Two delete-helper calls are present but commented out:

```text
etl_db.dbo.sp_sftp_sap_del('03_OB_Scn_WithTax_Del')
etl_db.dbo.sp_sftp_sap_del('03_OB_Scn_NoTax_Del')
```

The parent preload does not wait for or validate the SFTP job result.

## Step 10: Send the Stage-2 Summary

The parent procedure asynchronously starts `Memo_Preload_P17_Notif_Summary_AdHoc`,
which runs `sp_Job_Memo_Preload_Notif_Summary`.

The summary procedure:

1. Reads latest processed timestamps using
   `etl_db.dbo.fn_GetLatestProccessedDate('Memo', procedureName)`.
2. Truncates shared table `MemoMigratePreloadTemp`.
3. Inserts counts for source deletion, preload, each export group, failed validation,
   and discrepancy.
4. Sends a Process Stage 2 of 3 HTML summary through Database Mail profile `SSRS`.

### Summary Rows

| Order | Summary metric |
| --- | --- |
| 1 | Invalid-length deleted rows |
| 2 | Total preload rows |
| 3 | Scenario 1 no-tax rows |
| 4 | Scenario 2 to 5 with-tax rows |
| 5 | Scenario 2 to 5 no-tax rows |
| 6 | Scenario 6 reversal rows, hard-coded to `0` |
| 7 | Scenario 6 new-accrual no-tax rows |
| 8 | Scenario 6 invoice with-tax rows |
| 9 | Scenario 6 invoice no-tax rows |
| 10 | Scenario 8M no-tax rows |
| 11 | Scenario 8R no-tax rows |
| 12 | Scenario 9 no-tax rows |
| 13 | Scenario 10 no-tax rows |
| 14 | Failed validation rows not exported to SAP |
| 15 | Discrepancy: total preload minus the sum of rows 3 through 14 |

The email subject changes when the discrepancy row is nonzero.

## Related DCS Workflow

`sp_Job_Memo_Preload_DCS` is a separately scheduled workflow with logging step
`Preload - DCS`. It runs its own:

1. DCS transform.
2. DCS export.
3. DCS report-cache preparation.
4. DCS report export.
5. DCS report send.
6. Asynchronous DCS SFTP job.

`sp_Job_Memo_Preload_DCS_Extract_ErrorPage` inserts preload error-page records through:

```sql
dbo.trMEMOAPP_DCS_Preload_PreloadError_Insert_Into_DcMemoApp_Ins
```

The DCS SFTP job uses push keys:

```text
01_OB_DCS_Scn_WithTax_Push
01_OB_DCS_Scn_NoTax_Push
```

As in the standard SFTP path, related delete-helper calls are commented out.

## Business Logic Summary

The preload converts MemoApp requests into SAP posting text files through these layers:

| Layer | Responsibility |
| --- | --- |
| Source landing | Load one 38-column request format into a shared SSIS landing table |
| Source consolidation | Expose normalized request records through MemoApp source views |
| Scenario transform | Group records and infer SAP posting scenarios from VAT, line-count, GL, and accrual-document data |
| Line transform | Generate Vendor, GL, and VAT posting lines for each active scenario |
| Remediation | Validate SAP master data, source formats, posting rules, duplicates, and document history |
| Export | Write only counters without line or counter errors |
| Reporting | Snapshot shared cache tables, trigger SSRS, and email available workbooks |
| Delivery | Start ad hoc SFTP and stage-summary jobs asynchronously |

## Operational Risks and Gaps

### 1. Shared Tables Are Not Run-Isolated

Landing tables, scenario staging, report caches, the line target, and summary staging
contain global truncates or updates. Concurrent runs can overwrite each other's
intermediate state or report output.

### 2. Extraction-to-Preload Timing Is Tight

The weekday extraction starts at `2:40 PM`; the standard preload starts at `2:55 PM`.
The reviewed parent preload has no wait or source-load completeness check. SSIS and its
summary step must finish within the scheduling window.

### 3. SFTP and Summary Are Fire-and-Forget Jobs

The main procedure starts both SQL Agent jobs asynchronously and returns without
checking status. A successful parent-job status does not prove successful delivery or
summary notification.

### 4. Large SAP Lookups Are Not Refreshed in the Active Chain

PRPS, BSAK, and BSIK refresh calls are commented out, but remediation still uses their
data. Stale WBS or posted-document data can change validation outcomes.

### 5. Scenario 6 Transform Invocation Needs Deployment Verification

Scenario 6 source and export objects exist, but the active line-transform orchestration
does not visibly call Scenario 6 loaders. Confirm whether deployed code differs or
whether another job populates those target slices.

### 6. Scenario 6 Extended Export Shape Needs Contract Verification

Most export files include the 2025 extended fields. The reviewed Scenario 6
new-accrual export does not clearly expose the same extended shape.

### 7. SSRS Uses Shared Files and Queue Polling

Report generation deletes fixed filenames with `xp_cmdshell`, triggers shared SSRS
subscriptions, and waits on the report-server event queue. Overlapping runs or SSRS
delays can produce missing or stale attachments.

### 8. SFTP Cleanup Calls Are Inactive

Both standard and DCS SFTP procedures contain commented delete-helper calls. Confirm
whether push helpers overwrite remote files or whether stale remote files can remain.

### 9. Pipeline Inventory Is Split Across Metadata Files

`etl_pipelines.txt` omits the Memo SQL Agent job list, while `sql-agent-jobs.txt`
contains it. Support documentation should treat the latter as the concrete inventory
until metadata is reconciled.

### 10. Archive Procedure Is Missing from the Reviewed Repository

The error-page cleanup job references `sp_Job_DCMemoApp_Archive`, but its definition
was not found. Its retention and cleanup behavior cannot be confirmed from this repo.

## Validation Checklist

Before relying on a weekday run, verify:

- `Memo_Preload_P01_Setup_Cleanup_WkDays` succeeded before SSIS load.
- The `Memo_Format03_38Columns` SSIS package completed before `2:55 PM`.
- The extraction summary has no unexpected source failures or duplicates.
- SAP reference refresh timestamps are current, including externally refreshed PRPS,
  BSAK, and BSIK.
- Only one standard Memo preload run is active.
- Scenario counts align with source-file expectations, especially Scenario 6.
- `ttMEMOAPP_Preload` has expected passed and failed row counts.
- Export files exist in both `WithTax` and `NoTax` paths where expected.
- Report-cache counts match export and failed-validation counts.
- SSRS workbooks exist before report emails are sent.
- `Memo_Preload_P15_SFTP_AdHoc` completed successfully after the parent job.
- `Memo_Preload_P17_Notif_Summary_AdHoc` completed successfully and reports zero
  discrepancy unless an explained exception exists.
- DCS jobs are monitored separately from the standard preload.

## High-Level Data Flow

```text
Memo source files
    |
    v
memoapp_file_rename2025.bat
    |
    v
Memo_Format03_38Columns.dtsx
    |
    v
sdbTDIR1_MemoApp.dbo.PaymentRequests_38Cols_ssis
    |
    v
sdbTDIR1_MemoApp source and scenario views
    |
    v
dswTDIR1.dbo.sp_Job_Memo_Preload
    |
    +--> refresh selected dgS4HANA_TDIR1 lookup tables
    |
    +--> stage source and assign scenarios
    |
    +--> generate Vendor / GL / VAT posting rows
    |
    +--> remediate and validate ttMEMOAPP_Preload
    |
    +--> export successful posting files
    |
    +--> refresh dswTDIR1_Cache report snapshots
    |
    +--> trigger SSRS subscriptions and email reports
    |
    +--> start Memo_Preload_P15_SFTP_AdHoc asynchronously
    |
    +--> start Memo_Preload_P17_Notif_Summary_AdHoc asynchronously
```
