CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postoad_dcs_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_ttmemoapp_dcs_postload_1upd();
    CALL dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_upd();
    CALL dswtdir1_dbo.trmemoapp_dcs_postload_zerror_message_upd();
END;
$procedure$
