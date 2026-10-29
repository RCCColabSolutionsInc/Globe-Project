CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_dp2_sftp_pg()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_txInnove_Unearned_MSF_Del';
    var_FileKey := '01_txInnove_Unearned_MSF_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del_pg(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push_pg(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
