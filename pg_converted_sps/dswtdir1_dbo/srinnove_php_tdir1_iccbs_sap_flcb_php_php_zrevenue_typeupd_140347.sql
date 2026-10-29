CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_php_zrevenue_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/01/2020
Modified by: Sindhuja Beram 09/01/2020
Description: Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_php_zrevenue_typeupdsel
    SET zrevenue_type = zrevenue_typenew;
END;
$procedure$
