CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_msf_export_new_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Creates the exact same table structure as the real DP5 MSF Export stored procedure
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_msf_expsel_export CASCADE;

    CREATE TABLE dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_msf_expsel_export (
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
    DELETE FROM dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_msf_expsel_export;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Directly populates the table to simulate the cleansed SAP text file output for MSF.
    -- Maps 42 columns matching the SAP FI/CO layout.
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.txglobe_dp5_unconfirmed_msf_expsel_export (
        batch_no, doc_date, post_date, doc_type, co_code, currency, translation_date, 
        period, reference, doc_hdr_text, posting_key, spcl_gl_indicator, gl_sl_code, 
        reconciliation_gl_account, amount, tax_code, io_number, cost_center, profit_center, 
        assign, text_val, rate, trading_partner, partner_profit_center, quantity, uom, 
        brand, sub_product_a, sub_product_b, franchise_area, business_centre, 
        revenue_sales_type, event_segment, payment_term, payment_method, mvno_partner, 
        technology, plan_type, core_product, revenue_item_code, zdsp_order, zdsp_uniquekey
    )
    VALUES 
        -- Row 1: Simulating an Unconfirmed MSF (e.g., MSF_GFLEX250_J)
        ('BATCH_MSF_001', '08/19/2026', '08/19/2026', 'SA', '1000', 'PHP', '08/19/2026', 
         '08', 'REF-MSF-2001', 'Unconfirmed MSF Debit', '40', '', 'GL_MSF_201', 
         '', '2378512.50', 'MSF_GFLEX', '', 'CC_CONS', 'PC_RET', 
         'ASGN_MSF1', 'Base Plan Fee', '1.0', '', '', '1', 'EA', 
         'GLOBE', 'SPA_MSF1', 'SPB_MSF1', 'AREA_1', 'BC_1', 
         'REV_RC', 'SEG_CONS', 'PT_01', 'PM_01', '', 
         'WIRELESS', 'POSTPAID', 'CORE_MSF1', 'RIC_MSF1', '1', 'DP5-MSF-KEY-001'),

        -- Row 2: Simulating another Unconfirmed MSF (e.g., Enterprise Boost Plan)
        ('BATCH_MSF_001', '08/19/2026', '08/19/2026', 'SA', '1000', 'PHP', '08/19/2026', 
         '08', 'REF-MSF-2002', 'Unconfirmed MSF Ent', '40', '', 'GL_MSF_202', 
         '', '1017726.36', 'MSF_ENTBST', '', 'CC_ENT', 'PC_CORP', 
         'ASGN_MSF2', 'Enterprise Boost', '1.0', '', '', '1', 'EA', 
         'GLOBE', 'SPA_MSF2', 'SPB_MSF2', 'AREA_2', 'BC_2', 
         'REV_RC', 'SEG_ENT', 'PT_01', 'PM_01', '', 
         'WIRELESS', 'POSTPAID', 'CORE_MSF2', 'RIC_MSF2', '2', 'DP5-MSF-KEY-002');

END;
$procedure$
