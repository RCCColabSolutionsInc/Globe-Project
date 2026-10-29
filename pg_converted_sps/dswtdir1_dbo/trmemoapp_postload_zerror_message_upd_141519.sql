CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_zerror_message_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/06/2020
Modified by: Elakki K 09/14/2020
Description: Update zErrorMessage Flag
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_postload_zerror_message_updsel
    SET zerrormessage_load = zerrormessage_loadnew, zloaded = zloadednew;
END;
$procedure$
