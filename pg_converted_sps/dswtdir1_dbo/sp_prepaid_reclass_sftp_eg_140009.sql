CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_prepaid_reclass_sftp_eg()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 13, 2024 */
/* Description: SFTP for EG */
/* ============================================= */
DECLARE
    var_FileDelKey VARCHAR(200);
    var_FileKey VARCHAR(200);
BEGIN
    var_FileDelKey := '03_txPrepaid_JV_EG_Del';
    var_FileKey := '01_txPrepaid_JV_EGSel_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
