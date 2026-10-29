CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zbrandupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 3/25/2021 4:51:13 AM
Specification: cMap:{Target Rules}::#SOURCEDATABASEOBJECT#:zBrand
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zbrandupdsel
    SET zbrand = zbrandnew;
END;
$procedure$
