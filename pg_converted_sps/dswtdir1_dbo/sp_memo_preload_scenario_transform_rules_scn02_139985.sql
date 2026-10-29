CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn02()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 17: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2Upd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2 = y.zscenario2
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2 IS NULL);
    /* 18: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2_CountsUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2_counts = y.counts
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2_counts IS NULL);
    /* 19: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2_Gross_Invoice_Amount_SumUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2_gross_invoice_amount_sum = y.zscenario2_gross_invoice_amount_sum
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2_gross_invoice_amount_sum IS NULL);
    /* 20: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2_Counter_OrderByUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2_counter_orderby = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2_counter_orderby IS NULL);
    /* 21: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2_zRowNumber_MinUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2_zrownumber_min = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2_zrownumber_min IS NULL);
    /* 22: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario2_zRowNumber_MaxUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario2_zrownumber_max = y.zrownumber_max
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario2_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario2_zrownumber_max IS NULL);
END;
$procedure$
