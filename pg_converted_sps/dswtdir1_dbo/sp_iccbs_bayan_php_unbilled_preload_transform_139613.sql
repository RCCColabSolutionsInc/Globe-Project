CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_php_unbilled_preload_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Data loading */
    TRUNCATE TABLE dswtdir1_dbo.stbayan_php_unbilled_tdir1_iccbs_sap_blcu_php;
    INSERT INTO dswtdir1_dbo.stbayan_php_unbilled_tdir1_iccbs_sap_blcu_php (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13)
    SELECT
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
        FROM sdbtdir1_iccbs_dbo.sap_blcu_php_ssis;
    /* Rules */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zlegacyzdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zlegacyzrecordupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrecordupd();
    /* Updates zRecord as column1 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zposting_dateupd();
    /* Updates zPosting_Date as column2 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdocument_dateupd();
    /* Updates zDocument_Date as column2 from flat file sap_blcu_PHP Updates as column 3 for Header record */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zaccount_categoryupd();
    /* Updates zAccount_Category as column4 from flat file sap_blcu_PHP,  Updates as column 5 for Header record */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zfranchise_areaupd();
    /* Updates zFranchise_Area as column5 from flat-file sap_blcu_PHP , Updates as column 6 for Header record */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcurrency_upd();
    /* Updates zCurrency as column10 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zamount_upd();
    /* Updates zAmount as column11 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdurationupd();
    /* Updates zDuration as column12 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zunit_of_measurementupd();
    /* Updates zUnit_of_measurement as column13 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zproduct_group_zservice_typeupd();
    /* Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zactiveupd();
    /* Updates zActive */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zactive_zproductgroupupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_record_idupd();
    /* Updates Header recordID as column1 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_source_systemupd();
    /* Updates Header Source_System as column2 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_target_systemupd();
    /* Updates Header Target_System  as column3 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_eventupd();
    /* Updates Header Event as column 4 from flat-file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_batch_numberupd();
    /* Updates HeaderBatch Number as column5 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_processing_dateupd();
    /* Updates Header Processing Date as column6 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_processing_timeupd();
    /* Updates Header Processing_Time as column7 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zrecordupd();
    /* Updates Footer recordID as column1 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zcurrencyupd();
    /* Updates Footer zCurrency as column2 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zrecordcountupd();
    /* Updates Footer zRecordCount as column3 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcontrol99_zamountupd();
    /* Updates Footer zAmount as column4 from flat file sap_blcu_PHP */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zcust_class_codeupd();
    /* Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zmarket_segmentupd();
    /* Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrevenue_item_code_zffi_rev_servupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrevenue_typeupd();
    /* Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zrevenue_type_zffi_rev_servupd();
    /* Updates zRevenue_Item_Code & zRevenue_Type  based on zREvenue_Item_Code , zService Type  from ZFFI_REV_SERV */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zfranchise_area_a_whnblnkorzeroupd();
    /* Updates zFranchise Type to A when 0 or blank */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zdsp_uniquekeyupd();
    /* Updates zDSP_UniqueKey */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_phpins();
    /* Source to Target Insert */
    /* Other rules */
    /* temporary disabled for the purpose of testing */
    CALL dswtdir1_dbo.trbayan_php_unbilled_zerrorupd();
    /* Update zError when Total Amount matches with sum of individual amounts */
    CALL dswtdir1_dbo.trbayan_php_unbilled_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trbayan_php_unbilled_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trbayan_php_unbilled_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
