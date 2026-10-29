CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_export_08_scn08_m_notax(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
/* #endregion */
/* #region 07 sp_Memo_Preload_DCS_Export_08_Scn08_M_NoTax */
BEGIN
    OPEN p_refcur FOR
    SELECT
        counter, doc_date, pstg_date, type, cocd, curr, transldate, exchange_rate, ledger_group, period, reference, document_header_text, pk, vendor_gl_acct, special_gl, amount_in_doc_curr, amount_in_local_cur, amount_in_loc_curr2, ref_key_1, ref_key_2, reference_key_3, bline_date, purch_doc, purchasing_line_item, wbs_element, material, plnt, value_date, payt, "Order", cost_ctr, profit_ctr, partner_profit_center, tr_prt, assignment, text, quantity, uom, brand, product_lines, sub_product_a, sub_product_b, franchise_area, business_center, revenue_type, event, vat_tax_code, mvno, technology, charge_code, plan_type, name, street, country, postal_code, city, bank_key, bank_account, tax_number, message, asset, reserve_1, withholding_tax_base, withholding_tax_type, witholding_tax_code, payment_method, new_company_code, reserve_2, zdsp_order, zdsp_uniquekey, zsite_pla_id,
        /* Added 2025-08 PPM requirement */
        zrfp_approval_date,
        /* Added 2025-08 PPM requirement */
        zpayment_block_code,
        /* Added 2025-08 PPM requirement */
        zprofit_center,
        /* Added 2025-08 PPM requirement */
        zsub_prod_b,
        /* Added 2025-08 PPM requirement */
        zbusiness_entity,
        /* Added 2025-08 NTG requirement */
        zbuilding,
        /* Added 2025-08 NTG requirement */
        zland,
        /* Added 2025-08 NTG requirement */
        zrental_object,
        /* Added 2025-08 NTG requirement */
        zcontract
        /* Added 2025-08 NTG requirement */
        FROM (SELECT
            0 AS sort, 'Counter' AS counter, 'DOC_DATE' AS doc_date, 'Pstg_date' AS pstg_date, 'Type' AS type, 'CoCd' AS cocd, 'Curr' AS curr, 'TranslDate' AS transldate, 'Exchange_Rate' AS exchange_rate, 'Ledger_Group' AS ledger_group, 'Period' AS period, 'Reference' AS reference, 'Document_header_text' AS document_header_text, 'PK' AS pk, 'Vendor_GL_acct' AS vendor_gl_acct, 'Special_GL' AS special_gl, 'Amount_in_doc_curr' AS amount_in_doc_curr, 'Amount_in_local_cur' AS amount_in_local_cur, 'Amount_in_loc_curr2' AS amount_in_loc_curr2, 'Ref_key_1' AS ref_key_1, 'Ref_key_2' AS ref_key_2, 'Reference_key_3' AS reference_key_3, 'Bline_date' AS bline_date, 'Purch_doc' AS purch_doc, 'Purchasing_Line_Item' AS purchasing_line_item, 'WBS_element' AS wbs_element, 'Material' AS material, 'Plnt' AS plnt, 'Value_date' AS value_date, 'PayT' AS payt, 'Order' AS "Order", 'Cost_ctr' AS cost_ctr, 'Profit_ctr' AS profit_ctr, 'Partner_Profit_Center' AS partner_profit_center, 'Tr_prt' AS tr_prt, 'Assignment' AS assignment, 'Text' AS text, 'Quantity' AS quantity, 'UoM' AS uom, 'Brand' AS brand, 'PRODUCT_LINES' AS product_lines, 'SUB_PRODUCT_A' AS sub_product_a, 'SUB_PRODUCT_B' AS sub_product_b, 'FRANCHISE_AREA' AS franchise_area, 'BUSINESS_CENTER' AS business_center, 'REVENUE_TYPE' AS revenue_type, 'EVENT' AS event, 'VAT_TAX_CODE' AS vat_tax_code, 'MVNO' AS mvno, 'TECHNOLOGY' AS technology, 'CHARGE_CODE' AS charge_code, 'PLAN_TYPE' AS plan_type, 'Name' AS name, 'Street' AS street, 'Country' AS country, 'Postal_Code' AS postal_code, 'City' AS city, 'Bank_Key' AS bank_key, 'Bank_Account' AS bank_account, 'Tax_Number' AS tax_number, 'Message' AS message, 'Asset' AS asset, 'Reserve_1' AS reserve_1, 'Withholding_Tax_Base' AS withholding_tax_base, 'Withholding_Tax_Type' AS withholding_tax_type, 'Witholding_Tax_Code' AS witholding_tax_code, 'Payment_Method' AS payment_method, 'New_Company_Code' AS new_company_code, 'Reserve_2' AS reserve_2, 'zDSP_Order' AS zdsp_order, 'zDSP_UniqueKey' AS zdsp_uniquekey, 'zSite_PLA_ID' AS zsite_pla_id,
            /* Added 2025-08 PPM requirement */
            'zRFP_Approval_Date' AS zrfp_approval_date,
            /* Added 2025-08 PPM requirement */
            'zPayment_Block_Code' AS zpayment_block_code,
            /* Added 2025-08 PPM requirement */
            'zProfit_Center' AS zprofit_center,
            /* Added 2025-08 PPM requirement */
            'zSub_Prod_B' AS zsub_prod_b,
            /* Added 2025-08 PPM requirement */
            'zBusiness_Entity' AS zbusiness_entity,
            /* Added 2025-08 NTG requirement */
            'zBuilding' AS zbuilding,
            /* Added 2025-08 NTG requirement */
            'zLand' AS zland,
            /* Added 2025-08 NTG requirement */
            'zRental_Object' AS zrental_object,
            /* Added 2025-08 NTG requirement */
            'zContract' AS zcontract
        /* Added 2025-08 NTG requirement */
        UNION ALL
        SELECT
            1 AS sort, counter, doc_date, pstg_date, type, cocd, curr, transldate, exchange_rate, ledger_group, period, reference, document_header_text, pk, vendor_gl_acct, special_gl, CAST (amount_in_doc_curr AS VARCHAR(255)) AS amount_in_doc_curr, amount_in_local_cur, amount_in_loc_curr2, ref_key_1, ref_key_2, reference_key_3, bline_date, purch_doc, purchasing_line_item, wbs_element, material, plnt, value_date, payt, "Order", cost_ctr, profit_ctr, partner_profit_center, tr_prt, assignment, text, CAST (quantity AS VARCHAR(255)) AS quantity, uom, brand, product_lines, sub_product_a, sub_product_b, franchise_area, business_center, revenue_type, event, vat_tax_code, mvno, technology, charge_code, plan_type, name, street, country, postal_code, city, bank_key, bank_account, tax_number, message, asset, reserve_1, CAST (withholding_tax_base AS VARCHAR(255)) AS withholding_tax_base, withholding_tax_type, witholding_tax_code, payment_method, new_company_code, reserve_2, zdsp_order, zdsp_uniquekey, zsite_pla_id,
            /* Added 2025-08 PPM requirement */
            zrfp_approval_date,
            /* Added 2025-08 PPM requirement */
            zpayment_block_code,
            /* Added 2025-08 PPM requirement */
            zprofit_center,
            /* Added 2025-08 PPM requirement */
            zsub_prod_b,
            /* Added 2025-08 PPM requirement */
            zbusiness_entity,
            /* Added 2025-08 NTG requirement */
            zbuilding,
            /* Added 2025-08 NTG requirement */
            zland,
            /* Added 2025-08 NTG requirement */
            zrental_object,
            /* Added 2025-08 NTG requirement */
            zcontract
            /* Added 2025-08 NTG requirement */
            FROM dswtdir1_dbo.txmemoapp_dcs_output_fromdcs_cleanseddata_openbal_scenario8m_without_taxcodesel) AS xx
        ORDER BY sort NULLS FIRST, counter NULLS FIRST;
END;
$procedure$
