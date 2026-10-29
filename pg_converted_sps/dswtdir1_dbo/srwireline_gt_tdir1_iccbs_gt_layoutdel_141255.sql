CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layoutdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 9/8/2020 11:25:07 PM
Description: Insert TDIR1_ICCBS into ttWireline_GT
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srwireline_gt_tdir1_iccbs_gt_layoutdelsel;
END;
$procedure$
