CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_deferred_preload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Data loading */
    TRUNCATE TABLE dswtdir1_dbo.stbayan_php_deferred_tdir1_iccbs_sap_bdef_php;
    INSERT INTO dswtdir1_dbo.stbayan_php_deferred_tdir1_iccbs_sap_bdef_php (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13)
    SELECT
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
        FROM sdbtdir1_iccbs_dbo.sap_bdef_php_ssis;
    /* Rules */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zlegacyzdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zlegacyzrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zposting_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zdocument_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zaccount_categoryupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zfranchise_areaupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcurrency_upd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zamount_upd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zproduct_group_zservice_typeupd();
    /* Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zactiveupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zactive_zproductgroupupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_record_idupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_source_systemupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_target_systemupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_eventupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_batch_numberupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_processing_dateupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_processing_timeupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zcurrencyupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zrecordcountupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcontrol99_zamountupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zcust_class_codeupd();
    /* Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zmarket_segmentupd();
    /* Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrevenue_item_code_zffi_rev_servupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrevenue_typeupd();
    /* Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zrevenue_type_zffi_rev_servupd();
    /* Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zfranchise_area_a_whnblnkorzeroupd();
    /* Updates zFranchise_Area to A when blank or zero */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zdsp_uniquekeyupd();
    /* Updates zDSP_UniqueKey */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_phpdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_phpins();
    /* Source to Target Insert */
    /* Other rules */
    /* temporary disabled for the purpose of testing */
    CALL dswtdir1_dbo.trbayan_php_deferred_zerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_php_deferred_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_php_deferred_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_php_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
