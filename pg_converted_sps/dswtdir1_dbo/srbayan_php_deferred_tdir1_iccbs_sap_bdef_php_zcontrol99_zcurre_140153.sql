CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zcurre()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 11:10:18 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zControl99_zCurrency
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zcurrencyupdsel
    SET zcontrol99_zcurrency = zcontrol99_zcurrencynew;
END;
$procedure$
