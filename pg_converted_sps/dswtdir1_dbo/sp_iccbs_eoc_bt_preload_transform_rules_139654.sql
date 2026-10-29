CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_eoc_bt_preload_transform_rules()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.trwireline_bt_delete_from_dcwireline_bt_del();
    /* Delete_From_dcWireline_BT */
    CALL dswtdir1_dbo.trwireline_bt_insert_into_dcwireline_bt_ins()
    /* Insert_Into_dcWireline_BT All records from ttWireline_BT */
    ;
END;
$procedure$
