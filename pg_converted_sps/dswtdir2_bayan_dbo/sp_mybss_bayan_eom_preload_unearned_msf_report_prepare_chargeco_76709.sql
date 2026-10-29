CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unearned_msf_report_prepare_chargeco()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_chargecodemissing_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_chargecodemissing_cache (missing_charge_code)
    SELECT
        missing_charge_code
        FROM dswtdir2_bayan_dbo.tvbayan_unearned_msf_column06_chargecodemissingrptsel;
END;
$procedure$
