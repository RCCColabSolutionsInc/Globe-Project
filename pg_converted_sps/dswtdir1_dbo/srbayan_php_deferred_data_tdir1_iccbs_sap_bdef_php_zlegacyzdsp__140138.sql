CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zlegacyzdsp_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/22/2020 6:15:14 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_Data_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zLegacyzDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zlegacyzdsp_orderupdsel
    SET zlegacyzdsp_order = zlegacyzdsp_ordernew;
END;
$procedure$
