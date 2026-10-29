CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zaccount_categor()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 6:19:41 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Unbilled_TDIR1_ICCBS_sap_flcu_PHP:sap_flcu_PHP:zAccount_Category
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zaccount_categoryupdsel
    SET zaccount_category = zaccount_categorynew;
END;
$procedure$
