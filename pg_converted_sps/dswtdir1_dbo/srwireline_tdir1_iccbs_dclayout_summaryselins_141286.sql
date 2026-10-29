CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summaryselins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 8/21/2020 5:29:23 PM
Description: Insert TDIR1_ICCBS into ttWireline
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttwireline (zlegacyzlineitemnumber, zvalue_03, zvalue_05, zvalue_08, zvalue_12, zvalue_15, zvalue_16, zvalue_21, zvalue_26, zvalue_eom, zactive, zduplicate, zvalue_03_input, zvalue_03_default, zvalue_03_formula, zvalue_03_checking, zvalue_03_checking_tier1c, zvalue_03_sum_gt_bt, zbillcycle_05, " zValue_EOM_SUM_GT_BT", zvalue_06_sum_gt_bt, zvalue_08_sum_gt_bt, zvalue_12_sum_gt_bt, zvalue_15_sum_gt_bt, zvalue_16_sum_gt_bt, zvalue_21_sum_gt_bt, zvalue_26_sum_gt_bt, zvalue_eom_sum_gt_bt, zvalue_cuml_sum_gt_bt, zvalue_cumulative_tier1, zvalue_cumulative_tier2, zvalue_cumulative_tier3, zvalue_cumulative_default, zvalue_cumulative, zsource)
    SELECT
        zlegacyzlineitemnumber, zvalue_03, zvalue_05, zvalue_08, zvalue_12, zvalue_15, zvalue_16, zvalue_21, zvalue_26, zvalue_eom, zactive, zduplicate, zvalue_03_input, zvalue_03_default, zvalue_03_formula, zvalue_03_checking, zvalue_03_checking_tier1c, zvalue_03_sum_gt_bt, zbillcycle_05, " zValue_EOM_SUM_GT_BT", zvalue_06_sum_gt_bt, zvalue_08_sum_gt_bt, zvalue_12_sum_gt_bt, zvalue_15_sum_gt_bt, zvalue_16_sum_gt_bt, zvalue_21_sum_gt_bt, zvalue_26_sum_gt_bt, zvalue_eom_sum_gt_bt, zvalue_cuml_sum_gt_bt, zvalue_cumulative_tier1, zvalue_cumulative_tier2, zvalue_cumulative_tier3, zvalue_cumulative_default, zvalue_cumulative, zsource
        FROM dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summaryselinssel;
END;
$procedure$
