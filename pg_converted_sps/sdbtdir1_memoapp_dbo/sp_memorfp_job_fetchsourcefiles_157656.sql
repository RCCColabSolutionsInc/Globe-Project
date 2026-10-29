CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_job_fetchsourcefiles()
 LANGUAGE plpgsql
AS $procedure$
/* #endregion */
/* #region sp_MemoRFP_Job_FetchSourceFiles */
/* ============================================= */
/* Author:		Windstoner */
/* Create date: March 2, 2024 */
/* Description:	Fetch the uploaded file from staging directory to the final source directory by calling a batch file. */
/* Updated: August 2025 - use new batch file */
/* ============================================= */
DECLARE
    var_Path VARCHAR(200) DEFAULT E'F:\\Scripts';
    var_Filename VARCHAR(200) DEFAULT 'memoapp_file_rename2025.bat';
BEGIN
    CALL etl_db_dbo.sp_execbatchfile(var_Path, var_Filename);
END;
$procedure$
