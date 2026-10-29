CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_pipeseparator_getdateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/09/2020
Modified by: Elakki K 09/09/2020
Description: Update with Pipe Separator for Date and Time in Getdate
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_pipeseparator_getdateupdsel
    SET zdsp_uniquekey = zdsp_uniquekeynew;
END;
$procedure$
