CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_amdocsvsbilling_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        "Home Partner", "Partner Code", "Charge direction", "Amdocs Total Duration", "Billing Total Duration", "Amdocs Total Net Charge", "Billing Total Net Charge", "A v B Difference Duration", "A v B Difference Net Charge"
        FROM (SELECT
            "Home Partner", "Partner Code", "Charge direction", "Amdocs Total Duration", "Billing Total Duration", "Amdocs Total Net Charge", "Billing Total Net Charge", "A v B Difference Duration", "A v B Difference Net Charge", 0 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache
            WHERE LOWER("Home Partner") <> LOWER('Total')
        UNION ALL
        SELECT
            "Home Partner", "Partner Code", "Charge direction", "Amdocs Total Duration", "Billing Total Duration", "Amdocs Total Net Charge", "Billing Total Net Charge", "A v B Difference Duration", "A v B Difference Net Charge", 1 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache
            WHERE LOWER("Home Partner") = LOWER('Total')) AS xx
        ORDER BY sort NULLS FIRST, "Charge direction" NULLS FIRST, "Home Partner" NULLS FIRST, "Partner Code" NULLS FIRST;
END;
$procedure$
