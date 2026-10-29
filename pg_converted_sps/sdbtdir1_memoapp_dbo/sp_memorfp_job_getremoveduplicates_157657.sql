CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_job_getremoveduplicates()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates;
    INSERT INTO sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates (zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, dateread, sequentialid)
    SELECT
        zinputfilename, rn AS zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, dateread, sequentialid
        FROM (SELECT
            ROW_NUMBER() OVER (PARTITION BY invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type ORDER BY invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type) AS rn, zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, dateread, sequentialid
            FROM sdbtdir1_memoapp_dbo.vw_memoapp_source_allproponents_ssis_for_dup_check) AS xx
        WHERE xx.rn > 1;
    /* DELETE DUPLICATES Col 25 table */
    DELETE FROM sdbtdir1_memoapp_dbo.paymentrequests_25cols_ssis
        WHERE sequentialid IN (SELECT
            x.sequentialid
            FROM sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates AS x);
    /* DELETE DUPLICATES Col 28 table */
    DELETE FROM sdbtdir1_memoapp_dbo.paymentrequests_28cols_ssis
        WHERE sequentialid IN (SELECT
            x.sequentialid
            FROM sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates AS x);
END;
$procedure$
