CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zdsp_orderupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/19/2020 12:56:13 PM
Specification: cMap:{Target Rules}::TargetTable:zDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
