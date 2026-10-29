CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_basedonallerrorflags_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 08/24/2020
Modified by: Uma Guduru 08/24/2020
Description: Update zErrorMessage BasedOnAllErrorFlags
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_basedonallerrorflags_updsel
    SET zerrormessage = zerrormessagenew;
END;
$procedure$
