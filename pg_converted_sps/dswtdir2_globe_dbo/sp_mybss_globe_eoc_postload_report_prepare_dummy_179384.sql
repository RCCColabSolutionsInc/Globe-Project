CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_report_prepare_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- PARAMETER SAFEGUARD (Bulletproofing)
    -- =========================================================================
    IF par_cyclecode ~ '^[0-9]+$' THEN
        par_cyclecode := 'BC' || LPAD(par_cyclecode, 2, '0');
    END IF;

    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_globe_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txGlobe_Billed_Cycle2_LoadFileSel', 'txGlobe_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txGlobe_Billed_Cycle3_LoadFileSel', 'txGlobe_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txGlobe_Billed_Cycle4_LoadFileSel', 'txGlobe_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txGlobe_Billed_Cycle5_LoadFileSel', 'txGlobe_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txGlobe_Billed_Cycle6_LoadFileSel', 'txGlobe_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txGlobe_Billed_Cycle7_LoadFileSel', 'txGlobe_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txGlobe_Billed_Cycle8_LoadFileSel', 'txGlobe_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txGlobe_Billed_Cycle9_LoadFileSel', 'txGlobe_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txGlobe_Billed_Cycle10_LoadFileSel', 'txGlobe_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txGlobe_Billed_Cycle11_LoadFileSel', 'txGlobe_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_globe_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    SELECT billcycle INTO v_billcycle FROM dswtdir2_globe_dbo.billcycles WHERE cyclecode = par_cyclecode;
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);

    -- =========================================================================
    -- 1. ERROR REPORT CACHE (Legacy: rpt_Postload_Report_DP1_Billed_Error_Cache)
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache;
    CREATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache (
        data VARCHAR(50), date VARCHAR(50), brand VARCHAR(50), customer_type VARCHAR(50), 
        subscriber_type VARCHAR(50), charge_code VARCHAR(50), discount_code VARCHAR(50), 
        amount VARCHAR(50), hits VARCHAR(50), uom VARCHAR(50), wo_indicator VARCHAR(50), 
        cost_center VARCHAR(50), gl VARCHAR(50), nb_indicator VARCHAR(50), remarks VARCHAR(255), 
        zdsp_order INT, zdsp_uniquekey VARCHAR(255), posting_log_message VARCHAR(500), 
        billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache (
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        '01', '2026-05-05', 'GLOBE', 'CUST_TYPE', 'SUB_TYPE', 'CH_CODE', 'DISCOUNT', 
        '100.00', '10', 'UOM', 'WO_IND', 'COST_CENTER', 'GL', 'NB_IND', 
        'DUMMY_ERROR_REMARKS_' || g.i, g.i, 'UNIQ_GLOBE_ERR_' || v_billcycle || '_' || g.i, 
        'requires an assignment to a CO object', v_billcycle
    FROM generate_series(1, 15) AS g(i);

    -- =========================================================================
    -- 2. VALID REPORT CACHE (Legacy: rpt_Postload_Report_DP1_Billed_Valid_Cache)
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache;
    CREATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache (
        data VARCHAR(50), date VARCHAR(50), brand VARCHAR(50), customer_type VARCHAR(50), 
        subscriber_type VARCHAR(50), charge_code VARCHAR(50), discount_code VARCHAR(50), 
        amount VARCHAR(50), hits VARCHAR(50), uom VARCHAR(50), wo_indicator VARCHAR(50), 
        cost_center VARCHAR(50), gl VARCHAR(50), nb_indicator VARCHAR(50), remarks VARCHAR(255), 
        zdsp_order INT, zdsp_uniquekey VARCHAR(255), posting_log_message VARCHAR(500), 
        billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache (
        data, date, brand, customer_type, subscriber_type, charge_code, discount_code, 
        amount, hits, uom, wo_indicator, cost_center, gl, nb_indicator, remarks, 
        zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        '01', '2026-05-05', 'GLOBE', 'CUST_TYPE', 'SUB_TYPE', 'CH_CODE', 'DISCOUNT', 
        '100.00', '10', 'UOM', 'WO_IND', 'COST_CENTER', 'GL', 'NB_IND', 
        'DUMMY_VALID_REMARKS_' || g.i, g.i, 'UNIQ_GLOBE_VAL_' || v_billcycle || '_' || g.i, 
        'Document successfully posted', v_billcycle
    FROM generate_series(1, 15) AS g(i);

    RAISE NOTICE 'Dummy Postload Report Prepare executed successfully for Globe cycle %.', v_billcycle;

END;
$procedure$
