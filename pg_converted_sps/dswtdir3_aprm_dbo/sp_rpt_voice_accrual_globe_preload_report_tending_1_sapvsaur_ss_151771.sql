CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_ss(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        event, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14
        FROM (SELECT
            event, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, 0 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
            WHERE LOWER(COALESCE(event, '')) = LOWER('')
        UNION ALL
        SELECT
            event, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, 1 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
            WHERE (LOWER(COALESCE(event, '')) <> LOWER('')) AND (LOWER(event) NOT LIKE LOWER('%Total%'))
        UNION ALL
        SELECT
            event, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, 2 AS sort
            FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
            WHERE (LOWER(event) LIKE LOWER('%Total%'))) AS xx
        ORDER BY sort NULLS FIRST, 1 NULLS FIRST, 2 NULLS FIRST, 3 NULLS FIRST;
END;
$procedure$
