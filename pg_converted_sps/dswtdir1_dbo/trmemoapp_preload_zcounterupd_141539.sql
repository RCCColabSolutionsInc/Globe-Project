CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zcounterupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/17/2020 2:14:56 AM
Specification: cMap:{Target Rules}::TargetTable:zCounter
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zcounterupdsel
    SET zcounter = zcounternew;
END;
$procedure$
