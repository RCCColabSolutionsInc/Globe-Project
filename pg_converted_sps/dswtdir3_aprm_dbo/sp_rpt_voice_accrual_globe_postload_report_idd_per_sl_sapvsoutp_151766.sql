CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutp(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "SAP VENDOR CODE", currency, direction, "Sum of SETTABLE DURATION", "Sum of NET SETTABLE AMT", "Sum of Quantity (Settable duration)", "Sum of Amount in USD", "Difference Duration", "Difference Amount"
        FROM (SELECT
            1 AS sortorder, *
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache AS x
            WHERE LOWER(x."SAP VENDOR CODE") <> LOWER('TOTAL')
        UNION ALL
        SELECT
            2 AS sortorder, *
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache AS x
            WHERE LOWER(x."SAP VENDOR CODE") = LOWER('TOTAL')) AS xx
        ORDER BY sortorder NULLS FIRST, direction NULLS FIRST, "SAP VENDOR CODE" NULLS FIRST;
END;
$procedure$
