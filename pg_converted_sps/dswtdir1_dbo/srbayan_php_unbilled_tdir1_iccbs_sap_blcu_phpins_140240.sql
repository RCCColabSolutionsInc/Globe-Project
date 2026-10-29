CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 10/15/2020 12:37:49 PM
Description: Insert sap_blcu_PHP into ttBayan_PHP_unbilled
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttbayan_php_unbilled (zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zerror, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zdsp_uniquekey, z_upld_filename, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zsource, zloaded, zload_message)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zerror, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zdsp_uniquekey, z_upld_filename, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zsource, zloaded, zload_message
        FROM dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpinssel;
END;
$procedure$
