CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zcurrencyupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/30/2020 6:26:31 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_TDIR1_ICCBS_sap_flcb_PHP:sap_flcb_PHP:zControl99_zCurrency
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zcontrol99_zcurrencyupdsel
    SET zcontrol99_zcurrency = zcontrol99_zcurrencynew;
END;
$procedure$
