CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zcurrency_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 6:19:53 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Billed_TDIR1_ICCBS_sap_blcb_PHP:sap_blcb_PHP:zCurrency
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zcurrency_updsel
    SET "zCurrency " = "zCurrency New";
END;
$procedure$
