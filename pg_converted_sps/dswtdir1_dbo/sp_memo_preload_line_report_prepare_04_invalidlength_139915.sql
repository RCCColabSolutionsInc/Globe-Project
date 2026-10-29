CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_report_prepare_04_invalidlength()
 LANGUAGE plpgsql
AS $procedure$
/* Point to DSP */
/* */
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.memo_preload_line_report_prepare_04_invalidlength_cache;
    INSERT INTO dswtdir1_dbo.memo_preload_line_report_prepare_04_invalidlength_cache (zinputfilename, zrownumber, invoice_date, wht_base, gross_invoice_amount, accrual_doc_number, accrual_doc_fiscal_year, cost_center_code, payment_method, description, assignment, input_vat_amount, invoice_number, expected_length_of_invoice_number_16, memoapp_ref_no_or_proponents_name, expected_length_of_memoapp_ref_no_or_proponents_name_25, vendor_code, expected_length_of_vendorcode_10, vendor_name, currency, expected_length_of_currency_5, vat_code, expected_length_of_vat_code_2, company_code, expected_length_of_company_code_4, gl_natural_code, expected_length_of_gl_natural_code_10, io_code, expected_length_of_io_code_12, wbs_code, expected_length_of_wbs_code_24, link_reference, expected_length_of_link_reference_12, link_ref_period, expected_length_of_link_ref_period_12, product_line, expected_length_of_product_line_10, payment_terms, expected_length_of_payment_terms_4, wht_type, expected_length_of_wht_type_2)
    SELECT
        zinputfilename, zrownumber, invoice_date, wht_base, gross_invoice_amount, accrual_doc_number, accrual_doc_fiscal_year, cost_center_code, payment_method, description, assignment, input_vat_amount, invoice_number, expected_length_of_invoice_number_16, memoapp_ref_no_or_proponents_name, expected_length_of_memoapp_ref_no_or_proponents_name_25, vendor_code, expected_length_of_vendorcode_10, vendor_name, currency, expected_length_of_currency_5, vat_code, expected_length_of_vat_code_2, company_code, expected_length_of_company_code_4, gl_natural_code, expected_length_of_gl_natural_code_10, io_code, expected_length_of_io_code_12, wbs_code, expected_length_of_wbs_code_24, link_reference, expected_length_of_link_reference_12, link_ref_period, expected_length_of_link_ref_period_12, product_line, expected_length_of_product_line_10, payment_terms, expected_length_of_payment_terms_4, wht_type, expected_length_of_wht_type_2
        FROM dswtdir1_dbo.tvmemoapp_preload_invalid_length_sourcevalues_r2rptsel AS x;
END;
$procedure$
