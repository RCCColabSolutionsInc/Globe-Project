CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_deleteallrecordsdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/23/2020
Modified by: Elakki K 09/23/2020
Description: Delete All Records From The Table
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemoapp_postload_deleteallrecordsdelsel;
END;
$procedure$
