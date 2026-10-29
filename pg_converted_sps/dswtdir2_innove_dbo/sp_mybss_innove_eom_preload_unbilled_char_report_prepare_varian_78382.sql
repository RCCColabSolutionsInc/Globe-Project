CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_report_prepare_varian()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_unbilled_char_varianceintotalamount_cache;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_unbilled_char_varianceintotalamount_cache (sap_total, summary_report_total, variance)
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_innove_dbo.tvinnove_unbilled_char_varianceintotalamountrptsel;
END;
$procedure$
