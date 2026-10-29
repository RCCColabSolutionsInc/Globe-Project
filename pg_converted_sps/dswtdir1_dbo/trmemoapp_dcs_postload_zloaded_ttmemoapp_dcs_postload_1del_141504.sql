CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_ttmemoapp_dcs_postload_1del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 12/23/2020
Modified by: Elakki K 12/23/2020
Description: Delete Records from the table
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trMEMOAPP_DCS_Postload_zLoaded_ttMEMOAPP_DCS_Postload_1DelSel;
END;
$procedure$
