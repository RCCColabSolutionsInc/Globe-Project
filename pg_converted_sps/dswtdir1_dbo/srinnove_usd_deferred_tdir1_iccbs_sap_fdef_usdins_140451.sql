CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usdins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 10/15/2020 12:33:59 PM
Description: Insert sap_fdef_USD into ttInnove_USD_Deferred
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttinnove_usd_deferred (zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zactive, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource, zloaded, zload_message)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zactive, zduplicate, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource, zloaded, zload_message
        FROM dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usdinssel;
END;
$procedure$
