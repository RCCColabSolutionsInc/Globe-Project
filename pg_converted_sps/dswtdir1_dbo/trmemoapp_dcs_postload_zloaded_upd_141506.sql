CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 11/23/2020
Modified by: Elakki K 11/23/2020
Description: zLoaded - Loaded Records
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_updsel
    SET zloaded = zloadednew;
END;
$procedure$
