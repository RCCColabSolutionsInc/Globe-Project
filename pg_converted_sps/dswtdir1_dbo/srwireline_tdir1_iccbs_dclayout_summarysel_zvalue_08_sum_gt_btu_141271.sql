CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zvalue_08_sum_gt_btu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 8/21/2020 5:29:25 PM
Specification: cMap:TDIR1_ICCBS:stTDIR1_ICCBS_stTDIR1_ICCBS_Totals_All_Values_SUM_GT_BT_AmountsSel:stTDIR1_ICCBS_Totals_All_Values_SUM_GT_BT_AmountsSel:zValue_08_SUM_GT_BT
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zvalue_08_sum_gt_btupdsel
    SET zvalue_08_sum_gt_bt = zvalue_08_sum_gt_btnew;
END;
$procedure$
