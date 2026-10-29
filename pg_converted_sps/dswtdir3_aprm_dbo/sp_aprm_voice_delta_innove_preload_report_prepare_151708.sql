CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare_comparison();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare_negativeamount_preload();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare_positiveamount_preload();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare_variancereportvsextract_delta2();
END;
$procedure$
