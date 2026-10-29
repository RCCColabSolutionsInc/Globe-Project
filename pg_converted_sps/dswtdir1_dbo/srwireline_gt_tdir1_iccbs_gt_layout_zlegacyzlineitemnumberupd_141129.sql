CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zlegacyzlineitemnumberupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:25:10 PM
Specification: cMap:TDIR1_ICCBS:stWireline_GT_TDIR1_ICCBS_GT_Layout:GT_Layout:zLegacyzLineItemNumber
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layout_zlegacyzlineitemnumberupdsel
    SET zlegacyzlineitemnumber = zlegacyzlineitemnumbernew;
END;
$procedure$
