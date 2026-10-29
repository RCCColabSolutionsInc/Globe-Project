CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_chargec()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_chargecodemissing_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_chargecodemissing_cache (missing_charge_code)
    SELECT
        missing_charge_code
        FROM dswtdir2_innove_dbo.tvinnove_unearned_msf_column06_chargecodemissingrptsel;
END;
$procedure$
