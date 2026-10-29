CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_usd_billed_zdsp_orderupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/28/2020 1:06:19 PM
Specification: cMap:{Target Rules}::TargetTable:zDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.trinnove_usd_billed_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
