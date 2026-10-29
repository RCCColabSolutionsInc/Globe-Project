CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_php_zlegacyzdsp_orderupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:10 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zLegacyzDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_bdef_php_zlegacyzdsp_orderupdsel
    SET zlegacyzdsp_order = zlegacyzdsp_ordernew;
END;
$procedure$
