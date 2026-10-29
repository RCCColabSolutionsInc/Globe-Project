CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcust_class_codeu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/31/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcust_class_codeupdsel
    SET zcust_class_code = zcust_class_codenew;
END;
$procedure$
