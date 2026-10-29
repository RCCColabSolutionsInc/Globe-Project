CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_03_defaultupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:19 PM
Specification: cMap:TDIR1_ICCBS:stWireline_BT_TDIR1_ICCBS_BT_Layout:BT_Layout:zValue_03_Default
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_03_defaultupdsel
    SET zvalue_03_default = zvalue_03_defaultnew;
END;
$procedure$
