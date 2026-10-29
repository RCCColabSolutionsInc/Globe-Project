CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/19/2021
Modified by: Pradeep Gupta 03/19/2021
Description: Previous month for Local report Trending
*/
BEGIN
    INSERT INTO dswtdir3_aprm_dbo.ttaprm_voice_globe_previous_month_local (column1, column2, column3, column4, column5, "Event Direction")
    SELECT
        column1, column2, column3, column4, column5, "Event Direction"
        FROM dswtdir3_aprm_dbo.traprm_voice_globe_previous_month_localinssel;
END;
$procedure$
