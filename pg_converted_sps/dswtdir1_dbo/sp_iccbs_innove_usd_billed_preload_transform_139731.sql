CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_usd_billed_preload_transform()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    /* Data loading */
    CALL dswtdir1_dbo.sp_iccbs_innove_usd_billed_preload_transform01_volvofor();
    CALL dswtdir1_dbo.sp_iccbs_innove_usd_billed_preload_transform02_volvooss();
    /* Other transformations */
    CALL dswtdir1_dbo.trinnove_usd_billed_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.trinnove_usd_billed_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trinnove_usd_billed_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trinnove_usd_billed_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
