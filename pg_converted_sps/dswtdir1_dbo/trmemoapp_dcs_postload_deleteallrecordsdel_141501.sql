CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_deleteallrecordsdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/30/2020
Modified by: Elakki K 09/30/2020
Description: Delete All Records from Table
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemoapp_dcs_postload_deleteallrecordsdelsel;
END;
$procedure$
