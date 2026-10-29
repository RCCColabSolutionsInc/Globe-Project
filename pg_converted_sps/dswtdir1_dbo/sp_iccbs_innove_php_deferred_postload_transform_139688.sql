CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_deferred_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* More rules */
    CALL dswtdir1_dbo.trinnove_php_deferred_zerrorupd();
    /* zError to indicate the sum of amount for 01 records equal to 99 record amount */
    CALL dswtdir1_dbo.trinnove_php_deferred_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
