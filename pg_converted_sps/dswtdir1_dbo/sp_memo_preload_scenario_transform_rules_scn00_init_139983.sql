CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules_scn00_init()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 1: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zGL_Natural_Code_BoaPaddedUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zgl_natural_code_boapadded = (etl_db_dbo.fn_padstringwithcharacter(gl_natural_code, 0, 10))
        WHERE x.zgl_natural_code_boapadded IS NULL;
    /* 2: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zScenarioTable_InternalKeyUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zscenariotable_internalkey = (CONCAT(zinputfilename, '|', zrownumber, '|', COALESCE(accrual_doc_number, ''), '|', COALESCE(vat_code, ''), '|', COALESCE(invoice_number, ''), '|', COALESCE(vendor_code, '')))
        WHERE x.zscenariotable_internalkey IS NULL;
    /* 3: srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zLegacyzScenarioTable_InternalKeyUpd */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zlegacyzscenariotable_internalkey = (CONCAT(zinputfilename, '|', zrownumber, '|', COALESCE(accrual_doc_number, ''), '|', COALESCE(vat_code, ''), '|', COALESCE(invoice_number, ''), '|', COALESCE(vendor_code, '')))
        WHERE x.zlegacyzscenariotable_internalkey IS NULL;
    /* 4: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zSAKNR_SKA1_ScnInitialUpd] */
    /* Dependency: [dgS4HANA_TDIR1].[dbo].[SKA1] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zsaknr_ska1_scninitial = y.saknr
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zsaknr_ska1_scninitial IS NULL AND LOWER(y.ktopl) = LOWER('GLOB'));
    /* 5: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zTXT50_SKA1_ScnInitialUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET ztxt50_ska1_scninitial = y.txt50
    FROM dswtdir1_dbo.sttdir1_memoapp_skat AS y
        WHERE LOWER(x.zsaknr_ska1_scninitial) = LOWER(y.saknr) AND (x.ztxt50_ska1_scninitial IS NULL AND LOWER(y.ktopl) = LOWER('GLOB') AND LOWER(y.spras) = LOWER('E'));
    /* 6: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zXBILK_SKA1_ScnInitialUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zxbilk_ska1_scninitial = y.xbilk
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zxbilk_ska1_scninitial IS NULL AND LOWER(y.ktopl) = LOWER('GLOB'));
    /* 7: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zKTOKS_SKA1_ScnInitialUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zktoks_ska1_scninitial = y.ktoks
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zktoks_ska1_scninitial IS NULL AND LOWER(y.ktopl) = LOWER('GLOB'));
    /* 8: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zSKA1_GLACCOUNT_TYPE_ScnInitialUpd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zska1_glaccount_type_scninitial = y.glaccount_type
    FROM dswtdir1_dbo.sttdir1_memoapp_ska1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND (x.zska1_glaccount_type_scninitial IS NULL AND LOWER(y.ktopl) = LOWER('GLOB'));
    /* 9: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zXLOEB_SKB1_ScnInitial_SKB1_Fields_Upd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zmwskz_skb1_scninitial = y.mwskz, zxloeb_skb1_scninitial = y.xloeb, zxmwno_skb1_scninitial = y.xmwno, zxspeb_skb1_scninitial = y.xspeb
    FROM dswtdir1_dbo.skb1 AS y
        WHERE LOWER(x.zgl_natural_code_boapadded) = LOWER(y.saknr) AND LOWER(x.company_code) = LOWER(y.bukrs);
    /* 10: [srMEMOAPP_Scenario_TDIR1_MemoApp_MemoApp_Source_AllProponents_zKALSM_T007A_ScnInitial_T007A_Fields_Upd] */
    UPDATE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ssis AS x
    SET zkalsm_t007a_scninitial = y.kalsm, zmwart_t007a_scninitial = y.mwart, zmwskz_t007a_scninitial = y.mwskz
    FROM dswtdir1_dbo.t007a AS y
        WHERE LOWER(x.zmwskz_skb1_scninitial) = LOWER(y.mwskz) AND LOWER(y.kalsm) = LOWER('TAXPH');
END;
$procedure$
