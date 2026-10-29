CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_bayan_php_billed_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_Bayan_PHP_Billed2_Del';
    var_FileKey := '01_Bayan_PHP_Billed2_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
