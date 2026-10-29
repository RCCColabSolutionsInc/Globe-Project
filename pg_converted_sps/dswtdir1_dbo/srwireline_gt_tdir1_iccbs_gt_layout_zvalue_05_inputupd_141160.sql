CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zvalue_05_inputupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:10 PM
Specification: cMap:TDIR1_ICCBS:stWireline_GT_TDIR1_ICCBS_GT_Layout:GT_Layout:zValue_05_Input
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zvalue_05_inputupdsel
    SET zvalue_05_input = zvalue_05_inputnew;
END;
$procedure$
