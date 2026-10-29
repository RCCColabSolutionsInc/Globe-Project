CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_prepaid_reclass_sftp()
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
    /* First File */
    var_FileDelKey := '03_txPrepaid_JV_EG_Del';
    var_FileKey := '01_txPrepaid_JV_EGSel_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
    /* Execute export file */
    /* Second File */
    var_FileDelKey := '03_txPrepaid_JV_SG_Del';
    var_FileKey := '01_txPrepaid_JV_SGSel_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
