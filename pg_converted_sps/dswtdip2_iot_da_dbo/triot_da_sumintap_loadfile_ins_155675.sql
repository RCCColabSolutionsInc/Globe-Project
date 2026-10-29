CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Yash Raturi 08/22/2022
Modified by: Yash Raturi 09/15/2022
Description: Insert Summary Intap Loadfile into table
*/
BEGIN
    INSERT INTO dswtdip2_iot_da_dbo.sumintap_loadfile_table (account_group, amount_in_doc_curr, amount_in_local_cur_2, amount_in_local_curr, assignment, "Bank Account", "Bank Key", "Base Tax Amount", bline_date, brand, business_center, "Charge Code", city, cocd, "core product", cost_ctr, counter, country, curr, doc_date, document_header_text, dsp_order, dsp_uniquekey, "Error Flag", event, exchange_rate, franchise_area, "General Ledger Account", gl_acct, ledger_group, "Local file for upload/download", "Main Asset Number", material, message, "MVNO Partner", name, "New Company Code", "Order", partner_profit_center, "Payment Method", payt, period, pk, "Plan Type", plnt, "Postal Code", "Product lines", profit_ctr, "Pstg date", purch_doc, purchasinglineitem, quantity, ref_key_1, ref_key_2, ref_key_3, reference, revenue_type, sno, specialgl, street, subproduct_a, subproduct_b, "Tax Number", technology, text, tr_prt, transldate, type, uom, value_date, vat_tax_code, wbs_element, "Withholding Tax Code", "Withholding Tax Type")
    SELECT
        account_group, amount_in_doc_curr, amount_in_local_cur_2, amount_in_local_curr, assignment, "Bank Account", "Bank Key", "Base Tax Amount", bline_date, brand, business_center, "Charge Code", city, cocd, "core product", cost_ctr, counter, country, curr, doc_date, document_header_text, dsp_order, dsp_uniquekey, "Error Flag", event, exchange_rate, franchise_area, "General Ledger Account", gl_acct, ledger_group, "Local file for upload/download", "Main Asset Number", material, message, "MVNO Partner", name, "New Company Code", "Order", partner_profit_center, "Payment Method", payt, period, pk, "Plan Type", plnt, "Postal Code", "Product lines", profit_ctr, "Pstg date", purch_doc, purchasinglineitem, quantity, ref_key_1, ref_key_2, ref_key_3, reference, revenue_type, sno, specialgl, street, subproduct_a, subproduct_b, "Tax Number", technology, text, tr_prt, transldate, type, uom, value_date, vat_tax_code, wbs_element, "Withholding Tax Code", "Withholding Tax Type"
        FROM dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_inssel;
END;
$procedure$
