CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zcust_class_codehea()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Sindhuja Beram 08/26/2020
Description: Updates Header Footer -  zCust_Class_Code based on zProduct_Group , zService_Type
*/
BEGIN
    UPDATE dswtdir1_dbo.srBayan_PHP_Billed_TDIR1_ICCBS_sap_blcb_PHP_zCust_Class_CodeHeader_FooterUpdSel
    SET zCust_Class_Code = zCust_Class_CodeNew;
END;
$procedure$
