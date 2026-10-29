CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_scenario7_postload_zerrormessage_load_dcs_nopipe_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/08/2020
Modified by: Elakki K 09/08/2020
Description: Update zErrorMessage_DCS
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_scenario7_postload_zerrormessage_load_dcs_nopipe_updsel
    SET zerrormessage_load_dcs = zerrormessage_load_dcsnew;
END;
$procedure$
