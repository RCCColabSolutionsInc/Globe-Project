CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_insert_preloadvalid_recordsins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  BOAADMIN SUPPORT 08/06/2020
Modified by: BOAADMIN SUPPORT 08/06/2020
Description: test
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttmemoapp_postload (zlegacyzcounter)
    SELECT
        zlegacyzcounter
        FROM dswtdir1_dbo.trMEMOAPP_Postload_Insert_PreloadValid_RecordsInsSel;
END;
$procedure$
