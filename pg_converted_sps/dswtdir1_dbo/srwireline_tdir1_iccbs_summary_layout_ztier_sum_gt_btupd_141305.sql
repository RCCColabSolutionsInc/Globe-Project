CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_ztier_sum_gt_btupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:28:21 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_Summary_Layout:Summary_Layout:zTier_Sum_GT_BT
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_ztier_sum_gt_btupdsel
    SET ztier_sum_gt_bt = ztier_sum_gt_btnew;
END;
$procedure$
