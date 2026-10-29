CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zactiveupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/30/2020 6:26:30 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_TDIR1_ICCBS_sap_flcb_PHP:#SOURCEDATABASEOBJECT#:zActive
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zactiveupdsel*/
    /*SET zactive = zactivenew;*/
	UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php
    SET zactive = 1
    WHERE zactive IS NULL;
END;
$procedure$
