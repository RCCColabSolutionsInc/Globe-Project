CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_delta_innove_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Jul 24, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    /* File 1 */
    var_FileDelKey := '03_ICEXT_Voice_Innove_Delta_PosAmnt_Del';
    var_FileKey := '01_ICEXT_Voice_Innove_Delta_PosAmnt_Push';
    /* Delete previous files and push new file */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
    /* Execute export file */
    /* File 2 */
    var_FileDelKey := '03_ICEXT_Voice_Innove_Delta_NegAmnt_Del';
    var_FileKey := '01_ICEXT_Voice_Innove_Delta_NegAmnt_Push';
    /* Delete previous files and push new file */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
