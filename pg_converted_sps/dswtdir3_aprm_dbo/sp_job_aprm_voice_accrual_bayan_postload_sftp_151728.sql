CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_accrual_bayan_postload_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: July 20, 2023 */
/* Description: SFTP */
/* ============================================= */
DECLARE
    var_FileKey VARCHAR(200);
    var_FileDelKey VARCHAR(200);
BEGIN
    var_FileKey := '02_ICEXT_BYN_A_OUTPUT_pull';
    var_FileDelKey := '03_ICEXT_BYN_A_OUTPUT_Del';
    /* Pull */
    CALL etl_db_dbo.sp_sftp_sap_pull(var_FileKey);
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
END;
$procedure$
