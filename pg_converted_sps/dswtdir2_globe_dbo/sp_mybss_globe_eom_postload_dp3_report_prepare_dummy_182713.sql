CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp3_report_prepare_dummy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_error INT := 0;
    v_cnt_valid INT := 0;
BEGIN
    -- =========================================================================
    -- 1. UNBILLED CHARGES POSTLOAD ERROR CACHE (16 COLUMNS)
    -- Legacy Table: rpt_Postload_Report_DP3_Unbilled_Char_Error_Cache
    -- Simulates: Rejected S/4HANA document postings
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache (
        column01            VARCHAR(50),
        column02            VARCHAR(50),
        column03            VARCHAR(50),
        column04            VARCHAR(50),
        column05            VARCHAR(50),
        column06            VARCHAR(50),
        column07            VARCHAR(50),
        column08            VARCHAR(50),
        column09            VARCHAR(50),
        column10            VARCHAR(50),
        column11            VARCHAR(50),
        column12            VARCHAR(50),
        remark              VARCHAR(255),
        zdsp_order          INT,
        zdsp_uniquekey      VARCHAR(100),
        posting_log_message VARCHAR(500)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache (
        column01, column02, column03, column04, column05, column06,
        column07, column08, column09, column10, column11, column12,
        remark, zdsp_order, zdsp_uniquekey, posting_log_message
    )
    SELECT 
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'ENTERPRISE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UB_ERR_CHG_' || (100 + g.i),
        (-250.50 - (g.i * 15.00))::VARCHAR,
        'CC_GLOBE_' || (1000 + g.i),
        '41010010',
        '0',
        'INST_01',
        'PHP',
        'Unbilled Charges Postload Error Record',
        g.i,
        'GLB_UB_PS_ERR_' || LPAD(g.i::TEXT, 5, '0'),
        'ERROR: Document posting rejected by SAP S/4HANA - GL Account 41010010 blocked for posting'
    FROM generate_series(1, 5) AS g(i);

    -- =========================================================================
    -- 2. UNBILLED CHARGES POSTLOAD VALID CACHE (16 COLUMNS)
    -- Legacy Table: rpt_Postload_Report_DP3_Unbilled_Char_Valid_Cache
    -- Simulates: Successful S/4HANA document postings
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache (
        column01            VARCHAR(50),
        column02            VARCHAR(50),
        column03            VARCHAR(50),
        column04            VARCHAR(50),
        column05            VARCHAR(50),
        column06            VARCHAR(50),
        column07            VARCHAR(50),
        column08            VARCHAR(50),
        column09            VARCHAR(50),
        column10            VARCHAR(50),
        column11            VARCHAR(50),
        column12            VARCHAR(50),
        remark              VARCHAR(255),
        zdsp_order          INT,
        zdsp_uniquekey      VARCHAR(100),
        posting_log_message VARCHAR(500)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache;

    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache (
        column01, column02, column03, column04, column05, column06,
        column07, column08, column09, column10, column11, column12,
        remark, zdsp_order, zdsp_uniquekey, posting_log_message
    )
    SELECT 
        '01',
        TO_CHAR(CURRENT_DATE, 'MM/DD/YYYY'),
        'GLOBE',
        CASE WHEN g.i % 2 = 0 THEN 'CONSUMER' ELSE 'ENTERPRISE' END,
        CASE WHEN g.i % 2 = 0 THEN 'POSTPAID' ELSE 'PLATINUM' END,
        'UB_VAL_CHG_' || (200 + g.i),
        (2500.50 + (g.i * 75.25))::VARCHAR,
        'CC_GLOBE_' || (1000 + g.i),
        '41010010',
        '0',
        'INST_01',
        'PHP',
        'Unbilled Charges Postload Valid Record',
        g.i,
        'GLB_UB_PS_VAL_' || LPAD(g.i::TEXT, 5, '0'),
        'SUCCESS: Document 41000' || LPAD(g.i::TEXT, 5, '0') || ' posted successfully in S/4HANA Company Code GLB'
    FROM generate_series(1, 15) AS g(i);

    -- =========================================================================
    -- 3. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_error FROM dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache;
    SELECT COUNT(1) INTO v_cnt_valid FROM dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'GLOBE EOM DP3 UNBILLED CHARGES POSTLOAD REPORT PREPARE (DUMMY) COMPLETED';
    RAISE NOTICE '  1. Postload Error Cache : % record(s)', v_cnt_error;
    RAISE NOTICE '  2. Postload Valid Cache : % record(s)', v_cnt_valid;
    RAISE NOTICE 'Both verbose legacy physical tables populated.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
