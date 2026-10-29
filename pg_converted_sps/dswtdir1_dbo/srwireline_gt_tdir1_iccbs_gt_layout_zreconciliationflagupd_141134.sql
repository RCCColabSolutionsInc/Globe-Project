CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zreconciliationflagupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:10 PM
Specification: cMap:TDIR1_ICCBS:stWireline_GT_TDIR1_ICCBS_GT_Layout:GT_Layout:zReconciliationFlag
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zreconciliationflagupdsel
    SET zreconciliationflag = zreconciliationflagnew;
END;
$procedure$
