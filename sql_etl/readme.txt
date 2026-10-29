SQL_ETL Repository Guide
========================

Purpose
-------
This repository is a source-code dump of SQL Server database objects used by the
Globe/MyBSS ETL and reporting processes. It is intended to provide context for
developers and AI agents working on the migration to AWS services.

Treat this repo as an inventory and analysis source, not as a ready-to-run
deployment package. Most files are generated SQL Server scripts with `USE`,
`SET`, `GO`, and `CREATE` statements. Validate dependencies, execution order,
credentials, and environment-specific settings before using any script against a
database.

Top-Level Structure
-------------------
Each top-level folder is a database or SQL Server configuration area.

- `sdbTDIR2_Globe`, `sdbTDIR2_Bayan`, `sdbTDIR2_Innove`
  Source/staging databases. These hold staging tables and supporting views or
  procedures for each business unit.

- `dswTDIR2_Globe`, `dswTDIR2_Bayan`, `dswTDIR2_Innove`
  Target/data-warehouse databases. These contain most transformation logic,
  report views, export views, validation views, and job orchestration stored
  procedures.

- `dswTDIR2_*_Cache`
  Cache databases for report/temp tables. These are usually populated during
  preload/postload report preparation.

- `dgS4HANA_TDIR1`
  SAP S/4HANA-facing database objects. Many objects mirror or expose SAP tables
  and reference data through `vw_RT_*` views and loader stored procedures.

- `etl_db`
  Shared ETL utility database. Includes helpers for SQL Agent job inspection,
  SFTP/file operations, report export, batch execution, and functions such as
  `fn_IsJobCompleted`.

- `ESTSS`
  Operational/support database for job schedules, reminders, file checks,
  migration status emails, and DSP/ESTSS reporting helpers.

- `Linked Servers`
  Linked-server configuration scripts. `SAP_S4.sql` contains the SAP S/4HANA
  linked server definition with credentials masked in parts of the export.

- `_docs`
  Documentation for the repository.

Approximate Object Inventory
----------------------------
Counts are based on the current dump and are useful for sizing search scope.

- Total SQL files: 3,041
- Views: 1,401
- Stored procedures: 940
- Tables: 684
- User-defined functions: 12
- DDL triggers: 3
- Linked server scripts: 1

Large folders:

- `dswTDIR2_Globe`: 897 SQL files
- `dswTDIR2_Bayan`: 580 SQL files
- `dswTDIR2_Innove`: 647 SQL files
- `dgS4HANA_TDIR1`: 197 SQL files
- `sdbTDIR2_*`: about 110-117 SQL files per business unit

File Naming Pattern
-------------------
Most files follow:

    <schema>.<object_name>.<object_type>.sql

Examples:

- `dbo.ttGlobe_DP4_Unbilled_Adj.Table.sql`
- `dbo.tvGlobe_DP1_Billed_Cycle1_Postload_ValidRptSel.View.sql`
- `dbo.sp_Job_MyBSS_Globe_EOM_Preload_All.StoredProcedure.sql`
- `dbo.fn_IsJobCompleted.UserDefinedFunction.sql`

Common suffixes:

- `.Table.sql` - table definition
- `.View.sql` - view definition
- `.StoredProcedure.sql` - stored procedure definition
- `.UserDefinedFunction.sql` - scalar/table function definition
- `.DdlTrigger.sql` - DDL trigger definition

Common Object Prefixes
----------------------
- `st*` - staging/source table
- `tt*` - transformed/target working table
- `rpt_*_Cache` - report cache table
- `tv*` / `vw*` - view, often report/query oriented
- `tx*` - export/load-file view
- `sp_*` - stored procedure
- `sp_Job_*` - SQL Agent job orchestration procedure
- `sr*` - rule/update/insert/delete support procedure or view for a specific
  source-to-target flow
- `tr*` - transform/update procedure or related selector view
- `boa*` - metadata/admin helper views
- `ZFFI_*`, `ZTF*`, `TCUR*`, `DD*`, `SK*`, `BS*` - SAP/reference objects

Business and Process Terms
--------------------------
Common business-unit names:

- `Globe`
- `Bayan`
- `Innove`

Common data-process names found in object names:

- `DP1_Billed` - billed charges/adjustments and bill-cycle reporting
- `DP2_Unearned` or `Unearned_MSF` - unearned revenue / MSF processing
- `DP3_Unbilled_Char` - unbilled charges
- `DP4_Unbilled_Adj` - unbilled adjustments
- `DP5_Unconfirmed` - unconfirmed charges, MSF, or adjustments

Common run phases:

- `Preload` - preparation/validation before SAP or downstream posting
- `Postload` - validation/reporting after load/posting
- `EOM` - end-of-month processing
- `EOC` - end-of-cycle processing
- `Report`, `Rpt`, `SSRS` - report preparation or report result selection
- `SFTP`, `Export`, `LoadFile` - file transfer/export workflows

How To Search This Repo
-----------------------
Use exact object names when possible. Many dependencies are embedded in view and
procedure bodies rather than declared in a separate manifest.

Recommended searches:

    rg -a "ttGlobe_DP4_Unbilled_Adj"
    rg -a "sp_Job_MyBSS_Globe_EOM_Preload_All"
    rg -a "SAP_S4|OPENQUERY|sp_start_job|xp_cmdshell"
    rg --files | rg "Globe.*DP4.*Unbilled_Adj"

Notes for AI agents and dev tools:

- Many `.sql` files are UTF-16 little-endian with CRLF line endings. If `sed` or
  a terminal shows NUL characters between letters, convert for reading:

      iconv -f UTF-16LE -t UTF-8 path/to/file.sql

- `rg -a` is useful when searching SQL dumps that tools may classify as binary.
- The SQL scripts are not guaranteed to be dependency-ordered. Search referenced
  objects before proposing a deployment or refactor order.
- Check both database-level folders and shared folders. For example, a Globe
  procedure may call `etl_db.dbo.*`, `msdb.dbo.*`, SAP reference objects, or
  linked-server objects.

Migration Notes
---------------
For AWS migration analysis, pay close attention to:

- SQL Server-specific batch syntax: `GO`, `USE`, `SET ANSI_NULLS`,
  `SET QUOTED_IDENTIFIER`
- SQL Server Agent dependencies: `msdb.dbo.sp_start_job`, job names, job status
  checks, and `etl_db.dbo.fn_IsJobCompleted`
- Linked server dependencies: `SAP_S4`, `OPENQUERY`, and ODBC/SAP DSN settings
- File-system and shell dependencies: `xp_cmdshell`, batch-file execution,
  SFTP helpers, and export procedures
- Reporting dependencies: cache tables, SSRS procedures, `RptSel` views, and
  report-export procedures
- Environment-specific values: server names, DSNs, paths, database names,
  credentials, and email/send-mail settings

Safety Guidance
---------------
- Do not assume any script is safe to execute in production as-is.
- Do not commit or reintroduce real credentials. Some linked-server exports have
  masked passwords, but connection strings and account names may still be
  environment-sensitive.
- When changing SQL, preserve object names unless the migration plan explicitly
  includes renaming. Many objects are referenced by generated file names, SQL
  Agent jobs, reports, and downstream file workflows.
- When modernizing or translating logic, document any behavior change around
  numeric parsing, date parsing, load flags, duplicate flags, and report filters.
