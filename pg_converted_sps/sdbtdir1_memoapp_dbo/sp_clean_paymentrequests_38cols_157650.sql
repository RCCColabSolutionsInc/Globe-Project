CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_clean_paymentrequests_38cols()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE sdbtdir1_memoapp_dbo.paymentrequests_38cols_ssis AS x
    SET invoice_number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(invoice_number)), memoapp_ref_no_or_proponents_name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(memoapp_ref_no_or_proponents_name)), vendor_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vendor_code)), vendor_name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vendor_name)), currency = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(currency)), vat_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(vat_code)), accrual_doc_number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(accrual_doc_number)), company_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(company_code)), accrual_doc_fiscal_year = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(accrual_doc_fiscal_year)), gl_natural_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(gl_natural_code)), cost_center_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(cost_center_code)), io_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(io_code)), wbs_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(wbs_code)), link_reference = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(link_reference)), link_ref_period = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(link_ref_period)), product_line = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(product_line)), payment_method = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(payment_method)), payment_terms = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(payment_terms)), description = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(description)), assignment = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(assignment)), wht_type = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(wht_type)), brand = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(brand)), sub_prod_a = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(sub_prod_a)), revenue_type = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(revenue_type)), site_pla_id = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(site_pla_id)),
    /* new field 2025 */
    rfp_approval_date = sdbtdir1_memoapp_dbo.formatdateororiginal(etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(rfp_approval_date))),
    /* new field 2025 */
    payment_block_code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(payment_block_code)),
    /* new field 2025 */
    profit_center = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(profit_center)),
    /* new field 2025 */
    sub_prod_b = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(sub_prod_b)),
    /* new field 2025 */
    business_entity = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(business_entity)), building = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(building)), land = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(land)), rental_object = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(rental_object)), contract = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(contract));
END;
$procedure$
