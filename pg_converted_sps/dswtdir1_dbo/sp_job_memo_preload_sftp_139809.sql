CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_FileKey VARCHAR(200);
BEGIN
    /*
    DECLARE @FileDelKey NVARCHAR(200);
    
    SET @FileDelKey = '03_OB_Scn_WithTax_Del';
    EXEC [etl_db].[dbo].[sp_sftp_sap_del] @FileDelKey -- Execute sftp
    
    SET @FileDelKey = '03_OB_Scn_NoTax_Del';
    EXEC [etl_db].[dbo].[sp_sftp_sap_del] @FileDelKey -- Execute sftp
    */
    var_FileKey := '01_OB_Scn_WithTax_Push';
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey);
    /* Execute sftp */
    var_FileKey := '01_OB_Scn_NoTax_Push';
    CALL etl_db_dbo.sp_sftp_sap_push(var_FileKey)
    /* Execute sftp */
    ;
END;
$procedure$
