CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- Establishes configuration lookup data across the pipeline dynamically
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10),
        billcycle VARCHAR(5),
        description VARCHAR(50),
        runday INT,
        keyword_ssrs VARCHAR(20),
        exportfilekey VARCHAR(100),
        exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_innove_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txInnove_Billed_Cycle2_LoadFileSel', 'txInnove_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txInnove_Billed_Cycle3_LoadFileSel', 'txInnove_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txInnove_Billed_Cycle4_LoadFileSel', 'txInnove_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txInnove_Billed_Cycle5_LoadFileSel', 'txInnove_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txInnove_Billed_Cycle6_LoadFileSel', 'txInnove_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txInnove_Billed_Cycle7_LoadFileSel', 'txInnove_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txInnove_Billed_Cycle8_LoadFileSel', 'txInnove_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txInnove_Billed_Cycle9_LoadFileSel', 'txInnove_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txInnove_Billed_Cycle10_LoadFileSel', 'txInnove_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txInnove_Billed_Cycle11_LoadFileSel', 'txInnove_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_innove_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    -- Resolve BillCycle from CycleCode (Fallback to par_cyclecode if table missing)
    BEGIN
        SELECT billcycle INTO v_billcycle 
        FROM dswtdir2_innove_dbo.billcycles 
        WHERE cyclecode = par_cyclecode;
    EXCEPTION WHEN undefined_table THEN
        v_billcycle := par_cyclecode;
    END;
    
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);

    -- =========================================================================
    -- 0. SCHEMA REFRESH (ACTUAL TABLE NAMES)
    -- =========================================================================
    
    -- 1. Charge Code Missing
    -- Legacy: rpt_Preload_Report_Prepare_DP1_Billed_ChargeCodeMissing_Cache (65 chars)
    -- PGSQL Actual (63 chars): rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (
        missing_charge_code VARCHAR,
        billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache(missing_charge_code, billcycle)
    SELECT 'DUMMY_INNOVE_CHARGE_CODE_' || g.i, v_billcycle FROM generate_series(1, 5) AS g(i);

    -- 2. Subscriber Type Missing
    -- Legacy: rpt_Preload_Report_Prepare_DP1_Billed_Subscriber_TypeMissing_Cache (66 chars)
    -- PGSQL Actual (63 chars): rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca;
    CREATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca (
        subscriber_type VARCHAR,
        billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca(subscriber_type, billcycle)
    SELECT 'DUMMY_INNOVE_SUB_TYPE_' || g.i, v_billcycle FROM generate_series(1, 5) AS g(i);

    -- 3. Billed Preload (Already < 63 chars)
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache (
        column01 VARCHAR, column02 VARCHAR, column03 VARCHAR, column04 VARCHAR, column05 VARCHAR, 
        column06 VARCHAR, column07 VARCHAR, column08 VARCHAR, column09 VARCHAR, column10 VARCHAR, 
        column11 VARCHAR, column12 VARCHAR, column13 VARCHAR, column14 VARCHAR, column15 VARCHAR, 
        column16 VARCHAR, column17 VARCHAR, column18 VARCHAR, column19 VARCHAR, 
        zdsp_order INT, zdsp_uniquekey VARCHAR, billcycle VARCHAR
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache (
        column01, column02, column03, column04, column05, column06, column07, 
        column08, column09, column10, column11, column12, column13, column14, 
        column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, billcycle
    )
    SELECT 
        '01', 'Val2_' || g.i, 'Val3_' || g.i, 'Val4_' || g.i, 'Val5_' || g.i, 
        'Val6_' || g.i, 'Val7_' || g.i, '100.00', '10.00', 'Val10_' || g.i, 
        'Val11_' || g.i, 'Val12_' || g.i, 'Val13_' || g.i, 'Val14_' || g.i, 'Val15_' || g.i, 
        'Val16_' || g.i, 'Val17_' || g.i, 'Val18_' || g.i, 'Val19_' || g.i,
        g.i, 'UNIQ_INNOVE_' || g.i, v_billcycle
    FROM generate_series(1, 15) AS g(i);

    -- 4. Recon Summary PHP (Exactly 63 chars)
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache (
        description VARCHAR, cycle_code_01 VARCHAR, cycle_code_06 VARCHAR, cycle_code_08 VARCHAR, 
        cycle_code_10 VARCHAR, cycle_code_11 VARCHAR, cycle_code_13 VARCHAR, cycle_code_16 VARCHAR, 
        cycle_code_18 VARCHAR, cycle_code_21 VARCHAR, cycle_code_24 VARCHAR, cycle_code_27 VARCHAR, 
        total VARCHAR, billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache (
        description, cycle_code_01, cycle_code_06, cycle_code_08, cycle_code_10, 
        cycle_code_11, cycle_code_13, cycle_code_16, cycle_code_18, cycle_code_21, 
        cycle_code_24, cycle_code_27, total, billcycle
    )
    SELECT 
        'DUMMY_PHP_DESC_' || g.i, '100.00', '200.00', '300.00', '400.00', '500.00', 
        '600.00', '700.00', '800.00', '900.00', '1000.00', '1100.00', 'TOTAL_PHP', v_billcycle
    FROM generate_series(1, 10) AS g(i);

    -- 5. Recon Summary USD (Exactly 63 chars)
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache (
        description VARCHAR, cycle_code_01 VARCHAR, cycle_code_06 VARCHAR, cycle_code_08 VARCHAR, 
        cycle_code_10 VARCHAR, cycle_code_11 VARCHAR, cycle_code_13 VARCHAR, cycle_code_16 VARCHAR, 
        cycle_code_18 VARCHAR, cycle_code_21 VARCHAR, cycle_code_24 VARCHAR, cycle_code_27 VARCHAR, 
        total VARCHAR, billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache (
        description, cycle_code_01, cycle_code_06, cycle_code_08, cycle_code_10, 
        cycle_code_11, cycle_code_13, cycle_code_16, cycle_code_18, cycle_code_21, 
        cycle_code_24, cycle_code_27, total, billcycle
    )
    SELECT 
        'DUMMY_USD_DESC_' || g.i, '10.00', '20.00', '30.00', '40.00', '50.00', 
        '60.00', '70.00', '80.00', '90.00', '100.00', '110.00', 'TOTAL_USD', v_billcycle
    FROM generate_series(1, 10) AS g(i);

    RAISE NOTICE 'Dummy Report Prepare phase successfully simulated for Innove % across all 5 actual cache tables.', par_cyclecode;

END;
$procedure$
