CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trmemoapp_postload_deleteallrecordsdel();
    CALL dswtdir1_dbo.trmemoapp_postload_insert_from_preloadvalid_ins();
    CALL dswtdir1_dbo.trmemoapp_postload_zloaded_pipe_upd();
    CALL dswtdir1_dbo.trmemoapp_postload_zerror_message_upd();
    CALL dswtdir1_dbo.trmemoapp_postload_insert_into_dcmemoapp_ins();
    CALL dswtdir1_dbo.trmemoapp_postload_zerror_load_counter_dcs_upd();
    CALL dswtdir1_dbo.trmemoapp_postload_zloaded_fromdcs_upd();
    CALL dswtdir1_dbo.trmemoapp_postload_zerrormessage_load_dcs_upd();
END;
$procedure$
