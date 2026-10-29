CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_postload_report_prepare_idd_per_sl_sapvsoutput_usd();
    CALL dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_postload_report_prepare_per_sl_sapvsoutput_php();
END;
$procedure$
