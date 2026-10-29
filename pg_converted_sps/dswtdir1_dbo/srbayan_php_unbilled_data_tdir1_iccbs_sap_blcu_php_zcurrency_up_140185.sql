CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zcurrency_up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/3/2020 12:51:40 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Unbilled_Data_TDIR1_ICCBS_sap_blcu_PHP:sap_blcu_PHP:zCurrency
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zcurrency_updsel
    SET "zCurrency " = "zCurrency New";
END;
$procedure$
