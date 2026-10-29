CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 3/25/2021 4:51:24 AM
Specification: cMap:{Target Rules}::#SOURCEDATABASEOBJECT#:zREVENUE_TYPE
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;
END;
$procedure$
