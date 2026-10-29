CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zproponentupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/17/2020 2:20:48 AM
Specification: cMap:{Target Rules}::TargetTable:zProponent
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zproponentupdsel
    SET zproponent = zproponentnew;
END;
$procedure$
