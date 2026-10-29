CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_scenario7_postload_zerrormessage_load_dcs_reversalmes()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/09/2020
Modified by: Elakki K 09/09/2020
Description: Reversal Message
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_scenario7_postload_zerrormessage_load_dcs_reversalmessageupdsel
    SET zerrormessage_load = zerrormessage_loadnew, zerrormessage_load_dcs = zerrormessage_load_dcsnew;
END;
$procedure$
