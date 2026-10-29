CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform_rules()
 LANGUAGE plpgsql
AS $procedure$
/* use dswTDIR1 */
BEGIN
    /* Refactored */
    
    /*
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn00_Init];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn01];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn02];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn03];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn04];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn05];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn06];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn08_0_M];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn08_0_R];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn09];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn10];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn20_Finalize];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn25_Del_InvalidLength];
    
    EXEC [sp_Memo_Preload_Scenario_Transform_Rules_Scn30_Ins_FinalTable];
    */
    /* Orig */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zgl_natural_code_boapaddedupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenariotable_internalkeyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zlegacyzscenariotable_internalkeyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zsaknr_ska1_scninitialupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_ztxt50_ska1_scninitialupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zxbilk_ska1_scninitialupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zktoks_ska1_scninitialupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zska1_glaccount_type_scninitialupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zxloeb_skb1_scninitial_skb1_fields_upd();
    /* R2 Manual Rule to update SKB1 fields zMWSKZ_SKB1_ScnInitial, zXMWNO_SKB1_ScnInitial, zXLOEB_SKB1_ScnInitial, zXSPEB_SKB1_ScnInitial. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zkalsm_t007a_scninitial_t007a_fields_upd();
    /* R2 Manual rule to update T007A fields zKALSM_T007A_ScnInitial, zMWSKZ_T007A_ScnInitial, zMWART_T007A_ScnInitial. */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zscenario1_countsupd();
    /* */
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
