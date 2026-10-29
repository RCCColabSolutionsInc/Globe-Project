CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/22/2021
Modified by: Pradeep Gupta 03/22/2021
Description: Deleting IDD Data
*/
BEGIN
    DELETE FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_idd_per_partnerdelsel;
END;
$procedure$
