CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_deferred_data_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Other rules */
    CALL dswtdir1_dbo.trbayan_php_deferred_datazerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_php_deferred_data_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_php_deferred_data_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_php_deferred_data_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
