CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp2_report_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_error INT := 0;
    v_cnt_valid INT := 0;
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING VERBOSE LEGACY CACHE TABLE DEFINITIONS (OPTION A)
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

    -- =========================================================================
    -- 1. DATA READINESS AUDIT & TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_error FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_error_cache;
    SELECT COUNT(1) INTO v_cnt_valid FROM dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache;

    IF v_cnt_error = 0 AND v_cnt_valid = 0 THEN
        RAISE NOTICE 'WARNING: Both verbose legacy Globe EOM Unearned Postload cache tables are empty. Ensure Postload Report Prepare has executed prior to file export.';
    END IF;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM UNEARNED POSTLOAD REPORT EXPORT HOOK READY';
    RAISE NOTICE '  1. Postload Error Cache : % record(s)', v_cnt_error;
    RAISE NOTICE '  2. Postload Valid Cache : % record(s)', v_cnt_valid;
    RAISE NOTICE 'PySpark FileExporter will now generate both Postload Excel reports on S3.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
