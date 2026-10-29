CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_output_zloaded_ttmemoapp_dcs_postload_1del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 12/23/2020
Modified by: Elakki K 12/23/2020
Description: Delete Data from ttMemoApp_DCS_Postload table
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemoapp_dcs_output_zloaded_ttmemoapp_dcs_postload_1delsel;
END;
$procedure$
