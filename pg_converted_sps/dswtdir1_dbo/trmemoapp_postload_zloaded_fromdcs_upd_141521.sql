CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_zloaded_fromdcs_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 08/06/2020
Modified by: Saketh Venkata Nadurumati 08/06/2020
Description: Update zLoaded for DCS page
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_postload_zloaded_fromdcs_updsel
    SET zloaded = zloadednew;
END;
$procedure$
