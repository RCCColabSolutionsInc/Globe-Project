CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zlegacyzdsp_uniquekey_pipeseparator_getdateup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/08/2020
Modified by: Elakki K 09/08/2020
Description: Update with Pipe Separator for Date and Time in Getdate
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zlegacyzdsp_uniquekey_pipeseparator_getdateupdsel
    SET zlegacyzdsp_uniquekey = zlegacyzdsp_uniquekeynew;
END;
$procedure$
