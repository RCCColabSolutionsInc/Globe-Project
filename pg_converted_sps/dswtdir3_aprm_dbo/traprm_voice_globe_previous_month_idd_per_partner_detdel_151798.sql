CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/30/2021
Modified by: Pradeep Gupta 04/05/2021
Description: Deleting IDD Detailed per partner data
*/
BEGIN
    DELETE FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partner_detdelsel;
END;
$procedure$
