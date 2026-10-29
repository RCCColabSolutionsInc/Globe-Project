CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_php_zheader00_processing_dateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:11 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zHeader00_Processing_Date
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_bdef_php_zheader00_processing_dateupdsel
    SET zheader00_processing_date = zheader00_processing_datenew;
END;
$procedure$
