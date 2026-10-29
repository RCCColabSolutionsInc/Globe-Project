CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zc()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/23/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zc
    SET zcust_class_code = zcu_class_codenew;
END;
$procedure$
