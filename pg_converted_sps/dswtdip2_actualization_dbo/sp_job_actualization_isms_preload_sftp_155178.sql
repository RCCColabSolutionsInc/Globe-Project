CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_job_actualization_isms_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIP2_Actualization */
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: July 27, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_Actualization_ISMS_ZF_OPENBAL_Del';
    var_FileKey := '01_Actualization_ISMS_ZF_OPENBAL_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
