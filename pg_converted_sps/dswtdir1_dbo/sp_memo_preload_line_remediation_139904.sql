CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_remediation()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 10 zError_SAKNR_SKA1_GL_NotCreatedInCOA */
    UPDATE dswtdir1_dbo.ttmemoapp_preload AS x
    SET zerror_saknr_ska1_gl_notcreatedincoa = 1
    FROM dswtdir1_dbo.ttmemoapp_preload AS x_dml
    LEFT OUTER JOIN dswtdir1_dbo.ska1 AS y
        ON LOWER(dsw_dbo.boatrimleadingzeros(x_dml.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(y.saknr)) AND LOWER(y.ktopl) = LOWER('GLOB')
        WHERE zvendor_gl_acct IS NOT NULL AND x.ZSOURCE = x_dml.ZSOURCE AND x.ZLEGACYZDSP_UNIQUEKEY = x_dml.ZLEGACYZDSP_UNIQUEKEY AND saknr IS NULL AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 20 zError_XSPEA_SKA1_GL_BlockedForCreation */
    UPDATE dswtdir1_dbo.ttmemoapp_preload AS x
    SET zerror_xspea_ska1_gl_blockedforcreation = 1
    FROM dswtdir1_dbo.ska1 AS y
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(x_dml.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(y.saknr)) AND LOWER(y.xspea) = LOWER('X') AND LOWER(x.zsource) NOT LIKE LOWER('%Vendor%');
    /* 30 zError_XSPEB_SKA1_GL_BlockedForPosting -- tvMEMOAPP_Preload_zError_XSPEB_SKA1_GL_BlockedForPosting_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_xspeb_ska1_gl_blockedforposting = 1
    FROM dswtdir1_dbo.ska1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(ska1.saknr)) AND LOWER(ska1.xspeb) = LOWER('X') AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 40 zError_XLOEV_SKA1_GL_MarkedForDeletion -- tvMEMOAPP_Preload_zError_XLOEV_SKA1_GL_MarkedForDeletion_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_xloev_ska1_gl_markedfordeletion = 1
    FROM dswtdir1_dbo.ska1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(ska1.saknr)) AND LOWER(ska1.xloev) = LOWER('X') AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 50 zError_SAKNR_SKB1_GL_NotCreated -- tvMEMOAPP_Preload_zError_SAKNR_SKB1_GL_NotCreated_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_saknr_skb1_gl_notcreated = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.skb1
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(skb1.saknr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(skb1.bukrs)
        WHERE LOWER(COALESCE(skb1.saknr, '')) = LOWER('') AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 60 zError_BUKRS_SKB1_GL_NotExtendedToCocd -- tvMEMOAPP_Preload_zError_BUKRS_SKB1_GL_NotExtendedToCocd_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_bukrs_skb1_gl_notextendedtococd = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.skb1
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(skb1.saknr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(skb1.bukrs)
        WHERE zvendor_gl_acct IS NOT NULL AND skb1.saknr IS NULL AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 70 zError_XSPEB_SKB1_GL_BlockedForPosting -- tvMEMOAPP_Preload_zError_XSPEB_SKB1_GL_BlockedForPosting_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_xspeb_skb1_gl_blockedforposting = 1
    FROM dswtdir1_dbo.skb1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(skb1.saknr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(skb1.bukrs) AND LOWER(skb1.xspeb) = LOWER('X') AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 80 zError_XLOEB_SKB1_GL_MarkedForDeletion -- tvMEMOAPP_Preload_zError_XLOEB_SKB1_GL_MarkedForDeletion_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_xloeb_skb1_gl_markedfordeletion = 1
    FROM dswtdir1_dbo.skb1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_gl_acct)) = LOWER(dsw_dbo.boatrimleadingzeros(skb1.saknr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(skb1.bukrs) AND LOWER(skb1.xloeb) = LOWER('X') AND LOWER(zsource) NOT LIKE LOWER('%Vendor%');
    /* 90 zError_LIFNR_LFB1_Vendor_NotCreated -- tvMEMOAPP_Preload_zError_LIFNR_LFB1_Vendor_NotCreated_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_lifnr_lfb1_vendor_notcreated = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.lfb1
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.lifnr))
        WHERE LOWER(COALESCE(lfb1.lifnr, '')) = LOWER('') AND LOWER(zsource) LIKE LOWER('%Vendor%');
    /* 100 zError_LIFNR_LFB1_Vendor_NotCreated -- tvMEMOAPP_Preload_zError_BUKRS_LFB1_Vendor_NotExtendedToCocd_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_lifnr_lfb1_vendor_notcreated = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.lfb1
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.lifnr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(lfb1.bukrs)
        WHERE lfb1.lifnr IS NULL AND LOWER(zsource) LIKE LOWER('%Vendor%');
    /* 110 zError_SPERR_LFB1_Vendor_BlockedForPosting -- tvMEMOAPP_Preload_zError_SPERR_LFB1_Vendor_BlockedForPosting_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_sperr_lfb1_vendor_blockedforposting = 1
    FROM dswtdir1_dbo.lfb1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.lifnr)) AND LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcocd)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.bukrs)) AND LOWER(lfb1.sperr) = LOWER('X') AND LOWER(zsource) LIKE LOWER('%Vendor%');
    /* 120 zError_LOEVM_LFB1_Vendor_MarkedForDeletion -- tvMEMOAPP_Preload_zError_LOEVM_LFB1_Vendor_MarkedForDeletion_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_loevm_lfb1_vendor_markedfordeletion = 1
    FROM dswtdir1_dbo.lfb1
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.lifnr)) AND LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcocd)) = LOWER(dsw_dbo.boatrimleadingzeros(lfb1.bukrs)) AND LOWER(lfb1.loevm) = LOWER('X') AND LOWER(zsource) LIKE LOWER('%Vendor%')
        /* -- winds enhancements 10/16/2023 */
    ;
    /* 130 zError_PayMethod_Invalid -- tvMEMOAPP_Preload_zError_ZWELS_LFB1_PaymentMethod_Invalid_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_paymethod_invalid = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.t042z
        ON LOWER(ttmemoapp_preload.zpayment_method) = LOWER(t042z.zlsch) AND LOWER(land1) = LOWER('PH')
        WHERE ttmemoapp_preload.zpayment_method IS NOT NULL AND t042z.zlsch IS NULL AND LOWER(zsource) LIKE LOWER('%Vendor%') AND LOWER(zsource) NOT IN (LOWER('Scenario6_NewAccDoc_GL'), LOWER('Scenario6_NewAccDoc_Vendor'));
    /* 140 zError_PayTerm_Invalid -- tvMEMOAPP_Preload_zError_ZTERM_LFB1_PaymentTerm_Invalid_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_payterm_invalid = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.tvzbt
        ON LOWER(ttmemoapp_preload.zpayt) = LOWER(tvzbt.zterm) AND LOWER(spras) = LOWER('E')
        WHERE ttmemoapp_preload.zpayt IS NOT NULL AND tvzbt.zterm IS NULL AND LOWER(zsource) LIKE LOWER('%Vendor%');
    /* 170 zError_WITHT_LFBW_WHTType_NotMaintainedForVendorCocd -- tvMEMOAPP_Preload_zError_WITHT_LFBW_WHTType_NotMaintainedForVendorCocd_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_witht_lfbw_whttype_notmaintainedforvendorcocd = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.lfbw
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfbw.lifnr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(lfbw.bukrs) AND LOWER(ttmemoapp_preload.zwithholding_tax_type) = LOWER(lfbw.witht)
        WHERE LOWER(zsource) LIKE LOWER('%Vendor%') AND zwithholding_tax_type IS NOT NULL AND LOWER(zwithholding_tax_type) <> LOWER('') AND witht IS NULL;
    /* 180  zError_WT_WITHC_LFBW_WHTCode_NotMaintainedForVendorCocd -- tvMEMOAPP_Preload_zError_WT_WITHC_LFBW_WHTCode_NotMaintainedForVendorCocd_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_wt_withc_lfbw_whtcode_notmaintainedforvendorcocd = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.lfbw
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(lfbw.lifnr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(lfbw.bukrs) AND LOWER(ttmemoapp_preload.zwitholding_tax_code) = LOWER(lfbw.wt_withcd)
        WHERE ttmemoapp_preload.zwitholding_tax_code IS NOT NULL AND lfbw.wt_withcd IS NULL AND
        /* and ISNULL(zLegacyzInvoice_Number, '') = '' */
        LOWER(zsource) LIKE LOWER('%Vendor%') AND LOWER(zwitholding_tax_code) <> LOWER('') AND LOWER(zsource) NOT IN (LOWER('Scenario6_NewAccDoc_GL'), LOWER('Scenario6_NewAccDoc_Vendor'));
    /* 190 zError_KOSTL_CSKS_CostCenter_NotCreated -- tvMEMOAPP_Preload_zError_KOSTL_CSKS_CostCenter_NotCreated_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_kostl_csks_costcenter_notcreated = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.csks
        ON LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcost_ctr)) = LOWER(dsw_dbo.boatrimleadingzeros(csks.kostl))
        WHERE csks.kostl IS NULL AND LOWER(COALESCE(ttmemoapp_preload.zcost_ctr, '')) != LOWER('');
    /* 200 zError_KOSTL_CSKS_CostCenter_NotCreatedForCocd -- tvMEMOAPP_Preload_zError_KOSTL_CSKS_CostCenter_NotCreatedForCocd_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_kostl_csks_costcenter_notcreatedforcocd = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.csks
        ON LOWER(ttmemoapp_preload.zcocd) = LOWER(csks.bukrs) AND LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcost_ctr)) = LOWER(dsw_dbo.boatrimleadingzeros(csks.kostl))
        WHERE csks.kostl IS NULL AND LOWER(zsource) NOT LIKE LOWER('%Vendor%') AND LOWER(zcost_ctr) <> LOWER('');
    /* 210 zError_KOSTL_CSKS_CostCenter_InvalidDateRange -- tvMEMOAPP_Preload_zError_KOSTL_CSKS_CostCenter_InvalidDateRange_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_kostl_csks_costcenter_invaliddaterange = 1
    FROM dswtdir1_dbo.csks
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcost_ctr)) = LOWER(dsw_dbo.boatrimleadingzeros(csks.kostl)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(csks.bukrs) AND LOWER(csks.datbi) NOT LIKE LOWER('%9999%') AND LOWER(csks.bkzkp) = LOWER('') AND LOWER(COALESCE(zlegacyzinvoice_number, '')) = LOWER('');
    /* 220 zError_BKZKP_CSKS_CostCenter_BlockedForPosting -- tvMEMOAPP_Preload_zError_BKZKP_CSKS_CostCenter_BlockedForPosting_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_bkzkp_csks_costcenter_blockedforposting = 1
    FROM dswtdir1_dbo.csks
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcost_ctr)) = LOWER(dsw_dbo.boatrimleadingzeros(csks.kostl)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(csks.bukrs) AND LOWER(csks.bkzkp) = LOWER('X') AND datbi BETWEEN '99990101' AND '99991231' AND LOWER(COALESCE(zlegacyzinvoice_number, '')) = LOWER('');
    /* 240 zError_PHAS3_AUFK_InternalOrder_ClosedForPosting -- tvMEMOAPP_Preload_zError_PHAS3_AUFK_InternalOrder_ClosedForPosting_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_phas3_aufk_internalorder_closedforposting = 1
    FROM dswtdir1_dbo.aufk
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zorder)) = LOWER(dsw_dbo.boatrimleadingzeros(aufk.aufnr)) AND LOWER(ttmemoapp_preload.zcocd) = LOWER(aufk.bukrs) AND LOWER(aufk.phas3) = LOWER('X');
    /* 250 zError_PSPNR_PRPS_WBSElementNotCreated -- tvMEMOAPP_Preload_zError_PSPNR_PRPS_WBSElementNotCreated_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_pspnr_prps_wbselementnotcreated = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.prps
        ON LOWER(ttmemoapp_preload.zcocd) = LOWER(prps.pbukr) AND LOWER(ttmemoapp_preload.zwbs_element) = LOWER(prps.posid)
        WHERE LOWER(COALESCE(ttmemoapp_preload.zwbs_element, '')) != LOWER('') AND prps.posid IS NULL;
    /* 260 zError_MWSKZ_T007A_VATCodeIsInvalid -- tvMEMOAPP_Preload_zError_MWSKZ_T007A_VATCodeIsInvalid_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_mwskz_t007a_vatcodeisinvalid = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.t007a
        ON LOWER(ttmemoapp_preload.zvat_tax_code) = LOWER(t007a.mwskz)
        WHERE LOWER(COALESCE(zvat_tax_code, '')) != LOWER('') AND t007a.mwskz IS NULL;
    /* 270 zError_WWPDT_T25A2_ProductLinesInvalid -- tvMEMOAPP_Preload_zError_WWPDT_T25A2_ProductLinesInvalid_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_wwpdt_t25a2_productlinesinvalid = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.t25a2
        ON LOWER(ttmemoapp_preload.zproduct_lines) = LOWER(t25a2.wwpdt)
        WHERE LOWER(COALESCE(zproduct_lines, '')) != LOWER('') AND wwpdt IS NULL;
    /* 295 -- tvMEMOAPP_Preload_zError_zDOC_DATE_Invalid_Upd */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerror_zdoc_date_invalid_upd();
    /* Invalid Doc Date */
    /* 300 zError_MWSKZ_T030K_VatCodeNotExists -- tvMEMOAPP_Preload_zError_MWSKZ_T030K_VatCodeNotExists_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_mwskz_t030k_vatcodenotexists = 1
    FROM dswtdir1_dbo.ttmemoapp_preload
    LEFT OUTER JOIN dswtdir1_dbo.t030k
        ON LOWER(ttmemoapp_preload.zvat_code) = LOWER(t030k.mwskz) AND LOWER(t030k.ktopl) = LOWER('GLOB')
        WHERE LOWER(COALESCE(ttmemoapp_preload.zvat_code, '')) != LOWER('') AND t030k.mwskz IS NULL;
    /* 910 zError_Counter -- tvMEMOAPP_Preload_zError_zReference_Missing_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_counter = 1
        WHERE (LOWER(COALESCE(zreference, '')) = LOWER('')) OR (LOWER(CAST (zreference AS TEXT)) = LOWER(''));
    /* 920 zError_Counter -- tvMEMOAPP_Preload_zError_zDoc_Date_Missing_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_counter = 1
        WHERE (LOWER(COALESCE(zdoc_date, '')) = LOWER(''));
    /* 926 zDuplicate -- tvMEMOAPP_Preload_zVendor_Code_zInvoice_Number_zDuplicate_R2_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zduplicate = 1
    FROM dswtdir1_dbo.ttmemoapp_preload_zvendor_code_zinvoice_number_zduplicate_r2_sel010
        WHERE LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zvendor_code)) = LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload_zvendor_code_zinvoice_number_zduplicate_r2_sel010.zvendor_code)) AND LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zinvoice_number)) = LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload_zvendor_code_zinvoice_number_zduplicate_r2_sel010.zinvoice_number)) AND LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload.zcocd)) = LOWER(dsw_dbo.boatrimleadingzeros(ttmemoapp_preload_zvendor_code_zinvoice_number_zduplicate_r2_sel010.zcocd)) AND LOWER(zsource) NOT LIKE LOWER('%Scenario6%');
    /* 960 zError_ScenarioOverlap -- tvMEMOAPP_Preload_zError_ScenarioOverlap_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload AS tt
    SET zerror_scenariooverlap = 1
    FROM dswtdir1_dbo.svmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_multiplescenarios_overlap_sel AS rpt
        WHERE LOWER(tt.zcounter) = LOWER(rpt.zcounter_scninitial);
    /* 971 zError_SourceValues -- tvMEMOAPP_Preload_zError_SourceValues_R2_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload AS tt
    SET zerror_sourcevalues = 1
    FROM dswtdir1_dbo.tvmemoapp_preload_zerror_sourcevalues_r2_rptsel_010 AS rpt
        WHERE LOWER(tt.zlegacyzcounter) = LOWER(rpt.zcounter_scninitial);
    /* 2010 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zbrand_notint25a1_upd();
    /* Brand Not Maintained in T25A1 table in SAP */
    /* 2020 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zsub_product_a_notint25a4_upd();
    /* Sub Product A Not Maintained in T25A4 */
    /* 2030 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zrevenue_type_notint25a9_upd();
    /* Revenue Type Not Maintained in T25A9 */
    /* 2040 */
    CALL dswtdir1_dbo.tvmemoapp_preload_ska1_gl_is_balance_sheetaccountupd();
    /* GL Is a Balance Sheet Account #R2 */
    /* 2050 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_withholding_datainvalid_upd();
    /* GL Withholding Invalid data #R2 */
    /* 2060 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scn8r_nonrevenuegl_upd();
    /* tvMEMOAPP_Preload_zErrorMessage_Scn8R_NonRevenueGL_UpdSel */
    /* 2070 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zvendor_gl_acct_isblank_upd();
    /* Vendor GL Acc Blank #R2 */
    /* 2080 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zprofit_ctr_forrevgl_upd();
    /* Profit Center #R2 */
    /* 2090 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_fieldsmissing_upd();
    /* Revenue GL Fields Missing #R2 */
    /* 2100 - 10 */
    CALL dswtdir1_dbo.tvmemoapp_preload_ska1_gl_140621_presentinscenarios_otherthan10upd();
    /* GL 140261 Is allowed only for Scenario 10 #R2 */
    /* 2100 - 1080 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_inwrongfile_upd();
    /* Revenue GL in Wrong File #R2 */
    /* 2110 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn9_gl140621_upd();
    /* GL 140621 #R2 */
    /* 2120 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn10_gl140621_dupentry_upd();
    /* GL 14621 Dup Entry #R2 */
    /* 2140 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_accrual_doc_number_isnotblank_upd();
    /* Accrual Doc Number Not Blank #R2 */
    /* 2150 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zinput_vat_amount_scn10_invalid_upd();
    /* Invalid VAT Amount #R2 */
    /* 2161 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zvat_tax_code_invalid_forvatgl_plus_upd();
    /* Remediate VAT Code can only be O1 For VAT GL for Scenario8R_GL_Line (MWSKZ is +). */
    /* 2162 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zvat_tax_code_invalid_forvatgl_minus_upd();
    /* Remediate VAT Code can only be 0A/0C/0E/0D For VAT GL (MWSKZ is -). */
    /* 2170 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_credit_notequalto_debit_upd();
    /* remediate Credit and Debit Values Are not Balanced. */
    /* 2180 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zwithholding_values_multiple_upd();
    /* remediate Withholding_Tax_Base or Type or Code has multiple values. */
    /* 2190 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zpayment_method_zpayt_multiplevalues_upd();
    /* remediate Payment_Method and Payment_Terms have multiple values. */
    /* 2200 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zinput_vat_amount_scn9_invalid_upd();
    /* Invalid VAT Amount #R2 */
    /* 2210 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zinput_vat_amount_scn8_invalid_upd();
    /* Invalid VAT Amount #R2 */
    /* 2220 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zinput_vat_amount_scn8m_invalid_upd();
    /* Invalid VAT Amount #R2 */
    /* 2230 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zcost_ctr_notblank_upd();
    /* Cost center Not blank #R2 */
    /* 2240 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scenario8m_rev_and_nonrev_isinvalid_upd();
    /* Remediate Combination of Revenue GLs and Non-Revenue GLs must not exist for Scenario8M. */
    /* - PROD */
    /* 8010 zError_BELNR_DocumentExistingInBSAK -- tvMEMOAPP_Preload_zError_BELNR_DocumentExistingInBSAK_RptSel */
    
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the ISDATE(VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    UPDATE ttMEMOAPP_Preload
    	SET zError_BELNR_DocumentExistingInBSAK = 1
    	FROM   ttMEMOAPP_Preload
    	inner join BSAK
    	ON RIGHT('000000000'
    			+ ttMEMOAPP_Preload.zVendor_Code, 10) = BSAK.LIFNR
    	AND Replace(Ltrim(Replace(zLegacyzInvoice_Number, '0', ' ')), ' ', '0') = Replace(Ltrim(Replace(BSAK.XBLNR, '0', ' ')), ' ', '0')
    	AND ttMEMOAPP_Preload.zCoCd = BSAK.BUKRS
    	AND Ltrim(Year(ttMEMOAPP_Preload.zDOC_DATE)) = BSAK.GJAHR
    	AND isdate(ttMEMOAPP_Preload.zDOC_DATE) = 1;
    */
    /* QA2 */
    
    /*
    UPDATE ttMEMOAPP_Preload
    SET zError_BELNR_DocumentExistingInBSAK = 1
    FROM   ttMEMOAPP_Preload
    inner join [dgS4HANA_QAS].[dbo].[BSAK] -- BSAK
    ON RIGHT('000000000'
    		+ ttMEMOAPP_Preload.zVendor_Code, 10) = BSAK.LIFNR
    AND Replace(Ltrim(Replace(zLegacyzInvoice_Number, '0', ' ')), ' ', '0') = Replace(Ltrim(Replace(BSAK.XBLNR, '0', ' ')), ' ', '0')
    AND ttMEMOAPP_Preload.zCoCd = BSAK.BUKRS
    AND Ltrim(Year(ttMEMOAPP_Preload.zDOC_DATE)) = BSAK.GJAHR
    AND isdate(ttMEMOAPP_Preload.zDOC_DATE) = 1;
    */
    /* --- */
    /* 8020 zError_BELNR_DocumentExistingInBSIK -- tvMEMOAPP_Preload_zError_BELNR_DocumentExistingInBSIK_RptSel */
    
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the ISDATE(VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    UPDATE ttMEMOAPP_Preload
    	SET zError_BELNR_DocumentExistingInBSIK = 1
    	FROM   ttMEMOAPP_Preload
    	inner join BSIK
    	ON RIGHT('000000000'
    			+ ttMEMOAPP_Preload.zVendor_Code, 10) = BSIK.LIFNR
    	AND Replace(Ltrim(Replace(zLegacyzInvoice_Number, '0', ' ')), ' ', '0') = Replace(Ltrim(Replace(BSIK.XBLNR, '0', ' ')), ' ', '0')
    	AND ttMEMOAPP_Preload.zCoCd = BSIK.BUKRS
    	AND Ltrim(Year(ttMEMOAPP_Preload.zDOC_DATE)) = BSIK.GJAHR
    	AND isdate(ttMEMOAPP_Preload.zDOC_DATE) = 1;
    */
    /* 8930 zError_LineItem -- tvMEMOAPP_Preload_zError_LineItem_BasedOnAllErrorFlags_RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_lineitem = 1
        WHERE COALESCE(zerror_aufnr_aufk_internalordernotcreatedincocd, 0) = 1 OR COALESCE(zerror_belnr_documentexistinginbsak, 0) = 1 OR COALESCE(zerror_belnr_documentexistinginbsik, 0) = 1 OR COALESCE(zerror_bkzkp_csks_costcenter_blockedforposting, 0) = 1 OR COALESCE(zerror_bukrs_lfb1_vendor_notextendedtococd, 0) = 1 OR COALESCE(zerror_bukrs_lfbw_cocd_notexistinginvendormaster, 0) = 1 OR COALESCE(zerror_bukrs_skb1_gl_notextendedtococd, 0) = 1 OR COALESCE(zerror_kostl_csks_costcenter_invaliddaterange, 0) = 1 OR COALESCE(zerror_kostl_csks_costcenter_notcreated, 0) = 1 OR COALESCE(zerror_kostl_csks_costcenter_notcreatedforcocd, 0) = 1 OR COALESCE(zerror_lifnr_lfb1_vendor_notcreated, 0) = 1 OR COALESCE(zerror_lifnr_lfbw_vendor_notexistinginmasterdata, 0) = 1 OR COALESCE(zerror_loevm_lfb1_vendor_markedfordeletion, 0) = 1 OR COALESCE(zerror_mwskz_t007a_vatcodeisinvalid, 0) = 1 OR COALESCE(zerror_mwskz_t030k_vatcodenotexists, 0) = 1 OR COALESCE(zerror_objnr_prps_wbsobjectnumber_blockedforposting, 0) = 1 OR COALESCE(zerror_phas3_aufk_internalorder_closedforposting, 0) = 1 OR COALESCE(zerror_pspnr_prps_wbselementnotcreated, 0) = 1 OR COALESCE(zerror_saknr_ska1_gl_isdup, 0) = 1 OR COALESCE(zerror_saknr_ska1_gl_notcreatedincoa, 0) = 1 OR COALESCE(zerror_saknr_skb1_gl_notcreated, 0) = 1 OR COALESCE(zerror_scenariooverlap, 0) = 1 OR COALESCE(zerror_sourcevalues, 0) = 1 OR COALESCE(zerror_sperr_lfb1_vendor_blockedforposting, 0) = 1 OR COALESCE(zerror_witht_lfbw_whttype_notmaintainedforvendorcocd, 0) = 1 OR COALESCE(zerror_wt_withc_lfbw_whtcode_notmaintainedforvendorcocd, 0) = 1 OR COALESCE(zerror_wwpdt_t25a2_productlinesinvalid, 0) = 1 OR COALESCE(zerror_wwpdt_t25a2_productlinesisinvalid, 0) = 1 OR COALESCE(zerror_xloeb_ska1_gl_markedfordeletion, 0) = 1 OR COALESCE(zerror_xloeb_skb1_gl_markedfordeletion, 0) = 1 OR COALESCE(zerror_xloev_ska1_gl_markedfordeletion, 0) = 1 OR COALESCE(zerror_xspea_ska1_gl_blockedforcreation, 0) = 1 OR COALESCE(zerror_xspeb_ska1_gl_blockedforposting, 0) = 1 OR COALESCE(zerror_xspeb_skb1_gl_blockedforposting, 0) = 1 OR COALESCE(zerror_payterm_invalid, 0) = 1 OR COALESCE(zerror_paymethod_invalid, 0) = 1 OR COALESCE(zduplicate, 0) = 1;
    /* 8931 zError_Counter -- tvMEMOAPP_Preload_zError_LineItem_zCounter_1RptSel */
    UPDATE dswtdir1_dbo.ttmemoapp_preload
    SET zerror_counter = 1
        WHERE ttmemoapp_preload.zcounter IN (SELECT
            zcounter
            FROM dswtdir1_dbo.trmemoapp_preload_zerror_lineitem_zcounter_1updsel010);
    /* 8032 */
    CALL dswtdir1_dbo.tvmemoapp_preload_zerrormessage_basedonallerrorflags_upd()
    /* Update zErrorMessage BasedOnAllErrorFlags */
    ;
END;
$procedure$
