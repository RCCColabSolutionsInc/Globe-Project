CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zsub_product_aupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 3/25/2021 4:51:19 AM
Specification: cMap:{Target Rules}::#SOURCEDATABASEOBJECT#:zSUB_PRODUCT_A
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zsub_product_aupdsel
    SET zsub_product_a = zsub_product_anew;
END;
$procedure$
