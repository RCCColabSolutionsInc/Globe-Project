CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_transform_scn09_01_vendorlines()
 LANGUAGE plpgsql
AS $procedure$
/* #endregion */
/* #region 17 sp_Memo_Preload_Line_Transform_Scn09_01_VendorLines */
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.stmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines;
    INSERT INTO dswtdir1_dbo.stmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines (zcounter_scninitial, zcounterlineitem_scninitial, zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, zlegacyzscenariotable_internalkey, zscenariotable_internalkey, zgl_natural_code_boapadded, zscenario_scninitial, zscenario_counts_scninitial, zscenario_counter_orderby_scninitial, zscenario_zrownumber_min_scninitial, zscenario_zrownumber_max_scninitial, zscenario1, zscenario1_counts, zscenario1_gross_invoice_amount_sum, zscenario1_counter_orderby, zscenario1_zrownumber_min, zscenario1_zrownumber_max, zdsp_uniquekey, zscenario2, zscenario2_counts, zscenario2_gross_invoice_amount_sum, zscenario2_counter_orderby, zscenario2_zrownumber_min, zscenario2_zrownumber_max, zscenario3, zscenario3_counts, zscenario3_gross_invoice_amount_sum, zscenario3_counter_orderby, zscenario3_zrownumber_min, zscenario3_zrownumber_max, zscenario4, zscenario4_counts, zscenario4_gross_invoice_amount_sum, zscenario4_counter_orderby, zscenario4_zrownumber_min, zscenario4_zrownumber_max, zscenario5, zscenario5_counts, zscenario5_gross_invoice_amount_sum, zscenario5_counter_orderby, zscenario5_zrownumber_min, zscenario5_zrownumber_max, zscenario8r, zscenario8r_counts, zscenario8r_gross_invoice_amount_sum, zscenario8r_counter_orderby, zscenario8r_zrownumber_min, zscenario8r_zrownumber_max, zscenario8r_input_vat_amount_sum, zscenario8r_vat_code_categ, zscenario8m, zscenario8m_counts, zscenario8m_gross_invoice_amount_sum, zscenario8m_counter_orderby, zscenario8m_zrownumber_min, zscenario8m_zrownumber_max, zscenario8m_input_vat_amount_sum, zscenario8m_vat_code_categ, zscenario9, zscenario9_counts, zscenario9_gross_invoice_amount_sum, zscenario9_counter_orderby, zscenario9_zrownumber_min, zscenario9_zrownumber_max, zscenario9_input_vat_amount_sum, zscenario9_vat_code_categ, zscenario10, zscenario10_counts, zscenario10_gross_invoice_amount_sum, zscenario10_counter_orderby, zscenario10_zrownumber_min, zscenario10_zrownumber_max, zscenario10_input_vat_amount_sum, zscenario10_vat_code_categ, zscenario6, zscenario6_counts, zscenario6_gross_invoice_amount_sum, zscenario6_counter_orderby, zscenario6_zrownumber_min, zscenario6_zrownumber_max, zscenario2_inscn6, zscenario2_inscn6_counts, zscenario2_inscn6_gross_invoice_amount_sum, zscenario2_inscn6_counter_orderby, zscenario2_inscn6_zrownumber_min, zscenario2_inscn6_zrownumber_max, zscenario3_inscn6, zscenario3_inscn6_counts, zscenario3_inscn6_gross_invoice_amount_sum, zscenario3_inscn6_counter_orderby, zscenario3_inscn6_zrownumber_min, zscenario3_inscn6_zrownumber_max, zscenario4_inscn6, zscenario4_inscn6_counts, zscenario4_inscn6_gross_invoice_amount_sum, zscenario4_inscn6_counter_orderby, zscenario4_inscn6_zrownumber_min, zscenario4_inscn6_zrownumber_max, zscenario5_inscn6, zscenario5_inscn6_counts, zscenario5_inscn6_gross_invoice_amount_sum, zscenario5_inscn6_counter_orderby, zscenario5_inscn6_zrownumber_min, zscenario5_inscn6_zrownumber_max, ztxt50_ska1_scninitial, zsaknr_ska1_scninitial, zxbilk_ska1_scninitial, zktoks_ska1_scninitial, zska1_glaccount_type_scninitial, zmwskz_skb1_scninitial, zxmwno_skb1_scninitial, zxloeb_skb1_scninitial, zxspeb_skb1_scninitial, zkalsm_t007a_scninitial, zmwskz_t007a_scninitial, zmwart_t007a_scninitial, zduplicate, zduplicate_lineitem, zactive, zloaded, zload_message, site_pla_id,
    /* 2025-08 PPM as is value */
    rfp_approval_date,
    /* 2025-08 PPM as is value */
    payment_block_code,
    /* 2025-08 PPM as is value */
    profit_center,
    /* 2025-08 PPM as is value */
    sub_prod_b,
    /* 2025-08 PPM as is value */
    business_entity,
    /* 2025-08 PPM as is value */
    building,
    /* 2025-08 NTG as is value */
    land,
    /* 2025-08 NTG as is value */
    rental_object,
    /* 2025-08 NTG as is value */
    contract,
    /* 2025-08 NTG as is value */
    zsite_pla_id,
    /* 2025-08 PPM as is value */
    zrfp_approval_date,
    /* 2025-08 PPM as is value. Transformation placeholder. as is value for now */
    zpayment_block_code,
    /* 2025-08 PPM as is value. Transformation placeholder. as is value for now */
    zprofit_center,
    /* 2025-08 PPM as is value. Transformation placeholder. as is value for now */
    zsub_prod_b,
    /* 2025-08 PPM as is value. Transformation placeholder. as is value for now */
    zbusiness_entity,
    /* 2025-08 NTG as is value. Transformation placeholder. as is value for now */
    zbuilding,
    /* 2025-08 NTG as is value. Transformation placeholder. as is value for now */
    zland,
    /* 2025-08 NTG as is value. Transformation placeholder. . as is value for now */
    zrental_object,
    /* 2025-08 NTG as is value. Transformation placeholder */
    zcontract
    /* 2025-08 NTG as is value. Transformation placeholder */
    )
    SELECT
        zcounter_scninitial AS zcounter_scninitial, zcounterlineitem_scninitial AS zcounterlineitem_scninitial, zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, zlegacyzscenariotable_internalkey, zscenariotable_internalkey, zgl_natural_code_boapadded, zscenario_scninitial, zscenario_counts_scninitial, zscenario_counter_orderby_scninitial, zscenario_zrownumber_min_scninitial, zscenario_zrownumber_max_scninitial, zscenario1, zscenario1_counts, zscenario1_gross_invoice_amount_sum, zscenario1_counter_orderby, zscenario1_zrownumber_min, zscenario1_zrownumber_max, zdsp_uniquekey, zscenario2, zscenario2_counts, zscenario2_gross_invoice_amount_sum, zscenario2_counter_orderby, zscenario2_zrownumber_min, zscenario2_zrownumber_max, zscenario3, zscenario3_counts, zscenario3_gross_invoice_amount_sum, zscenario3_counter_orderby, zscenario3_zrownumber_min, zscenario3_zrownumber_max, zscenario4, zscenario4_counts, zscenario4_gross_invoice_amount_sum, zscenario4_counter_orderby, zscenario4_zrownumber_min, zscenario4_zrownumber_max, zscenario5, zscenario5_counts, zscenario5_gross_invoice_amount_sum, zscenario5_counter_orderby, zscenario5_zrownumber_min, zscenario5_zrownumber_max, zscenario8r, zscenario8r_counts, zscenario8r_gross_invoice_amount_sum, zscenario8r_counter_orderby, zscenario8r_zrownumber_min, zscenario8r_zrownumber_max, zscenario8r_input_vat_amount_sum, zscenario8r_vat_code_categ, zscenario8m, zscenario8m_counts, zscenario8m_gross_invoice_amount_sum, zscenario8m_counter_orderby, zscenario8m_zrownumber_min, zscenario8m_zrownumber_max, zscenario8m_input_vat_amount_sum, zscenario8m_vat_code_categ, zscenario9, zscenario9_counts, zscenario9_gross_invoice_amount_sum, zscenario9_counter_orderby, zscenario9_zrownumber_min, zscenario9_zrownumber_max, zscenario9_input_vat_amount_sum, zscenario9_vat_code_categ, zscenario10, zscenario10_counts, zscenario10_gross_invoice_amount_sum, zscenario10_counter_orderby, zscenario10_zrownumber_min, zscenario10_zrownumber_max, zscenario10_input_vat_amount_sum, zscenario10_vat_code_categ, zscenario6, zscenario6_counts, zscenario6_gross_invoice_amount_sum, zscenario6_counter_orderby, zscenario6_zrownumber_min, zscenario6_zrownumber_max, zscenario2_inscn6, zscenario2_inscn6_counts, zscenario2_inscn6_gross_invoice_amount_sum, zscenario2_inscn6_counter_orderby, zscenario2_inscn6_zrownumber_min, zscenario2_inscn6_zrownumber_max, zscenario3_inscn6, zscenario3_inscn6_counts, zscenario3_inscn6_gross_invoice_amount_sum, zscenario3_inscn6_counter_orderby, zscenario3_inscn6_zrownumber_min, zscenario3_inscn6_zrownumber_max, zscenario4_inscn6, zscenario4_inscn6_counts, zscenario4_inscn6_gross_invoice_amount_sum, zscenario4_inscn6_counter_orderby, zscenario4_inscn6_zrownumber_min, zscenario4_inscn6_zrownumber_max, zscenario5_inscn6, zscenario5_inscn6_counts, zscenario5_inscn6_gross_invoice_amount_sum, zscenario5_inscn6_counter_orderby, zscenario5_inscn6_zrownumber_min, zscenario5_inscn6_zrownumber_max, ztxt50_ska1_scninitial, zsaknr_ska1_scninitial, zxbilk_ska1_scninitial, zktoks_ska1_scninitial, zska1_glaccount_type_scninitial, zmwskz_skb1_scninitial, zxmwno_skb1_scninitial, zxloeb_skb1_scninitial, zxspeb_skb1_scninitial, zkalsm_t007a_scninitial, zmwskz_t007a_scninitial, zmwart_t007a_scninitial, zduplicate, zduplicate_lineitem, zactive, zloaded, zload_message, site_pla_id, rfp_approval_date, payment_block_code, profit_center, sub_prod_b, business_entity, building, land, rental_object, contract, site_pla_id, rfp_approval_date, payment_block_code, profit_center, sub_prod_b, business_entity, building, land, rental_object, contract
        FROM sdbtdir1_memoapp_dbo.memoapp_allprops_scenario9_vendorlines;
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzinvoice_numberupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzvendor_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzinvoice_dateupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzaccrual_doc_numberupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzvat_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzcost_center_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzgl_natural_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zsaknr_ska1upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_ztxt50_skatupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzgross_invoice_amountupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zvendor_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zinvoice_numberupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zvat_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zdescriptionupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zgl_natural_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zcost_center_codeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zinput_vat_amountupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zcounterupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zdoc_dateupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zpstg_dateupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_ztypeupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zcocdupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zvendor_gl_acctupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zcurrupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zperiodupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zreferenceupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zdocument_header_textupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zamount_in_doc_currupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zpkupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zref_key_1upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zref_key_2upd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zbline_dateupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zwbs_elementupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zpayt_manualupd();
    /* Manual R2Rule to update unique non-blank value from GL Lines onto Vendor Line. */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zorderupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zassignmentupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_ztextupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zproduct_linesupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zwithholding_tax_base_manualupd();
    /* Manual R2Rule to update unique non-blank value from GL Lines onto Vendor Line. */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zwithholding_tax_type_manualupd();
    /* Manual R2Rule to update unique non-blank value from GL Lines onto Vendor Line. */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zwitholding_tax_code_manualupd();
    /* Manual R2Rule to update unique non-blank value from GL Lines onto Vendor Line. */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zpayment_method_manualupd();
    /* Manual R2Rule to update unique non-blank value from GL Lines onto Vendor Line. */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzcounterupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzcounterlineitemupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zcounterlineitemupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zactiveupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zscenarioupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zscenario_countsupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zscenario_counter_orderbyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zscenario_zrownumber_minupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zscenario_zrownumber_maxupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zroutedforload_dateupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzinputfilenameupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zlegacyzdsp_uniquekeyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlines_zdsp_uniquekeyupd();
    /* */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlinesdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srmemoapp_preload_tdir1_memoapp_memoapp_allprops_scenario9_vendorlinesins()
    /* Source to Target Insert */
    ;
END;
$procedure$
