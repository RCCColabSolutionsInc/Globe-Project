CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_cuml_tier1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:19 PM
Specification: cMap:TDIR1_ICCBS:stWireline_BT_TDIR1_ICCBS_BT_Layout:BT_Layout:zValue_Cuml_Tier1
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layout_zvalue_cuml_tier1updsel
    SET zvalue_cuml_tier1 = zvalue_cuml_tier1new;
END;
$procedure$
