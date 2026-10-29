CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unearned_msf_report_prepare_variance()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_varianceintotalamount_cache;
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_unearned_msf_varianceintotalamount_cache (sap_total, summary_report_total, variance)
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_bayan_dbo.tvbayan_unearned_msf_varianceintotalamountrptsel;
END;
$procedure$
