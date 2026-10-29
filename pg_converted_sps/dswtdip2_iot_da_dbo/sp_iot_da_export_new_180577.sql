CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_export_new()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- =========================================================================
    -- 0. MISSING DEPENDENCY SAFEGUARDS (Self-Healing Source Tables)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.txiot_da_intap_loadfile (
        counter VARCHAR, doc_date VARCHAR, pstg_date VARCHAR, type VARCHAR, cocd VARCHAR, curr VARCHAR, 
        transldate VARCHAR, exchange_rate VARCHAR, ledger_group VARCHAR, period VARCHAR, reference VARCHAR, 
        document_header_text VARCHAR, pk VARCHAR, gl_acct VARCHAR, specialgl VARCHAR, amount_in_doc_curr VARCHAR, 
        amount_in_local_curr VARCHAR, amount_in_local_cur_2 VARCHAR, ref_key_1 VARCHAR, ref_key_2 VARCHAR, 
        ref_key_3 VARCHAR, bline_date VARCHAR, purch_doc VARCHAR, purchasinglineitem VARCHAR, wbs_element VARCHAR, 
        material VARCHAR, plnt VARCHAR, value_date VARCHAR, payt VARCHAR, order_val VARCHAR, cost_ctr VARCHAR, 
        profit_ctr VARCHAR, partner_profit_center VARCHAR, tr_prt VARCHAR, assignment VARCHAR, text_val VARCHAR, 
        quantity VARCHAR, uom VARCHAR, brand VARCHAR, subproduct_a VARCHAR, subproduct_b VARCHAR, franchise_area VARCHAR, 
        business_center VARCHAR, revenue_type VARCHAR, event VARCHAR, vat_tax_code VARCHAR, mvno_partner VARCHAR, 
        technology VARCHAR, charge_code VARCHAR, plan_type VARCHAR, name VARCHAR, street VARCHAR, country VARCHAR, 
        postal_code VARCHAR, city VARCHAR, bank_key VARCHAR, bank_account VARCHAR, tax_number VARCHAR, 
        general_ledger_account VARCHAR, message VARCHAR, main_asset_number VARCHAR, base_tax_amount VARCHAR, 
        withholding_tax_type VARCHAR, withholding_tax_code VARCHAR, payment_method VARCHAR, new_company_code VARCHAR, 
        local_file VARCHAR, error_flag VARCHAR, core_product VARCHAR, product_lines VARCHAR, 
        dsp_order VARCHAR, dsp_uniquekey VARCHAR
    );

    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile (
        LIKE dswtdip2_iot_da_dbo.txiot_da_intap_loadfile INCLUDING ALL
    );

    -- =========================================================================
    -- 1. BUILD INTAP EXPORT TABLE
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdip2_iot_da_dbo.txiot_da_intap_loadfile_export;
    
    CREATE TABLE dswtdip2_iot_da_dbo.txiot_da_intap_loadfile_export (
        sortorder INT, counter VARCHAR, doc_date VARCHAR, pstg_date VARCHAR, type VARCHAR, cocd VARCHAR, curr VARCHAR, 
        transldate VARCHAR, exchange_rate VARCHAR, ledger_group VARCHAR, period VARCHAR, reference VARCHAR, 
        document_header_text VARCHAR, pk VARCHAR, gl_acct VARCHAR, specialgl VARCHAR, amount_in_doc_curr VARCHAR, 
        amount_in_local_curr VARCHAR, amount_in_local_cur_2 VARCHAR, ref_key_1 VARCHAR, ref_key_2 VARCHAR, 
        ref_key_3 VARCHAR, bline_date VARCHAR, purch_doc VARCHAR, purchasinglineitem VARCHAR, wbs_element VARCHAR, 
        material VARCHAR, plnt VARCHAR, value_date VARCHAR, payt VARCHAR, order_val VARCHAR, cost_ctr VARCHAR, 
        profit_ctr VARCHAR, partner_profit_center VARCHAR, tr_prt VARCHAR, assignment VARCHAR, text_val VARCHAR, 
        quantity VARCHAR, uom VARCHAR, brand VARCHAR, subproduct_a VARCHAR, subproduct_b VARCHAR, franchise_area VARCHAR, 
        business_center VARCHAR, revenue_type VARCHAR, event VARCHAR, vat_tax_code VARCHAR, mvno_partner VARCHAR, 
        technology VARCHAR, charge_code VARCHAR, plan_type VARCHAR, name VARCHAR, street VARCHAR, country VARCHAR, 
        postal_code VARCHAR, city VARCHAR, bank_key VARCHAR, bank_account VARCHAR, tax_number VARCHAR, 
        general_ledger_account VARCHAR, message VARCHAR, main_asset_number VARCHAR, base_tax_amount VARCHAR, 
        withholding_tax_type VARCHAR, withholding_tax_code VARCHAR, payment_method VARCHAR, new_company_code VARCHAR, 
        local_file VARCHAR, error_flag VARCHAR, core_product VARCHAR, product_lines VARCHAR, 
        dsp_order VARCHAR, dsp_uniquekey VARCHAR
    );

    -- Insert Row 1: Hardcoded Headers (These generate the actual Excel column headers)
    INSERT INTO dswtdip2_iot_da_dbo.txiot_da_intap_loadfile_export
    VALUES (
        1, 'Counter', 'Doc_Date', 'Pstg date', 'Type', 'CoCd', 'CURR', 'TranslDate', 'Exchange_Rate', 'Ledger_Group', 'Period', 
        'Reference', 'Document_header_text', 'PK', 'GL_acct', 'SpecialGL', 'Amount_in_doc_curr', 'Amount_in_local_curr', 
        'Amount_in_local_cur_2', 'Ref_key_1', 'Ref_key_2', 'Ref_key_3', 'Bline_date', 'Purch_doc', 'PurchasingLineItem', 
        'WBS_Element', 'Material', 'Plnt', 'Value_date', 'PayT', 'Order', 'Cost_ctr', 'Profit_ctr', 'Partner_Profit_Center', 
        'Tr_prt', 'Assignment', 'Text', 'Quantity', 'UoM', 'Brand', 'SubProduct_A', 'SubProduct_B', 'Franchise_Area', 
        'Business_Center', 'Revenue_Type', 'Event', 'Vat_Tax_Code', 'MVNO Partner', 'Technology', 'Charge Code', 
        'Plan Type', 'Name', 'Street', 'Country', 'Postal Code', 'City', 'Bank Key', 'Bank Account', 'Tax Number', 
        'General Ledger Account', 'Message', 'Main Asset Number', 'Base Tax Amount', 'Withholding Tax Type', 
        'Withholding Tax Code', 'Payment Method', 'New Company Code', 'Local file for upload/download', 'Error Flag', 
        'core product', 'Product lines', 'DSP_Order', 'DSP_UniqueKey'
    );

    -- Insert Row 2+: Actual Data
    INSERT INTO dswtdip2_iot_da_dbo.txiot_da_intap_loadfile_export
    SELECT 2, 
        counter::VARCHAR, doc_date::VARCHAR, pstg_date::VARCHAR, type::VARCHAR, cocd::VARCHAR, curr::VARCHAR, 
        transldate::VARCHAR, exchange_rate::VARCHAR, ledger_group::VARCHAR, period::VARCHAR, reference::VARCHAR, 
        document_header_text::VARCHAR, pk::VARCHAR, gl_acct::VARCHAR, specialgl::VARCHAR, amount_in_doc_curr::VARCHAR, 
        amount_in_local_curr::VARCHAR, amount_in_local_cur_2::VARCHAR, ref_key_1::VARCHAR, ref_key_2::VARCHAR, 
        ref_key_3::VARCHAR, bline_date::VARCHAR, purch_doc::VARCHAR, purchasinglineitem::VARCHAR, wbs_element::VARCHAR, 
        material::VARCHAR, plnt::VARCHAR, value_date::VARCHAR, payt::VARCHAR, order_val::VARCHAR, cost_ctr::VARCHAR, 
        profit_ctr::VARCHAR, partner_profit_center::VARCHAR, tr_prt::VARCHAR, assignment::VARCHAR, text_val::VARCHAR, 
        quantity::VARCHAR, uom::VARCHAR, brand::VARCHAR, subproduct_a::VARCHAR, subproduct_b::VARCHAR, franchise_area::VARCHAR, 
        business_center::VARCHAR, revenue_type::VARCHAR, event::VARCHAR, vat_tax_code::VARCHAR, mvno_partner::VARCHAR, 
        technology::VARCHAR, charge_code::VARCHAR, plan_type::VARCHAR, name::VARCHAR, street::VARCHAR, country::VARCHAR, 
        postal_code::VARCHAR, city::VARCHAR, bank_key::VARCHAR, bank_account::VARCHAR, tax_number::VARCHAR, 
        general_ledger_account::VARCHAR, message::VARCHAR, main_asset_number::VARCHAR, base_tax_amount::VARCHAR, 
        withholding_tax_type::VARCHAR, withholding_tax_code::VARCHAR, payment_method::VARCHAR, new_company_code::VARCHAR, 
        local_file::VARCHAR, error_flag::VARCHAR, core_product::VARCHAR, product_lines::VARCHAR, 
        dsp_order::VARCHAR, dsp_uniquekey::VARCHAR
    FROM dswtdip2_iot_da_dbo.txiot_da_intap_loadfile;


    -- =========================================================================
    -- 2. BUILD OUTTAP EXPORT TABLE
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile_export;
    
    CREATE TABLE dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile_export (
        LIKE dswtdip2_iot_da_dbo.txiot_da_intap_loadfile_export INCLUDING ALL
    );

    -- Insert Row 1: Hardcoded Headers
    INSERT INTO dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile_export
    VALUES (
        1, 'Counter', 'Doc_Date', 'Pstg date', 'Type', 'CoCd', 'CURR', 'TranslDate', 'Exchange_Rate', 'Ledger_Group', 'Period', 
        'Reference', 'Document_header_text', 'PK', 'GL_acct', 'SpecialGL', 'Amount_in_doc_curr', 'Amount_in_local_curr', 
        'Amount_in_local_cur_2', 'Ref_key_1', 'Ref_key_2', 'Ref_key_3', 'Bline_date', 'Purch_doc', 'PurchasingLineItem', 
        'WBS_Element', 'Material', 'Plnt', 'Value_date', 'PayT', 'Order', 'Cost_ctr', 'Profit_ctr', 'Partner_Profit_Center', 
        'Tr_prt', 'Assignment', 'Text', 'Quantity', 'UoM', 'Brand', 'SubProduct_A', 'SubProduct_B', 'Franchise_Area', 
        'Business_Center', 'Revenue_Type', 'Event', 'Vat_Tax_Code', 'MVNO Partner', 'Technology', 'Charge Code', 
        'Plan Type', 'Name', 'Street', 'Country', 'Postal Code', 'City', 'Bank Key', 'Bank Account', 'Tax Number', 
        'General Ledger Account', 'Message', 'Main Asset Number', 'Base Tax Amount', 'Withholding Tax Type', 
        'Withholding Tax Code', 'Payment Method', 'New Company Code', 'Local file for upload/download', 'Error Flag', 
        'core product', 'Product lines', 'DSP_Order', 'DSP_UniqueKey'
    );

    -- Insert Row 2+: Actual Data
    INSERT INTO dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile_export
    SELECT 2, 
        counter::VARCHAR, doc_date::VARCHAR, pstg_date::VARCHAR, type::VARCHAR, cocd::VARCHAR, curr::VARCHAR, 
        transldate::VARCHAR, exchange_rate::VARCHAR, ledger_group::VARCHAR, period::VARCHAR, reference::VARCHAR, 
        document_header_text::VARCHAR, pk::VARCHAR, gl_acct::VARCHAR, specialgl::VARCHAR, amount_in_doc_curr::VARCHAR, 
        amount_in_local_curr::VARCHAR, amount_in_local_cur_2::VARCHAR, ref_key_1::VARCHAR, ref_key_2::VARCHAR, 
        ref_key_3::VARCHAR, bline_date::VARCHAR, purch_doc::VARCHAR, purchasinglineitem::VARCHAR, wbs_element::VARCHAR, 
        material::VARCHAR, plnt::VARCHAR, value_date::VARCHAR, payt::VARCHAR, order_val::VARCHAR, cost_ctr::VARCHAR, 
        profit_ctr::VARCHAR, partner_profit_center::VARCHAR, tr_prt::VARCHAR, assignment::VARCHAR, text_val::VARCHAR, 
        quantity::VARCHAR, uom::VARCHAR, brand::VARCHAR, subproduct_a::VARCHAR, subproduct_b::VARCHAR, franchise_area::VARCHAR, 
        business_center::VARCHAR, revenue_type::VARCHAR, event::VARCHAR, vat_tax_code::VARCHAR, mvno_partner::VARCHAR, 
        technology::VARCHAR, charge_code::VARCHAR, plan_type::VARCHAR, name::VARCHAR, street::VARCHAR, country::VARCHAR, 
        postal_code::VARCHAR, city::VARCHAR, bank_key::VARCHAR, bank_account::VARCHAR, tax_number::VARCHAR, 
        general_ledger_account::VARCHAR, message::VARCHAR, main_asset_number::VARCHAR, base_tax_amount::VARCHAR, 
        withholding_tax_type::VARCHAR, withholding_tax_code::VARCHAR, payment_method::VARCHAR, new_company_code::VARCHAR, 
        local_file::VARCHAR, error_flag::VARCHAR, core_product::VARCHAR, product_lines::VARCHAR, 
        dsp_order::VARCHAR, dsp_uniquekey::VARCHAR
    FROM dswtdip2_iot_da_dbo.txiot_da_outtap_loadfile;

    RAISE NOTICE 'ISMS IOT DA Export executed successfully. Load tables prepared for PySpark FileExporter.';

END;
$procedure$
