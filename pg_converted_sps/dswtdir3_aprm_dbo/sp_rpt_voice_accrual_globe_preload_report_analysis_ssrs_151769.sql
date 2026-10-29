CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_analysis_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
        FROM (SELECT
            *, 0 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
            WHERE (LOWER(column11) = LOWER('Mins'))
        UNION ALL
        SELECT
            *, 1 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
            WHERE (LOWER(column5) = LOWER('Sum of SETTABLE DURATION'))
        UNION ALL
        SELECT
            *, 2 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
            WHERE (LOWER(COALESCE(column1, '')) <> LOWER('') AND LOWER(column1) NOT LIKE LOWER('%Total%'))
        UNION ALL
        SELECT
            *, 3 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
            WHERE (LOWER(column1) LIKE LOWER('%Total%'))) AS xx
        ORDER BY sort NULLS FIRST, 1 NULLS FIRST, 2 NULLS FIRST, 4 NULLS FIRST, 3 NULLS FIRST;
END;
$procedure$
