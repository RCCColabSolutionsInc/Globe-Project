CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_dp3_sftp_pg()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_txInnove_Unbilled_Char_Del';
    var_FileKey := '01_txInnove_Unbilled_Char_Push';

    /* Delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);

    /* Execute export file */
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
END;
$procedure$
