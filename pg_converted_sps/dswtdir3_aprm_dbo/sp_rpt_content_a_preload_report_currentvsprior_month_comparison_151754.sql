CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_content_a_preload_report_currentvsprior_month_comparison(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "PARTNER CODE", "PARTNER NAME", "CM HITS", "CM PAYOUT", "CM VAT", "CM TOTAL PAYOUT", "PM HITS", "PM PAYOUT", "PM VAT", "PM TOTAL PAYOUT", "I/D HITS", "I/D PAYOUT", "I/D VAT", "I/D TOTAL PAYOUT/SF", "I/D PAYOUT / PM PAYOUT", "I/D TOTAL PAYOUT/SF / PM TOTAL PAYOUT"
        FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_currentvsprior_month_comparison_1st_cache;
END;
$procedure$
