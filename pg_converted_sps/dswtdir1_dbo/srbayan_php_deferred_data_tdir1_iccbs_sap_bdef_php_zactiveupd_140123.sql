CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zactiveupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/22/2020 6:15:15 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_Data_TDIR1_ICCBS_sap_bdef_PHP:#SOURCEDATABASEOBJECT#:zActive
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zactiveupdsel
    SET zactive = zactivenew;
END;
$procedure$
