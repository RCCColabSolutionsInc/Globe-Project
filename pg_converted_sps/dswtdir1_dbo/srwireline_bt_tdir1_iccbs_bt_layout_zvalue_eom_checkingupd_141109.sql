CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_eom_checkingupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:19 PM
Specification: cMap:TDIR1_ICCBS:stWireline_BT_TDIR1_ICCBS_BT_Layout:BT_Layout:zValue_EOM_checking
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_eom_checkingupdsel
    SET zvalue_eom_checking = zvalue_eom_checkingnew;
END;
$procedure$
