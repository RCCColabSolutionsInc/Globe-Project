CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp3_unbilled_char_recon_amount_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        sap_total, summary_report_total, variance
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp3_unbilled_char_recon_amount_cache;
END;
$procedure$
