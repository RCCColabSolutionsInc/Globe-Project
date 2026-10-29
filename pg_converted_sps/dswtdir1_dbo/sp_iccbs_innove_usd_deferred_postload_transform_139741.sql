CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_usd_deferred_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* More rules */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zerrorupd();
    /* Rule to check sum of 01 Amount matches 99 record sum */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
