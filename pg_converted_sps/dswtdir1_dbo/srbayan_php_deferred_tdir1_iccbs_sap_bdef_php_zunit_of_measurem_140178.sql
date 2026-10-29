CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zunit_of_measurem()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 8:32:38 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zUnit_of_measurement
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zunit_of_measurementupdsel
    SET zunit_of_measurement = zunit_of_measurementnew;
END;
$procedure$
