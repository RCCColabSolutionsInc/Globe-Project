CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_rpt_getduplicates(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        zinputfilename, zrownumber, invoice_date, invoice_number, memoapp_ref_no_or_proponents_name, vendor_code, vendor_name, currency, wht_base, vat_code, gross_invoice_amount, accrual_doc_number, company_code, accrual_doc_fiscal_year, gl_natural_code, cost_center_code, io_code, wbs_code, link_reference, link_ref_period, product_line, payment_method, payment_terms, description, assignment, wht_type, input_vat_amount, brand, sub_prod_a, revenue_type, dateread
        FROM sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates;
END;
$procedure$
