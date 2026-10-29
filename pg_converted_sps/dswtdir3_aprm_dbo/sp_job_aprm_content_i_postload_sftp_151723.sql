CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_content_i_postload_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_FileKey VARCHAR(200);
BEGIN
    /* DECLARE @FileDelKey NVARCHAR(200); */
    var_FileKey := '02_CNTEXT_I_OUTPUT_pull';
    /* SET @FileDelKey = '03_CNTEXT_I_OUTPUT_Del'; */
    /* Pull */
    CALL etl_db_dbo.sp_sftp_sap_pull(var_FileKey);
    /* delete previous files */
    /* EXEC [etl_db].[dbo].[sp_sftp_sap_del] @FileDelKey; */
END;
$procedure$
