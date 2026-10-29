CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn01()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 11: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1Upd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1 = y.zscenario1
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1 IS NULL);
    /* 12: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_CountsUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1_counts = y.counts
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1_counts IS NULL);
    /* 13: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_Gross_Invoice_Amount_SumUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1_gross_invoice_amount_sum = y.zscenario1_gross_invoice_amount_sum
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1_gross_invoice_amount_sum IS NULL);
    /* 14: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_Counter_OrderByUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1_counter_orderby = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1_counter_orderby IS NULL);
    /* 15: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_zRowNumber_MinUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1_zrownumber_min = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1_zrownumber_min IS NULL);
    /* 16: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_zRowNumber_MaxUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario1_zrownumber_max = y.zrownumber_max
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario1_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario1_zrownumber_max IS NULL);
END;
$procedure$
