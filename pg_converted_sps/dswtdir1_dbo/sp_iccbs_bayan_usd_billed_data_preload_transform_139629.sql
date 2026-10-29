CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_usd_billed_data_preload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* captue the data before transformation for logging purpose */
    /* temporarily only */
    /* for debbuging only, will be removed later */
    /* EXEC [dbo].[sp_ICCBS_Bayan_USD_Billed_Data_Preload_Transform_LoadData_Log]; */
    
    /* Data loading */
    TRUNCATE TABLE dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd;
    CALL dswtdir1_dbo.sp_iccbs_bayan_usd_billed_data_preload_transform_loaddata$TMP();
    INSERT INTO dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13)
    SELECT
        *
        FROM sp_iccbs_bayan_usd_billed_data_preload_transform_loaddata$TMPTBL;
    /* Rules */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zlegacyzdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zlegacyzrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zposting_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zdocument_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zaccount_categoryupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zfranchise_areaupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcurrency_upd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zamount_upd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zproduct_group_zservice_typeupd();
    /* Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zactiveupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zactive_zproductgroupupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zactive_zaccount_categoryupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_record_idupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_source_systemupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_target_systemupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_eventupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_batch_numberupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_processing_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_processing_timeupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zcurrencyupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zrecordcountupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zamountupd();
    /* */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcust_class_codeupd();
    /* Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zmarket_segmentupd();
    /* Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zrevenue_item_code_zffi_rev_servupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zrevenue_typeupd();
    /* Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zrevenue_type_zffi_rev_servupd();
    /* Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zfranchise_area_a_whnblnkorzeroupd();
    /* Updates zFranchise_Area to A when blank or zero */
    /* EXEC [dbo].[srBayan_USD_Billed_Data_TDIR1_ICCBS_sap_blcb_USD_zDuration_withzActiveUpd] --Update Target from Source */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zduration_withzactiveupd_v2();
    /* Update Target from Source. updated by winds */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zdsp_uniquekeyupd();
    /* Updates zDSP_UniqueKey */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usddel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usdins();
    /* Source to Target Insert */
    /* Other rules */
    /* temporary disabled for the purpose of testing */
    CALL dswtdir1_dbo.trbayan_usd_billed_datazerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_usd_billed_data_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_usd_billed_data_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_usd_billed_data_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
