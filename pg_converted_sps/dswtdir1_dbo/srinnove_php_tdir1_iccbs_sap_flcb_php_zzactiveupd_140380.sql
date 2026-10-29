CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zzactiveupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/27/2020 2:53:26 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_TDIR1_ICCBS_sap_flcb_PHP:#SOURCEDATABASEOBJECT#:zActive
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zzactiveupdsel
    SET zzactive = zzactivenew;
END;
$procedure$
