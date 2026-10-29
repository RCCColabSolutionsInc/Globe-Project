CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_delta_globe_preload_report_variancereportvsextract(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Report DURATION", "Report SETTABLE AMT", "Extract DURATION", "Extract SETTABLE AMT", "Difference Duration", "Difference SETTABLE AMT"
        FROM dswtdir3_aprm_dbo.rpt_voice_delta_globe_preload_report_variancereportvsextract_delta2_cache
        ORDER BY 1 NULLS FIRST, 2 NULLS FIRST;
END;
$procedure$
