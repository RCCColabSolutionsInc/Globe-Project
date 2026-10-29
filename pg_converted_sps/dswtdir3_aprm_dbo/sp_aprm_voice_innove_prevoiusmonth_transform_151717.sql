CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_innove_prevoiusmonth_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	CALL dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pmdel();
	CALL dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pmins();
END;
$procedure$
