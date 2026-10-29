CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zvalue_08_defaultupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:10 PM
Specification: cMap:TDIR1_ICCBS:stWireline_GT_TDIR1_ICCBS_GT_Layout:GT_Layout:zValue_08_Default
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zvalue_08_defaultupdsel
    SET zvalue_08_default = zvalue_08_defaultnew;
END;
$procedure$
