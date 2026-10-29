CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdurationupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 6:20:12 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_unbilled_TDIR1_ICCBS_sap_blcu_PHP:sap_blcu_PHP:zDuration
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdurationupdsel
    SET zduration = zdurationnew;
END;
$procedure$
