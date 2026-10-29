CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_bayan_preload_report_prepare_variancerepo()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_preload_report_variancereportvsextract2_cache;
    INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_preload_report_variancereportvsextract2_cache (direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Report DURATION", "Report SETTABLE AMT", "Extract DURATION", "Extract SETTABLE AMT", "Difference Duration", "Difference SETTABLE AMT")
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Report DURATION", "Report SETTABLE AMT", "Extract DURATION", "Extract SETTABLE AMT", "Difference Duration", "Difference SETTABLE AMT"
        FROM dswtdir3_aprm_dbo.tvaprm_voice_bayan_variancereportvsextract2rptsel;
END;
$procedure$
