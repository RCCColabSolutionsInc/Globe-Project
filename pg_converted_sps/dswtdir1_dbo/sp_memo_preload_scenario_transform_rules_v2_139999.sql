CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_v2()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIR1 */
BEGIN
    /* Orig */
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zGL_Natural_Code_BoaPaddedUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zgl_natural_code_boapadded = (dsw_dbo.boapad(x_dml.gl_natural_code, 0, 10))
        WHERE (x.zgl_natural_code_boapadded IS NULL);
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenarioTable_InternalKeyUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zscenariotable_internalkey = (CONCAT(zinputfilename, '|', zrownumber, '|', COALESCE(accrual_doc_number, ''), '|', COALESCE(vat_code, ''), '|', COALESCE(invoice_number, ''), '|', COALESCE(vendor_code, '')))
        WHERE (x.zscenariotable_internalkey IS NULL);
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zLegacyzScenarioTable_InternalKeyUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zlegacyzscenariotable_internalkey = (CONCAT(zinputfilename, '|', zrownumber, '|', COALESCE(accrual_doc_number, ''), '|', COALESCE(vat_code, ''), '|', COALESCE(invoice_number, ''), '|', COALESCE(vendor_code, '')))
        WHERE (x.zlegacyzscenariotable_internalkey IS NULL);
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zSAKNR_SKA1_ScnInitialUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zsaknr_ska1_scninitial = y.saknr
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zsaknr_ska1_scninitial IS NULL) AND LOWER(ktopl) = LOWER('GLOB');
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zTXT50_SKA1_ScnInitialUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET ztxt50_ska1_scninitial = y.txt50
    FROM dswtdir1_dbo.sttdir1_memoapp_skat AS y
        WHERE LOWER(x.zsaknr_ska1_scninitial) = LOWER(y.saknr) AND (x.ztxt50_ska1_scninitial IS NULL) AND LOWER(ktopl) = LOWER('GLOB') AND LOWER(spras) = LOWER('E');
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zXBILK_SKA1_ScnInitialUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zxbilk_ska1_scninitial = y.xbilk
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zxbilk_ska1_scninitial IS NULL) AND LOWER(ktopl) = LOWER('GLOB');
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zKTOKS_SKA1_ScnInitialUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zktoks_ska1_scninitial = y.ktoks
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zktoks_ska1_scninitial IS NULL) AND LOWER(ktopl) = LOWER('GLOB');
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zSKA1_GLACCOUNT_TYPE_ScnInitialUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zska1_glaccount_type_scninitial = y.glaccount_type
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zska1_glaccount_type_scninitial IS NULL) AND LOWER(ktopl) = LOWER('GLOB');
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zXLOEB_SKB1_ScnInitial_SKB1_Fields_Upd] --R2 Manual Rule to update SKB1 fields zMWSKZ_SKB1_ScnInitial, zXMWNO_SKB1_ScnInitial, zXLOEB_SKB1_ScnInitial, zXSPEB_SKB1_ScnInitial. */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zmwskz_skb1_scninitial = y.mwskz, zxmwno_skb1_scninitial = y.xmwno, zxloeb_skb1_scninitial = y.xloeb, zxspeb_skb1_scninitial = y.xspeb
    FROM dswtdir1_dbo.skb1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND LOWER(x.company_code) = LOWER(y.bukrs);
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zKALSM_T007A_ScnInitial_T007A_Fields_Upd] --R2 Manual rule to update T007A fields zKALSM_T007A_ScnInitial, zMWSKZ_T007A_ScnInitial, zMWART_T007A_ScnInitial. */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zkalsm_t007a_scninitial = y.kalsm, zmwskz_t007a_scninitial = y.mwskz, zmwart_t007a_scninitial = y.mwart
    FROM dswtdir1_dbo.t007a AS y
        WHERE LOWER(y.kalsm) = LOWER('TAXPH') AND LOWER(y.mwskz) = LOWER(zmwskz_skb1_scninitial);
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1Upd] -- */
    /* AI */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zscenario1 = y.zscenario1
    FROM dswtdir1_dbo.sttdir1_memoapp_memoapp_source_allproponents_scenario1 AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND x.zscenario1 IS NULL;
    /* EXEC [dbo].[srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenario1_CountsUpd] -- */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_v2 AS x
    SET zscenario1_counts = y.counts
    FROM dswtdir1_dbo.sttdir1_memoapp_memoapp_source_allproponents_scenario1 AS y
        WHERE LOWER(x.zinputfilename) = LOWER(y.zinputfilename) AND x.zrownumber = y.zrownumber AND x.zscenario1_counts IS NULL;
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario2_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario3_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario4_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario5_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario6_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8rupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_input_vat_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8r_vat_code_categupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8mupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_input_vat_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario8m_vat_code_categupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_input_vat_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario9_vat_code_categupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_gross_invoice_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_input_vat_amount_sumupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario10_vat_code_categupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario_scninitialupd();
    /* Autogenerated for R2. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario_counter_orderby_scninitialupd();
    /* Autogenerated for R2. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario_zrownumber_min_scninitialupd();
    /* Autogenerated for R2. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario_zrownumber_max_scninitialupd();
    /* Autogenerated for R2. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario_counts_scninitialupd();
    /* Autogenerated for R2. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zcounter_scninitialupd();
    /* For for Scenarios 1 to 5, update zCounter_ScnInitial with (dense_Rank() over(order by zScenario_ScnInitial, zScenario_Counter_OrderBy_ScnInitial, zInputFileName)) */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zcounter_scninitial_custom_upd();
    /* For for Scenarios 1 to 5, Overwrite zCounter_ScnInitial to use YDDD with last 6 digits of counter to handle 999999 counters per processing while maintaining uniqueness on DCS. Inactivate trMEMOAPP_Preload_zCounter_CustomUpdSel. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zcounter_scninitial_scn6_upd();
    /* For Scenario6, Update zCounter_ScnInitial explicitly to handle different counters New Accrual Doc lines. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zcounterlineitem_scninitialupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invoice_dateupd();
    /* Update Invoice Date to Trim Timestamp */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_invalidlength_r2_del();
    /* Delete Invalid Length Records including entire counter - R2 Rule */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponentsdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponentsins()
    /* Source to Target Insert */
    ;
END;
$procedure$
