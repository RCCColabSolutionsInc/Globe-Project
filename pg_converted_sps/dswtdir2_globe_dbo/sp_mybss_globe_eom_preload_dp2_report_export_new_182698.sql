CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cnt_manual  INT := 0;
    v_cnt_preload INT := 0;
    v_cnt_recon   INT := 0;
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING VERBOSE LEGACY CACHE TABLE DEFINITIONS (OPTION A)
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

    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache (
        "Total Unearned" VARCHAR(50),
        total_sap_airc   VARCHAR(50),
        difference       VARCHAR(50)
    );

    -- =========================================================================
    -- 1. DATA READINESS AUDIT & TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_manual  FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache;
    SELECT COUNT(1) INTO v_cnt_preload FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache;
    SELECT COUNT(1) INTO v_cnt_recon   FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache;

    IF v_cnt_manual = 0 AND v_cnt_preload = 0 AND v_cnt_recon = 0 THEN
        RAISE NOTICE 'WARNING: All 3 verbose legacy Globe EOM Unearned cache tables are empty. Ensure Report Prepare has executed prior to file export.';
    END IF;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM PRELOAD REPORT EXPORT HOOK READY';
    RAISE NOTICE '  1. Manual Report Cache : % record(s)', v_cnt_manual;
    RAISE NOTICE '  2. Preload Cache       : % record(s)', v_cnt_preload;
    RAISE NOTICE '  3. Recon Amount Cache  : % record(s)', v_cnt_recon;
    RAISE NOTICE 'FileExporter.py will now generate the 3 Excel reports on S3 from the verbose legacy cache tables.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
