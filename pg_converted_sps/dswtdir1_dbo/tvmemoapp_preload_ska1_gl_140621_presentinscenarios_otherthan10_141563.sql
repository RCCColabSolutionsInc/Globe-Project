CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_140621_presentinscenarios_otherthan10()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Elakki K 03/25/2021
Description: GL 140261 Is allowed only for Scenario 10 #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_140621_presentinscenarios_otherthan10updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
