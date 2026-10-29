CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_innove_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_preload_innove_report_prepare_preload();
	CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_preload_innove_report_prepare_comparison2();
	CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_preload_innove_report_prepare_variancereportvsextract2();
END;
$procedure$
