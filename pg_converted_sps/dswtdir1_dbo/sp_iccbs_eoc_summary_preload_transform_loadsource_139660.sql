CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_eoc_summary_preload_transform_loadsource()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Load datasource */
    TRUNCATE TABLE dswtdir1_dbo.stwireline_tdir1_iccbs_summary_layout;
    INSERT INTO dswtdir1_dbo.stwireline_tdir1_iccbs_summary_layout (lineitemnumber, zrownumber, reconciliationflag, tier_sum_gt_bt, tier_value, lineitemdescription, billcycle_value_detail, billcycle_03, billcycle_05, billcycle_06, billcycle_08, billcycle_12, billcycle_15, billcycle_16, billcycle_21, billcycle_26, billcycle_eom, billcycle_cumulative, cuml_value_detail, tier_cumulative)
    SELECT
        lineitemnumber AS lineitemnumber, zrownumber, reconciliationflag, tier_sum_gt_bt, tier_value, lineitemdescription, billcycle_value_detail, billcycle_03, billcycle_05, billcycle_06, billcycle_08, billcycle_12, billcycle_15, billcycle_16, billcycle_21, billcycle_26, billcycle_eom, billcycle_cumulative, cuml_value_detail, tier_cumulative
        FROM sdbtdir1_iccbs_dbo.summary_layout
        ORDER BY 1 NULLS FIRST;
    /* Datasource rules */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_zbillmonth_upd();
    /* Update zBillMonth in zParam_ICCBS based on zBillMonth_CustomValue and zBillMonth_Override for ttWireline_TOT */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_zbillmonth_using_startdate_upd();
    /* Update zBillMonth in zParam_ICCBS based on zBillMonthStartDate_CustomValue, zBillMonthStartDate and zBillMonthStartDate_Override along with zBillMonth_CustomValue and zBillMonth_Override for ttWireline_TOT. */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbillmonthupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zlegacyzlineitemnumberupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zlineitemnumberupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zreconciliationflagupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zreconrequpd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zrownumber_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zdescriptionupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_ztier_valueupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_ztier_cumulativeupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_ztier_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbillcycle_value_detailupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zcuml_value_detailupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_03_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_03upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_05_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_05upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_06_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_06upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_08_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_08upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_12_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_12upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_15_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_15upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_16_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_16upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_21_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_21upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_26_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_26upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_currentmonth_eom_upd();
    /* Set zBillCycle, zBillCycleNew and zBillMonth in zParam_ICCBS For given TargetTable */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_inputupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_checking_tier1cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_formula_tier1fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_formula_tier2fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_checking_tier2cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_checking_tier3cupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_formula_tier3fupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_formulaupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_checkingupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eom_defaultupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_eomupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier1upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier2upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier3upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier7upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier8upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_sum_gt_btupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cumlupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbilldate_eom_upd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbillrun_yearupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zinputfileprocessed_dateupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_boastatusupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_addedbyupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zactiveupd();
    /* */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layoutdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layoutins();
    /* Source to Target Insert */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_zbillmonth_override_reset_upd();
    /* Reset the zBillMonth_Override flag to 0 in zPARAM_ICCBS for TargetTable ttWireline_TOT */
    CALL dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zparam_iccbs_tot_zbillmonthstartdate_override_reset_upd()
    /* Reset the zBillMonthStartDate_Override flag to 0 in zPARAM_ICCBS for TargetTable ttWireline_TOT. */
    ;
END;
$procedure$
