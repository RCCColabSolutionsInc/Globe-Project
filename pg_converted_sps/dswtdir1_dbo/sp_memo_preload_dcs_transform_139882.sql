CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Rules */
    CALL dswtdir1_dbo.trmemoapp_dcs_output_zloaded_ttmemoapp_dcs_postload_1del();
    CALL dswtdir1_dbo.trmemoapp_dcs_output_insert_from_memoapperrorpage_approvedrecords_ins();
END;
$procedure$
