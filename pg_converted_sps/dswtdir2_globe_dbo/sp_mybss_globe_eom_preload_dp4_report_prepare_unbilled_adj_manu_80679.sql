CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_report_prepare_unbilled_adj_manu()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp4_unbilled_adj_manual_cache;
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp4_unbilled_adj_manual_cache ("Customer Type", "Customer Sub Type", "Primary Subscriber Type", "Adjustment Type", "Adjustment Date", "Adjustment Code/Tax code", "Adjustment Reason", amount, "Legal Entity", currency, "Write-Off Activity Indicator", tax, amount_net, brand, spa, rev_type, gl, spb, remark)
    SELECT
        "Customer Type", "Customer Sub Type", "Primary Subscriber Type", "Adjustment Type", "Adjustment Date", "Adjustment Code/Tax code", "Adjustment Reason", amount, "Legal Entity", currency, "Write-Off Activity Indicator", tax, amount_net, brand, spa, rev_type, gl, spb, remark
        FROM dswtdir2_globe_dbo.tvglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_manualrptsel;
END;
$procedure$
