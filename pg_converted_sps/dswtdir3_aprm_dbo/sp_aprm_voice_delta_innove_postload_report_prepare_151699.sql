CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_postload_report_prepare_comparison();
END;
$procedure$
