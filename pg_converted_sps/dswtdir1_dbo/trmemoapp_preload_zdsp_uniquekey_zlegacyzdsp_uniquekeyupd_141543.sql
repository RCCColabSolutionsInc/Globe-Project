CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_zlegacyzdsp_uniquekeyupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/22/2021
Modified by: Elakki K 03/22/2021
Description: Update zDSP Unique Key From zLegacy DSP Unique Key
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_zlegacyzdsp_uniquekeyupdsel
    SET zdsp_uniquekey = zdsp_uniquekeynew;
END;
$procedure$
