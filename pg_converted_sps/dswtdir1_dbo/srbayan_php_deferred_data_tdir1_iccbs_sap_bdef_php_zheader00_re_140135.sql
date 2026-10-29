CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zheader00_re()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/22/2020 6:15:16 PM
Specification: cMap:TDIR1_ICCBS:stBayan_PHP_Deferred_Data_TDIR1_ICCBS_sap_bdef_PHP:sap_bdef_PHP:zHeader00_Record_ID
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_data_tdir1_iccbs_sap_bdef_php_zheader00_record_idupdsel
    SET zheader00_record_id = zheader00_record_idnew;
END;
$procedure$
