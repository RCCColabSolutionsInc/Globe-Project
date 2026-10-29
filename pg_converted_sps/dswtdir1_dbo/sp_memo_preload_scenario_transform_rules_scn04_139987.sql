CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn04()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 29: */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4 = y.zscenario4
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4 IS NULL);
    /* 30: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario4_CountsUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4_counts = y.counts
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4_counts IS NULL);
    /* 31: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario4_Gross_Invoice_Amount_SumUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4_gross_invoice_amount_sum = y.zscenario4_gross_invoice_amount_sum
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4_gross_invoice_amount_sum IS NULL);
    /* 32: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario4_Counter_OrderByUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4_counter_orderby = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4_counter_orderby IS NULL);
    /* 33: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario4_zRowNumber_MinUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4_zrownumber_min = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4_zrownumber_min IS NULL);
    /* 34: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario4_zRowNumber_MaxUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario4_zrownumber_max = y.zrownumber_max
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario4_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario4_zrownumber_max IS NULL);
END;
$procedure$
