CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_innove_php_unbilled_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_Innove_PHP_Unbilled_Del';
    var_FileKey := '01_Innove_PHP_Unbilled_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
