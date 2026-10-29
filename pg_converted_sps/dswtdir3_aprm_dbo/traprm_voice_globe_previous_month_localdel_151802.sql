CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/19/2021
Modified by: Pradeep Gupta 03/19/2021
Description: Deleting Local Trending Data
*/
BEGIN
    DELETE FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localdelsel;
END;
$procedure$
