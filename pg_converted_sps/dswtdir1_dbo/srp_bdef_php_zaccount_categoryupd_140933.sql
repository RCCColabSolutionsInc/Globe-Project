CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_php_zaccount_categoryupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:11 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zAccount_Category
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_bdef_php_zaccount_categoryupdsel
    SET zaccount_category = zaccount_categorynew;
END;
$procedure$
