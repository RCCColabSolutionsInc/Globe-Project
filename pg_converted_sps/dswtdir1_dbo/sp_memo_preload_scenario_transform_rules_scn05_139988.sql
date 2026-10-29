CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn05()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 35 EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5Upd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5 = y.zscenario5
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5 IS NULL);
    /* 36: EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5_CountsUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5_counts = y.counts
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5_counts IS NULL);
    /* 37: EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5_Gross_Invoice_Amount_SumUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5_gross_invoice_amount_sum = y.zscenario5_gross_invoice_amount_sum
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5_gross_invoice_amount_sum IS NULL);
    /* 38: EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5_Counter_OrderByUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5_counter_orderby = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5_counter_orderby IS NULL);
    /* 39: EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5_zRowNumber_MinUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5_zrownumber_min = y.zrownumber_min
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5_zrownumber_min IS NULL);
    /* 40: EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario5_zRowNumber_MaxUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenario5_zrownumber_max = y.zrownumber_max
    FROM dswtdir1_dbo.vw_sttdir1_memoapp_memoapp_source_allproponents_scenario5_ssis AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND (x.zscenario5_zrownumber_max IS NULL);
END;
$procedure$
