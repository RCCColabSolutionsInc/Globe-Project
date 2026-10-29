CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_php_zheader00_batch_numberupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:11 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zHeader00_Batch_Number
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_bdef_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
