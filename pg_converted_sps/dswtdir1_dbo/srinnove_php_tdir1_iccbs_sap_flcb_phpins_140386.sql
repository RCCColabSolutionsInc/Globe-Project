CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_phpins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 10/15/2020 12:32:39 PM
Description: Insert sap_flcb_PHP into ttInnove_PHP
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttinnove_php (zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zactive, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource, zloaded, zload_message)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zactive, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource, zloaded, zload_message
        FROM dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_phpinssel;
END;
$procedure$
