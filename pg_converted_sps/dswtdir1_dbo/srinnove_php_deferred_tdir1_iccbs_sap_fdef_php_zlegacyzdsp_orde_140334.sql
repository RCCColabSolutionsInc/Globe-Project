CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zlegacyzdsp_orde()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/18/2020 12:57:17 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Deferred_TDIR1_ICCBS_sap_fdef_PHP:sap_fdef_PHP:zLegacyzDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zlegacyzdsp_orderupdsel
    SET zlegacyzdsp_order = zlegacyzdsp_ordernew;
END;
$procedure$
