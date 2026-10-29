CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_bayan_preload_report_comparison2_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "CM DURATION", "PM DURATION", "CM SETTABLE AMT", "PM SETTABLE AMT", "AUR Duration", "AUR SETTABLE AMT", "I/D Duration", "I/D SETTABLE AMT", "CM vs AUR Duration", "CM vs AUR SETTABLE AMT", "CM_RATE/MIN", "PM_RATE/MIN", "Output Sum of Quantity (Settable duration)", "Output Sum of Amount", "Difference Duration", "Difference Amount", currency
        FROM (SELECT
            1 AS sortorder, *
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_preload_report_comparison2_cache AS x
            WHERE LOWER(x.direction) <> LOWER('Total')
        UNION ALL
        SELECT
            2 AS sortorder, *
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_preload_report_comparison2_cache AS x
            WHERE LOWER(x.direction) = LOWER('Total')) AS xx
        ORDER BY sortorder NULLS FIRST, direction NULLS FIRST, "SAP VENDOR CODE" NULLS FIRST;
END;
$procedure$
