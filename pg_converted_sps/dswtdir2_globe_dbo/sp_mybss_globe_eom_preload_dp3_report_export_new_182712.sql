CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_export_new()
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

    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache (
        sap_total            NUMERIC(18,2),
        summary_report_total NUMERIC(18,2),
        variance             NUMERIC(18,2)
    );

    -- =========================================================================
    -- 1. DATA READINESS AUDIT & TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_cnt_manual  FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_manual_agg_cache;
    SELECT COUNT(1) INTO v_cnt_preload FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_preload_cache;
    SELECT COUNT(1) INTO v_cnt_recon   FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache;

    IF v_cnt_manual = 0 AND v_cnt_preload = 0 AND v_cnt_recon = 0 THEN
        RAISE NOTICE 'WARNING: All 3 verbose legacy Globe EOM Unbilled Charges cache tables are empty. Ensure Report Prepare has executed prior to file export.';
    END IF;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM DP3 UNBILLED CHARGES REPORT EXPORT HOOK READY';
    RAISE NOTICE '  1. Manual Agg Cache : % record(s)', v_cnt_manual;
    RAISE NOTICE '  2. Preload Cache    : % record(s)', v_cnt_preload;
    RAISE NOTICE '  3. Recon Cache      : % record(s)', v_cnt_recon;
    RAISE NOTICE 'PySpark FileExporter will now generate the 3 Excel reports on S3 from the verbose legacy cache tables.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
