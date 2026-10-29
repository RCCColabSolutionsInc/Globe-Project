CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn03()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 23: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3Upd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3 = y.zscenario3
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3 IS NULL);
    /* 24: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3_CountsUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3_counts = y.counts
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3_counts IS NULL);
    /* 25: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3_Gross_Invoice_Amount_SumUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3_gross_invoice_amount_sum = y.zscenario3_gross_invoice_amount_sum
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3_gross_invoice_amount_sum IS NULL);
    /* 26: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3_Counter_OrderByUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3_counter_orderby = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3_counter_orderby IS NULL);
    /* 27: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3_zRowNumber_MinUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3_zrownumber_min = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3_zrownumber_min IS NULL);
    /* 28: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario3_zRowNumber_MaxUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario3_zrownumber_max = y.zrownumber_max
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario3_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario3_zrownumber_max IS NULL);
END;
$procedure$
