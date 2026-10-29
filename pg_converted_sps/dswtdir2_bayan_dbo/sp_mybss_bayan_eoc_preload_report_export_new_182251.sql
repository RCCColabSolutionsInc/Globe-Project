CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_export_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_norm_code    VARCHAR(10); -- CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_export_new('EOC1')
    v_billcycle    VARCHAR(5);
    v_cycle_key    VARCHAR(10);
    v_missing_cc   INT := 0;
    v_missing_st   INT := 0;
    v_preload_cnt  INT := 0;
    v_recon_php    INT := 0;
    v_recon_usd    INT := 0;
BEGIN
    v_norm_code := UPPER(TRIM(par_cyclecode));
    IF v_norm_code ~ '^[0-9]+$' THEN
        v_norm_code := 'BC' || LPAD(v_norm_code, 2, '0');
    END IF;

    IF v_norm_code LIKE 'BC%' THEN
        v_billcycle := v_norm_code;
        SELECT cyclecode INTO v_cycle_key FROM dswtdir2_bayan_dbo.billcycles WHERE billcycle = v_billcycle LIMIT 1;
    ELSE
        v_cycle_key := v_norm_code;
        SELECT billcycle INTO v_billcycle FROM dswtdir2_bayan_dbo.billcycles WHERE cyclecode = v_cycle_key LIMIT 1;
    END IF;

    v_billcycle := COALESCE(v_billcycle, 'BC01');
    v_cycle_key := COALESCE(v_cycle_key, 'EOC1');

    -- Self-healing check: initialize tables if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'dswtdir2_bayan_dbo' 
          AND table_name = 'rpt_preload_report_prepare_dp1_billed_preload_cache'
    ) THEN
        RAISE NOTICE 'Target cache tables missing. Running Report Prepare Dummy for cycle %...', v_billcycle;
        CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dummy(v_billcycle);
    END IF;

    -- Safeguard: Ensure billcycle is populated so FileExporter.py --FILTER_DROP_COL does not drop rows
    UPDATE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca
    SET billcycle = v_billcycle
    WHERE billcycle IS NULL;

    UPDATE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    SET billcycle = v_billcycle
    WHERE billcycle IS NULL;

    UPDATE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache
    SET billcycle = v_billcycle
    WHERE billcycle IS NULL;

    UPDATE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache
    SET billcycle = v_billcycle
    WHERE billcycle IS NULL;

    -- Count records matching the export filter
    SELECT COUNT(1) INTO v_missing_cc 
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_missing_st 
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_preload_cnt 
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache 
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_recon_php 
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_recon_usd 
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache
    WHERE billcycle = v_billcycle;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'BAYAN PRELOAD REPORT EXPORT HOOK READY: % (%)', v_billcycle, v_cycle_key;
    RAISE NOTICE '  1. Charge Code Missing Cache: % records (matching %)', v_missing_cc, v_billcycle;
    RAISE NOTICE '  2. Subs Type Missing Cache   : % records (matching %)', v_missing_st, v_billcycle;
    RAISE NOTICE '  3. Preload Cache (Valid)     : % records (matching %)', v_preload_cnt, v_billcycle;
    RAISE NOTICE '  4. Recon Summary PHP Cache   : % records (matching %)', v_recon_php, v_billcycle;
    RAISE NOTICE '  5. Recon Summary USD Cache   : % records (matching %)', v_recon_usd, v_billcycle;
    RAISE NOTICE 'FileExporter.py will now extract all reports to Excel on S3.';
    RAISE NOTICE '=================================================================';
END;
$procedure$
