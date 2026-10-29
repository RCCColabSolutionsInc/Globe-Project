CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_export_unconfirmed_adj_new_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Creates the exact same table structure as the real DP5 Unconfirmed Adj Export stored procedure
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_agg_exportsel_export CASCADE;

    CREATE TABLE dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_agg_exportsel_export (
        batch_no VARCHAR(500),
        doc_date VARCHAR(500),
        post_date VARCHAR(500),
        doc_type VARCHAR(500),
        co_code VARCHAR(500),
        currency VARCHAR(500),
        translation_date VARCHAR(500),
        period VARCHAR(500),
        reference VARCHAR(500),
        doc_hdr_text VARCHAR(500),
        posting_key VARCHAR(500),
        spcl_gl_indicator VARCHAR(500),
        gl_sl_code VARCHAR(500),
        reconciliation_gl_account VARCHAR(500),
        amount VARCHAR(500),
        tax_code VARCHAR(500),
        io_number VARCHAR(500),
        cost_center VARCHAR(500),
        profit_center VARCHAR(500),
        assign VARCHAR(500),
        text_val VARCHAR(500),
        rate VARCHAR(500),
        trading_partner VARCHAR(500),
        partner_profit_center VARCHAR(500),
        quantity VARCHAR(500),
        uom VARCHAR(500),
        brand VARCHAR(500),
        sub_product_a VARCHAR(500),
        sub_product_b VARCHAR(500),
        franchise_area VARCHAR(500),
        business_centre VARCHAR(500),
        revenue_sales_type VARCHAR(500),
        event_segment VARCHAR(500),
        payment_term VARCHAR(500),
        payment_method VARCHAR(500),
        mvno_partner VARCHAR(500),
        technology VARCHAR(500),
        plan_type VARCHAR(500),
        core_product VARCHAR(500),
        revenue_item_code VARCHAR(500),
        zdsp_order VARCHAR(500),
        zdsp_uniquekey VARCHAR(500)
    );

    -- ===============================================================================
    -- 2. CONCURRENCY FIX
    -- Clears out old dummy data before seeding
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_agg_exportsel_export;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Directly populates the table to simulate the cleansed SAP text file output.
    -- Maps 42 columns matching the SAP FI/CO layout for Aggregated Unconfirmed Adjs.
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_adj_agg_exportsel_export (
        batch_no, doc_date, post_date, doc_type, co_code, currency, translation_date, 
        period, reference, doc_hdr_text, posting_key, spcl_gl_indicator, gl_sl_code, 
        reconciliation_gl_account, amount, tax_code, io_number, cost_center, profit_center, 
        assign, text_val, rate, trading_partner, partner_profit_center, quantity, uom, 
        brand, sub_product_a, sub_product_b, franchise_area, business_centre, 
        revenue_sales_type, event_segment, payment_term, payment_method, mvno_partner, 
        technology, plan_type, core_product, revenue_item_code, zdsp_order, zdsp_uniquekey
    )
    VALUES 
        -- Row 1: Simulating an aggregated unconfirmed adjustment credit
        ('BATCH_AGG_001', '08/19/2026', '08/19/2026', 'SA', '1000', 'PHP', '08/19/2026', 
         '08', 'REF-AGG-1001', 'Agg Unconf Adj Credit', '40', '', 'GL_SPB_AGG1', 
         '', '-15000.00', 'UNCONF_AGG_CR', '', 'CC_CORP', 'PC_ENT', 
         'ASGN_AGG1', 'Aggregated Credit', '1.0', '', '', '1', 'EA', 
         'GLOBE', 'SPA_AGG1', 'SPB_AGG1', 'AREA_1', 'BC_1', 
         'REV_AGG', 'SEG_ENT', 'PT_01', 'PM_01', '', 
         'WIRELESS', 'POSTPAID', 'CORE_AGG1', 'RIC_AGG1', '1', 'DP5-AGG-KEY-001'),

        -- Row 2: Simulating an aggregated unconfirmed adjustment debit
        ('BATCH_AGG_001', '08/19/2026', '08/19/2026', 'SA', '1000', 'PHP', '08/19/2026', 
         '08', 'REF-AGG-1002', 'Agg Unconf Adj Debit', '50', '', 'GL_SPB_AGG2', 
         '', '8500.50', 'UNCONF_AGG_DR', '', 'CC_CONS', 'PC_RET', 
         'ASGN_AGG2', 'Aggregated Debit', '1.0', '', '', '1', 'EA', 
         'GLOBE', 'SPA_AGG2', 'SPB_AGG2', 'AREA_2', 'BC_2', 
         'REV_AGG', 'SEG_CONS', 'PT_01', 'PM_01', '', 
         'BROADBAND', 'PREPAID', 'CORE_AGG2', 'RIC_AGG2', '2', 'DP5-AGG-KEY-002');

END;
$procedure$
