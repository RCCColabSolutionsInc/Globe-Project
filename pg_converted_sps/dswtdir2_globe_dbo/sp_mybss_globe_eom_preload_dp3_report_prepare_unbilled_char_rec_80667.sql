CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_report_prepare_unbilled_char_rec()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache (sap_total, summary_report_total, variance)
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_globe_dbo.tvglobe_dp3_unbilled_char_recon_amountrptsel;
END;
$procedure$
