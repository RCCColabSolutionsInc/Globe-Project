CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_billed_data_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
/* EXEC sp_helptext 'sp_ICCBS_Bayan_PHP_Billed_Data_Postload_Transform' */
BEGIN
    /* Other rules */
    CALL dswtdir1_dbo.trbayan_php_billed_datazerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_php_billed_data_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_php_billed_data_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_php_billed_data_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
