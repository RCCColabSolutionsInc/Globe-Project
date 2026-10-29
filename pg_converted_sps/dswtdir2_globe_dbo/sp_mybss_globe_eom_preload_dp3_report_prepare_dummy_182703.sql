CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_dummy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_manual   INT := 0;
    v_cnt_preload  INT := 0;
    v_cnt_recon    INT := 0;
    v_col_unbilled TEXT;
BEGIN
    -- =========================================================================
    -- 1. UNBILLED CHARGES MANUAL AGG CACHE
    -- Legacy Table: rpt_Preload_Report_DP3_Unbilled_Char_Manual_agg_Cache
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache (
        ct                 VARCHAR(50),
        st                 VARCHAR(50),
        charge_code        VARCHAR(50),
        sum_of_amount      DOUBLE PRECISION,
        "Unbilled charges" DOUBLE PRECISION,
        diff               DOUBLE PRECISION, 
        tax_rate           NUMERIC(18,4),
        net_of_tax         DOUBLE PRECISION,
        spa                VARCHAR(50),
        rev_type           VARCHAR(50),
        gl                 VARCHAR(50),
        spb                VARCHAR(50),
        remark             VARCHAR(255)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache;

    -- Dynamically resolve the 5th column identifier to support both space and underscore conventions
    SELECT column_name INTO v_col_unbilled
    FROM information_schema.columns
    WHERE table_schema = 'dswtdir2_globe_dbo'
      AND table_name = 'rpt_preload_report_dp3_unbilled_char_manual_agg_cache'
      AND ordinal_position = 5;

    v_col_unbilled := COALESCE(v_col_unbilled, 'Unbilled charges');

    EXECUTE format('
        INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache (
            ct, st, charge_code, sum_of_amount, %I, diff, tax_rate, net_of_tax, spa, rev_type, gl, spb, remark
        )
        SELECT 
            CASE WHEN g.i %% 2 = 0 THEN ''CONSUMER'' ELSE ''ENTERPRISE'' END,
            CASE WHEN g.i %% 3 = 0 THEN ''BROADBAND'' ELSE ''POSTPAID'' END,
            ''UB_CHG_'' || (100 + g.i),
            (10000.00 + (g.i * 500.00))::DOUBLE PRECISION,
            (9500.00 + (g.i * 480.00))::DOUBLE PRECISION,
            ((10000.00 + (g.i * 500.00)) - (9500.00 + (g.i * 480.00)))::DOUBLE PRECISION,
            0.1200::NUMERIC(18,4),
            ROUND(((10000.00 + (g.i * 500.00)) / 1.12)::NUMERIC, 2)::DOUBLE PRECISION,
            ''SPA_'' || g.i,
            ''REV_UNBILLED'',
            ''41010010'',
            ''SPB_'' || g.i,
            ''Mock Unbilled Charges Manual Agg Item''
        FROM generate_series(1, 10) AS g(i);
    ', v_col_unbilled);

    -- =========================================================================
    -- 2. UNBILLED CHARGES PRELOAD CACHE (15 COLUMNS)
    -- Legacy Table: rpt_Preload_Report_DP3_Unbilled_Char_Preload_Cache
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache (
        column01       VARCHAR(50),
        column02       VARCHAR(50),
        column03       VARCHAR(50),
        column04       VARCHAR(50),
        column05       VARCHAR(50),
        column06       VARCHAR(50),
        column07       VARCHAR(50),
        column08       VARCHAR(50),
        column09       VARCHAR(50),
        column10       VARCHAR(50),
        column11       VARCHAR(50),
        column12       VARCHAR(50),
        remark         VARCHAR(255),
        zdsp_order     INT,
        zdsp_uniquekey VARCHAR(100)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache (
        column01, column02, column03, column04, column05, column06,
        column07, column08, column09, column10, column11, column12,
        remark, zdsp_order, zdsp_uniquekey
    )
    SELECT 
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'ENTERPRISE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UB_CHG_' || (200 + g.i),
        (2500.50 + (g.i * 75.25))::VARCHAR,
        'CC_GLOBE_' || (1000 + g.i),
        '41010010',
        '0',
        'INST_01',
        'PHP',
        'Valid Unbilled Charges Preload Item',
        g.i,
        'GLB_UB_EOM_' || LPAD(g.i::TEXT, 5, '0')
    FROM generate_series(1, 20) AS g(i);

    -- =========================================================================
    -- 3. UNBILLED CHARGES RECON AMOUNT CACHE
    -- Legacy Table: rpt_Preload_Report_DP3_Unbilled_Char_Recon_Amount_Cache
    -- Clean numeric literals avoid 22P02 type mismatches
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache (
        sap_total            NUMERIC(18,2),
        summary_report_total NUMERIC(18,2),
        variance             NUMERIC(18,2)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache (
        sap_total, summary_report_total, variance
    )
    VALUES (
        8750240.50,
        8745110.25,
        5130.25
    );

    -- =========================================================================
    -- 4. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_manual  FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache;
    SELECT COUNT(1) INTO v_cnt_preload FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache;
    SELECT COUNT(1) INTO v_cnt_recon   FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'GLOBE EOM DP3 UNBILLED CHARGES REPORT PREPARE (DUMMY) COMPLETED';
    RAISE NOTICE '  1. Manual Agg Cache : % record(s)', v_cnt_manual;
    RAISE NOTICE '  2. Preload Cache    : % record(s)', v_cnt_preload;
    RAISE NOTICE '  3. Recon Cache      : % record(s)', v_cnt_recon;
    RAISE NOTICE 'All 3 verbose legacy physical tables populated.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
