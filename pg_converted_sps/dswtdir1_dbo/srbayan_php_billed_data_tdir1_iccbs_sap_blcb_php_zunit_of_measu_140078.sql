CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zunit_of_measu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 10:48:10 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Billed_Data_TDIR1_ICCBS_sap_blcb_PHP:sap_blcb_PHP:zUnit_of_measurement
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zunit_of_measurementupdsel
    SET zunit_of_measurement = zunit_of_measurementnew;
END;
$procedure$
