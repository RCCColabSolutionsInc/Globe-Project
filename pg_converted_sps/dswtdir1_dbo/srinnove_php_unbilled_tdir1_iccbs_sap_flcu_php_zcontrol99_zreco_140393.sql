CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zcontrol99_zreco()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/19/2020 6:19:41 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Unbilled_TDIR1_ICCBS_sap_flcu_PHP:sap_flcu_PHP:zControl99_zRecord
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zcontrol99_zrecordupdsel*/
    /*SET zcontrol99_zrecord = zcontrol99_zrecordnew;*/
	UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zcontrol99_zreco
    SET zcontrol99_zrecordcount = zcontrol99_zrecordcountnew;
END;
$procedure$
