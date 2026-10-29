CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_content_a_preload_report_per_partner1st_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "PARTNER CODE", "PARTNER NAME", "I/D PAYOUT"
        FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_per_partner1st_cache;
END;
$procedure$
