CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_globe_preload_dp4_unbilled_adj_manual_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "Customer Type", "Customer Sub Type", "Primary Subscriber Type", "Adjustment Type", "Adjustment Date", "Adjustment Code/Tax code", "Adjustment Reason", amount, "Legal Entity", currency, "Write-Off Activity Indicator", tax, amount_net, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.rpt_preload_report_dp4_unbilled_adj_manual_cache;
END;
$procedure$
