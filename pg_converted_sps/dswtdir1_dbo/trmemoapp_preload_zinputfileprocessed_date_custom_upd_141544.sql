CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_date_custom_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 08/19/2020
Modified by: Uma Guduru 08/19/2020
Description: update using currrent date for all sources
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_date_custom_updsel
    SET zinputfileprocessed_date = zinputfileprocessed_datenew;
END;
$procedure$
