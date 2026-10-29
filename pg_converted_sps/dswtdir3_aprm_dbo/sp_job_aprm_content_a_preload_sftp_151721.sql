CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_content_a_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_txAPRM_CONTENT_Del';
    var_FileKey := '01_txAPRM_CONTENT_1st_ExportSel_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
