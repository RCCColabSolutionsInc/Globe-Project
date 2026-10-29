CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zcounterlineitemupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/17/2020 2:14:56 AM
Specification: cMap:{Target Rules}::TargetTable:zCounterLineItem
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zcounterlineitemupdsel
    SET zcounterlineitem = zcounterlineitemnew;
END;
$procedure$
