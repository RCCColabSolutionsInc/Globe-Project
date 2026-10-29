CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_content_i_preload_sftp()
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
    var_FileKey := '01_txAPRM_CONTENT_ExportSel_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    /* Pull */
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
END;
$procedure$
