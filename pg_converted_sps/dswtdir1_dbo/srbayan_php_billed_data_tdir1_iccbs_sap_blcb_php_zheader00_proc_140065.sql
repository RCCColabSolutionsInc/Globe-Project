CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zheader00_proc()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/19/2020 10:48:10 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Billed_Data_TDIR1_ICCBS_sap_blcb_PHP:sap_blcb_PHP:zHeader00_Processing_Time
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_php_zheader00_processing_timeupdsel
    SET zheader00_processing_time = zheader00_processing_timenew;
END;
$procedure$
