CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_sftp()
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
    var_FileDelKey := '03_txGlobe_DP4_Unbilled_Adj_Del';
    var_FileKey := '01_txGlobe_DP4_Unbilled_Adj_Push';
    /* delete previous files */
    CALL etl_db_dbo.sp_sftp_sap_del(var_FileDelKey);
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute export file */
    ;
END;
$procedure$
