CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_addedbyupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/17/2020 2:14:55 AM
Specification: cMap:{Target Rules}::#SOURCEDATABASEOBJECT#:AddedBy
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_addedbyupdsel
    SET addedby = addedbynew;
END;
$procedure$
