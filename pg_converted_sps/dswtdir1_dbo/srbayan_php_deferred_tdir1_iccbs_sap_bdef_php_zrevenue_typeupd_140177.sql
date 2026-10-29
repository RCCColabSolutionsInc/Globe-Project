CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/04/2020
Modified by: Swetha Neha 09/21/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;
END;
$procedure$
