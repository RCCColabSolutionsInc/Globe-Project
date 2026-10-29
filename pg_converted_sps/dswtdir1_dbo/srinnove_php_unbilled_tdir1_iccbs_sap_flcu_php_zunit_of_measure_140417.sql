CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zunit_of_measure()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 6:19:41 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Unbilled_TDIR1_ICCBS_sap_flcu_PHP:sap_flcu_PHP:zUnit_of_measurement
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zunit_of_measurementupdsel
    SET zunit_of_measurement = zunit_of_measurementnew;
END;
$procedure$
