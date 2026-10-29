CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_php_zheader00_processing_timeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:11 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zHeader00_Processing_Time
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_bdef_php_zheader00_processing_timeupdsel
    SET zheader00_processing_time = zheader00_processing_timenew;
END;
$procedure$
