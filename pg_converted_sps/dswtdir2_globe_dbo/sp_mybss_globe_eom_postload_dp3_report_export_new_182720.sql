CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp3_report_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_error INT := 0;
    v_cnt_valid INT := 0;
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING VERBOSE LEGACY CACHE TABLE DEFINITIONS
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

    -- =========================================================================
    -- 1. DATA READINESS AUDIT & TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_error FROM dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_error_cache;
    SELECT COUNT(1) INTO v_cnt_valid FROM dswtdir2_globe_dbo.rpt_postload_report_dp3_unbilled_char_valid_cache;

    IF v_cnt_error = 0 AND v_cnt_valid = 0 THEN
        RAISE NOTICE 'WARNING: Both verbose legacy Globe EOM DP3 Unbilled Charges Postload cache tables are empty. Ensure Postload Report Prepare has executed prior to file export.';
    END IF;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM DP3 UNBILLED CHARGES POSTLOAD REPORT EXPORT HOOK READY';
    RAISE NOTICE '  1. Postload Error Cache : % record(s)', v_cnt_error;
    RAISE NOTICE '  2. Postload Valid Cache : % record(s)', v_cnt_valid;
    RAISE NOTICE 'PySpark FileExporter will now generate both Postload Excel reports on S3 from the verbose legacy cache tables.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
