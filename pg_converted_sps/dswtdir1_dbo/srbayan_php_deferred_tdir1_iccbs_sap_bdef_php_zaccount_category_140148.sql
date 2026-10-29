CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zaccount_category()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 11:10:18 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zAccount_Category
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zaccount_categoryupdsel
    SET zaccount_category = zaccount_categorynew;
END;
$procedure$
