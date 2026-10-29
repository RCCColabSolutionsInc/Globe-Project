CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_delta_bayan_postload_report_comparison_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Final DURATION", "Final SETTABLE AMT", "Accrual DURATION", "Accrual SETTABLE AMT", "Delta DURATION", "Delta SETTABLE AMT", "Difference FvA Duration", "Difference FvA SETTABLE AMT", "Difference F-AvD Duration", "Difference F-AvD SETTABLE AMT", "Output Duration", "Output Amount", "Difference in Duration", "Difference in SETTABLE AMT"
        FROM dswtdir3_aprm_dbo.rpt_voice_delta_bayan_postload_report_comparison_cache
        ORDER BY 1 NULLS FIRST, 2 NULLS FIRST;
END;
$procedure$
