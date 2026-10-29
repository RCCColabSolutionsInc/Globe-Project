CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_ttmemoapp_dcs_postload_1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 12/23/2020
Modified by: Elakki K 12/23/2020
Description: zLoaded - Update for table data
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_dcs_postload_zloaded_ttmemoapp_dcs_postload_1updsel
    SET zloaded = zloadednew;
END;
$procedure$
