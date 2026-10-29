CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp2_unearned_recon_amount_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "Total Unearned", total_sap_airc, difference
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_recon_amount_cache;
END;
$procedure$
