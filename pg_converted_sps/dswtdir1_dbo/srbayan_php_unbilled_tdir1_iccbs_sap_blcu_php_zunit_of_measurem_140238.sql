CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zunit_of_measurem()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 6:20:12 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_unbilled_TDIR1_ICCBS_sap_blcu_PHP:sap_blcu_PHP:zUnit_of_measurement
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zunit_of_measurementupdsel
    SET zunit_of_measurement = zunit_of_measurementnew;
END;
$procedure$
