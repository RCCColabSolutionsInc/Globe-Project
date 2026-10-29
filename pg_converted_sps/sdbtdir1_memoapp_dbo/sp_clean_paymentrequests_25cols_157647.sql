CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_clean_paymentrequests_25cols()
 LANGUAGE plpgsql
AS $procedure$
/*
Winds: additional data cleansing.
This procedure is executed from the SSIS package
*/
BEGIN
    UPDATE sdbtdir1_memoapp_dbo.paymentrequests_25cols_ssis AS x
    SET invoice_number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(invoice_number)), memoapp_ref_no_or_proponents_name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(memoapp_ref_no_or_proponents_name)), vendor_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vendor_code)), vendor_name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vendor_name)), currency = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(currency)), vat_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vat_code)), accrual_doc_number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(accrual_doc_number)), company_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(company_code)), accrual_doc_fiscal_year = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(accrual_doc_fiscal_year)), gl_natural_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(gl_natural_code)), cost_center_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(cost_center_code)), io_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(io_code)), wbs_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(wbs_code)), link_reference = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(link_reference)), link_ref_period = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(link_ref_period)), product_line = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(product_line)), payment_method = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(payment_method)), payment_terms = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(payment_terms)), description = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(description)), assignment = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(assignment)), wht_type = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(wht_type));
END;
$procedure$
