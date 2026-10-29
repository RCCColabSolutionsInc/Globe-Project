CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_billed_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trbayan_php_billed_zerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_php_billed_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_php_billed_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_php_billed_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
