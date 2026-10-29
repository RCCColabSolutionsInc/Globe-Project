CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 9, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    UPDATE sdbtdir2_globe_dbo."307_Unbilled_Adjustments_Report_G"
    SET "Write-Off Activity Indicator" = NULL
        WHERE LOWER("Write-Off Activity Indicator") = LOWER('');
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g (zrownumber, "Customer Type", "Customer Sub Type", "Primary Subscriber Type", "Adjustment Type", "Adjustment Date", "Adjustment Code/Tax code", "Adjustment Reason", amount, "Legal Entity", currency, "Write-Off Activity Indicator")
    SELECT
        zrownumber, "Customer Type", "Customer Sub Type", "Primary Subscriber Type", "Adjustment Type", "Adjustment Date", "Adjustment Code/Tax code", "Adjustment Reason", amount, "Legal Entity", currency, "Write-Off Activity Indicator"
        FROM sdbtdir2_globe_dbo."307_Unbilled_Adjustments_Report_G"
        ORDER BY zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zlegacydsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zdsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zcustomer_typeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zcustomer_sub_typeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zprimary_subscriber_typeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zadjustment_typeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zadjustment_codeupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zadjustment_reasonupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zamountupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zposting_dateupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zspaupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zrev_typeupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zgl_zspbupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zgl2upd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_ztf0002s_zgl_zspbupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zamount_netupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zbrandupd();
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zremarkupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_g_zactiveupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_gdel();
    /* Target Delete by Source */
    CALL dswtdir2_globe_dbo.srglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_report_gins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_globe_dbo.trglobe_dp4_unbilled_adj_zloaded_0_error_lineupd();
END;
$procedure$
