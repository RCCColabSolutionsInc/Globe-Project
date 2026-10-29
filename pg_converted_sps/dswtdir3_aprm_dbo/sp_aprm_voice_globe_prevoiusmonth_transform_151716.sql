CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_globe_prevoiusmonth_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localdel();	-- Deleting Local Trending Data
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localins();	-- Previous month for Local report Trending 
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerdel();	-- Deleting IDD Data
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerins();	-- Inserting IDD data
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detdel();	-- Deleting IDD Detailed per partner data
	CALL dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detins();	-- Inserting  IDD Detailed per partner data
END;
$procedure$
