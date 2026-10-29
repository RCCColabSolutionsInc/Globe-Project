CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_varianc()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_varianceintotalamount_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_varianceintotalamount_cache (sap_total, summary_report_total, variance)
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_innove_dbo.tvinnove_unearned_msf_varianceintotalamountrptsel;
END;
$procedure$
