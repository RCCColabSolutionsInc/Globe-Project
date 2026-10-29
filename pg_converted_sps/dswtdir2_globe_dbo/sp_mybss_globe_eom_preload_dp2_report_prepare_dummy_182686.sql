CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_dummy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_manual  INT := 0;
    v_cnt_preload INT := 0;
    v_cnt_recon   INT := 0;
BEGIN
    -- =========================================================================
    -- 1. UNEARNED MANUAL REPORT CACHE
    -- Legacy Table: rpt_Preload_Report_DP2_Unearned_Manual_Report_Cache
    -- Schema matches verified catalog: quoted "Charge Code", double precision amount
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache (
        ct            VARCHAR(50),
        st            VARCHAR(50),
        "Charge Code" VARCHAR(50),
        amount        DOUBLE PRECISION,
        umsf          NUMERIC(18,2),
        diff          NUMERIC(18,2),
        spa           VARCHAR(50),
        rev_type      VARCHAR(50),
        gl            VARCHAR(50),
        spb           VARCHAR(50),
        remarks       VARCHAR(255)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache (
        ct, st, "Charge Code", amount, umsf, diff, spa, rev_type, gl, spb, remarks
    )
    SELECT 
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'ENTERPRISE' END,
        CASE WHEN g.i % 3 = 0 THEN 'BROADBAND' ELSE 'POSTPAID' END,
        'UE_CHG_' || (100 + g.i),
        (50000.00 + (g.i * 1250.00))::DOUBLE PRECISION,
        (48500.00 + (g.i * 1200.00))::NUMERIC(18,2),
        ((50000.00 + (g.i * 1250.00)) - (48500.00 + (g.i * 1200.00)))::NUMERIC(18,2),
        'SPA_' || g.i,
        'REV_UNEARNED',
        '2141' || LPAD(g.i::TEXT, 4, '0'),
        'SPB_' || g.i,
        'Mock Unearned MSF Manual Group Item'
    FROM generate_series(1, 10) AS g(i);

    -- =========================================================================
    -- 2. UNEARNED PRELOAD CACHE
    -- Legacy Table: rpt_Preload_Report_DP2_Unearned_Preload_Cache
    -- Preserves Data = '01' and Option A space-delimited columns
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache (
        zlegacydsp_order  INT,
        data              VARCHAR(10),
        date              VARCHAR(50),
        brand             VARCHAR(50),
        "Customer Type"   VARCHAR(50),
        "Subscriber Type" VARCHAR(50),
        "Charge Code"     VARCHAR(50),
        amount            DOUBLE PRECISION,
        "WO Indicator"    VARCHAR(50),
        "Cost Center"     VARCHAR(50),
        gl                VARCHAR(50),
        "NB Indicator"    VARCHAR(50),
        remarks           VARCHAR(255),
        zdsp_order        INT,
        zdsp_uniquekey    VARCHAR(100)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache (
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type",
        "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator",
        remarks, zdsp_order, zdsp_uniquekey
    )
    SELECT 
        g.i,
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'CORPORATE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UE_CHG_' || (200 + g.i),
        (1500.75 + (g.i * 120.25))::DOUBLE PRECISION,
        '0',
        'CC_GLOBE_' || (1000 + g.i),
        '21410010',
        '0',
        'Valid Unearned Preload Item',
        g.i,
        'GLB_UE_EOM_' || LPAD(g.i::TEXT, 5, '0')
    FROM generate_series(1, 20) AS g(i);

    -- =========================================================================
    -- 3. UNEARNED RECON AMOUNT CACHE
    -- Legacy Table: rpt_Preload_Report_DP2_Unearned_Recon_Amount_Cache
    -- Difference bounded within +/- 100,000 threshold
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache (
        "Total Unearned" VARCHAR(50),
        total_sap_airc   VARCHAR(50),
        difference       VARCHAR(50)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache (
        "Total Unearned", total_sap_airc, difference
    )
    VALUES (
        '5,420,350.25',
        '5,415,120.10',
        '5,230.15'
    );

    -- =========================================================================
    -- 4. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_manual  FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache;
    SELECT COUNT(1) INTO v_cnt_preload FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache;
    SELECT COUNT(1) INTO v_cnt_recon   FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'GLOBE EOM UNEARNED REPORT PREPARE (DUMMY) COMPLETED';
    RAISE NOTICE '  1. Manual Report Cache : % record(s)', v_cnt_manual;
    RAISE NOTICE '  2. Preload Cache       : % record(s)', v_cnt_preload;
    RAISE NOTICE '  3. Recon Amount Cache  : % record(s)', v_cnt_recon;
    RAISE NOTICE 'All 3 verbose legacy physical tables populated.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
