CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_phpins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 10/15/2020 12:37:31 PM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Billed_Data
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttbayan_php_billed_data (zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zerror, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zdsp_uniquekey, z_upld_filename, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zsource, zloaded, zload_message)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zerror, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zdsp_uniquekey, z_upld_filename, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zsource, zloaded, zload_message
        FROM dswtdir1_dbo.srbayan_php_billed_data_tdir1_iccbs_sap_blcb_phpinssel;
END;
$procedure$
