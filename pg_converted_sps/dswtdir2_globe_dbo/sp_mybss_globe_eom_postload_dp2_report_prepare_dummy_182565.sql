CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp2_report_prepare_dummy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_error INT := 0; --CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp2_report_prepare_dummy()
    v_cnt_valid INT := 0;
BEGIN
    -- =========================================================================
    -- 1. UNEARNED POSTLOAD ERROR CACHE (45 chars <= 63)
    -- Legacy: rpt_Postload_Report_DP2_Unearned_Error_Cache
    -- Simulates: zLoaded = '0' with S/4HANA error posting messages
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache (
        zlegacydsp_order    INT,
        data                VARCHAR(10),
        date                VARCHAR(50),
        brand               VARCHAR(50),
        "Customer Type"     VARCHAR(50),
        "Subscriber Type"   VARCHAR(50),
        "Charge Code"       VARCHAR(50),
        amount              DOUBLE PRECISION,
        "WO Indicator"      VARCHAR(50),
        "Cost Center"       VARCHAR(50),
        gl                  VARCHAR(50),
        "NB Indicator"      VARCHAR(50),
        remarks             VARCHAR(255),
        zdsp_order          INT,
        zdsp_uniquekey      VARCHAR(100),
        posting_log_message VARCHAR(500)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache (
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type",
        "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator",
        remarks, zdsp_order, zdsp_uniquekey, posting_log_message
    )
    SELECT 
        g.i,
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'CORPORATE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UE_ERR_CHG_' || (100 + g.i),
        (-250.50 - (g.i * 15.00))::DOUBLE PRECISION,
        '0',
        'CC_GLOBE_' || (1000 + g.i),
        '21410010',
        '0',
        'Unearned Postload Error Record',
        g.i,
        'GLB_UE_PS_ERR_' || LPAD(g.i::TEXT, 5, '0'),
        'ERROR: Document posting rejected by SAP S/4HANA - GL Account 21410010 blocked for posting'
    FROM generate_series(1, 5) AS g(i);

    -- =========================================================================
    -- 2. UNEARNED POSTLOAD VALID CACHE (45 chars <= 63)
    -- Legacy: rpt_Postload_Report_DP2_Unearned_Valid_Cache
    -- Simulates: zLoaded = '1' with successful S/4HANA document numbers
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache (
        zlegacydsp_order    INT,
        data                VARCHAR(10),
        date                VARCHAR(50),
        brand               VARCHAR(50),
        "Customer Type"     VARCHAR(50),
        "Subscriber Type"   VARCHAR(50),
        "Charge Code"       VARCHAR(50),
        amount              DOUBLE PRECISION,
        "WO Indicator"      VARCHAR(50),
        "Cost Center"       VARCHAR(50),
        gl                  VARCHAR(50),
        "NB Indicator"      VARCHAR(50),
        remarks             VARCHAR(255),
        zdsp_order          INT,
        zdsp_uniquekey      VARCHAR(100),
        posting_log_message VARCHAR(500)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache (
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type",
        "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator",
        remarks, zdsp_order, zdsp_uniquekey, posting_log_message
    )
    SELECT 
        g.i,
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'CORPORATE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UE_VAL_CHG_' || (200 + g.i),
        (1500.75 + (g.i * 120.25))::DOUBLE PRECISION,
        '0',
        'CC_GLOBE_' || (1000 + g.i),
        '21410010',
        '0',
        'Unearned Postload Valid Record',
        g.i,
        'GLB_UE_PS_VAL_' || LPAD(g.i::TEXT, 5, '0'),
        'SUCCESS: Document 19000' || LPAD(g.i::TEXT, 5, '0') || ' posted successfully in S/4HANA Company Code GLB'
    FROM generate_series(1, 15) AS g(i);

    -- =========================================================================
    -- 3. TERRAFORM SHORTHAND COMPATIBILITY VIEWS
    -- glue_mybss_eom_gt.tf rpt_xp_ps1 references these shorthand names
    -- =========================================================================
    CREATE OR REPLACE VIEW dswtdir2_globe_dbo.rpt_eom_dp2_unearned_ps_error_cache AS 
    SELECT * FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache;

    CREATE OR REPLACE VIEW dswtdir2_globe_dbo.rpt_eom_dp2_unearned_ps_valid_cache AS 
    SELECT * FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache;

    -- =========================================================================
    -- 4. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_error FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache;
    SELECT COUNT(1) INTO v_cnt_valid FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'GLOBE EOM UNEARNED POSTLOAD REPORT PREPARE (DUMMY) COMPLETED';
    RAISE NOTICE '  1. Postload Error Cache : % record(s)', v_cnt_error;
    RAISE NOTICE '  2. Postload Valid Cache : % record(s)', v_cnt_valid;
    RAISE NOTICE 'Both exact legacy and shorthand Terraform targets populated.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
