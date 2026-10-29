CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_globe_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
CALL dbo.sp_aprm_voice_delta_globe_postload_report_prepare_comparison_output();
END;
$procedure$
