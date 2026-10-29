CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/26/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;
END;
$procedure$
