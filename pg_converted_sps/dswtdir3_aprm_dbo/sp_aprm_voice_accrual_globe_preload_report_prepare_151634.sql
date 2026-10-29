CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_amdocsvsbilling();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_preload();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_analysis_per_partner_detailed();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_analysis_per_partner_sapvsaur();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_analysis_per_partner();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_tending_1_sapvsaur();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_variancereportvsextract();
END;
$procedure$
