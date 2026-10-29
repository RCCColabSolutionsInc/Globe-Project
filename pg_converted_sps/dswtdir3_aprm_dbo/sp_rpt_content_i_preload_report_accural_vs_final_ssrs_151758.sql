CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_content_i_preload_report_accural_vs_final_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "Row Labels", "BP END DATE", "ORIGINAL BP END DATE", "CHARGE DIRECTION", "PARTNER CODE", "PARTNER NAME", "SERVICE PROVIDER", "PRODUCT LINE INDICATOR", "CUSTOMER SEGMENT", "SUB SERVICE TYPE", "CUSTOMER SUB TYPE", "CONTENT TYPE", "ACCESS CODE", cur, "Final HITS", "Final Payout", "Final VAT", "Accrual HITS", "Accrual Payout", "Accrual VAT", "Difference HITS", "Difference Payout", "Difference Vat"
        FROM dswtdir3_aprm_dbo.rpt_content_i_preload_report_accural_vs_final_cache;
END;
$procedure$
