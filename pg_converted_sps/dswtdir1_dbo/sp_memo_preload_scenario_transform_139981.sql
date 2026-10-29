CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_transform()
 LANGUAGE plpgsql
AS $procedure$
/* #region 01 sp_Memo_Preload_Scenario_Transform */
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents;
    INSERT INTO dswtdir1_dbo.stmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents (zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, site_pla_id, rfp_approval_date, payment_block_code, profit_center, sub_prod_b, business_entity, building, land, rental_object, contract)
    SELECT
        zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, site_pla_id, rfp_approval_date, payment_block_code, profit_center, sub_prod_b, business_entity, building, land, rental_object, contract
        FROM sdbtdir1_memoapp_dbo.memoapp_source_allproponents AS x
        ORDER BY x.zinputfilename NULLS FIRST, x.zrownumber NULLS FIRST;
    CALL dswtdir1_dbo.sp_memo_preload_scenario_transform_rules();
END;
$procedure$
