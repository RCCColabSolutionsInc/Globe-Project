CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zheader00_ba()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/3/2020 12:51:41 AM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Unbilled_Data_TDIR1_ICCBS_sap_blcu_PHP:sap_blcu_PHP:zHeader00_Batch_Number
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
