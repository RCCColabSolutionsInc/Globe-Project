CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_bayan_prevoiusmonth_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	CALL dswtdir3_aprm_dbo.traprm_voice_bayan_previous_month_sap_report_byn_accrual_pmdel();	-- Delete the Data From Previous Month
	CALL dswtdir3_aprm_dbo.traprm_voice_bayan_previous_month_sap_report_byn_accrual_pmins();	-- Insert Current Month Data into Previous Month Table
END;
$procedure$
