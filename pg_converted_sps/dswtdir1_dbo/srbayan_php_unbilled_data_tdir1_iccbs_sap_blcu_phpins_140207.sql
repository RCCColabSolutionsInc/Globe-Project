CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_phpins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/03/2020
Modified by: Sindhuja Beram 09/03/2020
Description: Source to Target Insert
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttbayan_php_unbilled_data (z_upld_filename, zaccount_category, zactive, "zAmount ", zcontrol99_zamount, zcontrol99_zcurrency, zcontrol99_zrecord, zcontrol99_zrecordcount, "zCurrency ", zcust_class_code, zdocument_date, zdsp_order, zdsp_uniquekey, zduplicate, zduration, zerror, zfranchise_area, zheader00_batch_number, zheader00_event, zheader00_processing_date, zheader00_processing_time, zheader00_record_id, zheader00_source_system, zheader00_target_system, zlegacyzdsp_order, zlegacyzrecord, "zMarket_Segment ", zposting_date, zproduct_group, zrecord, zrevenue_item_code, zrevenue_type, "zService_Type ", zsource, zunit_of_measurement)
    SELECT
        z_upld_filename, zaccount_category, zactive, "zAmount ", zcontrol99_zamount, zcontrol99_zcurrency, zcontrol99_zrecord, zcontrol99_zrecordcount, "zCurrency ", zcust_class_code, zdocument_date, zdsp_order, zdsp_uniquekey, zduplicate, zduration, zerror, zfranchise_area, zheader00_batch_number, zheader00_event, zheader00_processing_date, zheader00_processing_time, zheader00_record_id, zheader00_source_system, zheader00_target_system, zlegacyzdsp_order, zlegacyzrecord, "zMarket_Segment ", zposting_date, zproduct_group, zrecord, zrevenue_item_code, zrevenue_type, zservice_type, zsource, zunit_of_measurement
        FROM dswtdir1_dbo.srbayan_php_unbilled_data_tdir1_iccbs_sap_blcu_phpinssel;
END;
$procedure$
