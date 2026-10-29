CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zheader00_processing_time()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/30/2020 6:26:31 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_TDIR1_ICCBS_sap_flcb_PHP:sap_flcb_PHP:zHeader00_Processing_Time
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zheader00_processing_timeupdsel
    SET zheader00_processing_time = zheader00_processing_timenew;
END;
$procedure$
