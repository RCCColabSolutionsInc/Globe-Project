CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/28/2020 1:06:15 PM
Description: Insert TDIR1_ICCBS_oss into ttInnove_USD_Billed
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttinnove_usd_billed (zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zquantity, zduplicate, zidentifier, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zdsp_order, zrecord, zposting_date, zdocument_date, zcust_class_code, zaccount_category, zfranchise_area, zproduct_group, "zService_Type ", "zMarket_Segment ", zrevenue_item_code, "zCurrency ", "zAmount ", zduration, zunit_of_measurement, zrevenue_type, zquantity, zduplicate, zidentifier, zheader00_record_id, zheader00_source_system, zheader00_target_system, zheader00_event, zheader00_batch_number, zheader00_processing_date, zheader00_processing_time, zcontrol99_zrecord, zcontrol99_zcurrency, zcontrol99_zrecordcount, zcontrol99_zamount, zdsp_uniquekey, z_upld_filename, zerror, zsource
        FROM dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_ossinssel;
END;
$procedure$
