CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_usd_deferred_preload_transform()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    /* Data loading */
    TRUNCATE TABLE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd;
    INSERT INTO dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11)
    SELECT
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11
        FROM sdbtdir1_iccbs_dbo.sap_fdef_usd_ssis;
    /* Data transformations */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zlegacyzdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zlegacyzrecordupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zdocument_dateupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zposting_dateupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zaccount_categoryupd();
    /* Updates zAccount_Category as column4 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zfranchise_areaupd();
    /* Updates zFranchise_Area as column5 from flat-file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcurrency_upd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zamount_upd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_record_idupd();
    /* Updates Header recordID as column1 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_source_systemupd();
    /* Updates Header Source_System as column2 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_target_systemupd();
    /* Updates Header Target_System  as column3 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_eventupd();
    /* Updates Header Event as column 4 from flat-file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_batch_numberupd();
    /* Updates HeaderBatch Number as column5 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_processing_dateupd();
    /* Updates Header Processing Date as column6 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_processing_timeupd();
    /* Updates Header Processing_Time as column7 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zrecordupd();
    /* Updates Footer recordID as column1 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zcurrencyupd();
    /* Updates Footer zCurrency as column2 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zrecordcountupd();
    /* Updates Footer zRecordCount as column3 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zamountupd();
    /* Updates Footer zAmount as column4 from flat file sap_fdef_USD */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcust_class_codeupd();
    /* Updates zCust_Class_Code based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zproduct_groupupd();
    /* Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zservice_typeupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zmarket_segmentupd();
    /* Updates zMarket_Segment based on zProduct_Group , zService_Type from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_item_code_zffi_rev_servupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_typeupd();
    /* Updates zRevenue_Type  based on zProduct_Group , zService Type  from ZFFI_PROD_SERV */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zrevenue_type_zffi_rev_servupd();
    /* Update Target from Source */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zfranchise_area_a_whnblnkorzeroupd();
    /* Updates zFranchise_Area to A when blank or zero */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zdsp_uniquekeyupd();
    /* Updates zDSP_UniqueKey */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usddel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usdins();
    /* Source to Target Insert */
    /* temporary disabled for the purpose of testing */
    
    /* More rules */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zerrorupd();
    /* Rule to check sum of 01 Amount matches 99 record sum */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zloadedupd();
    /* Update zLoaded Flag */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_messageupd();
    /* Update Load Log Message */
    CALL dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupd()
    /* Update Load Log Message for 2nd Document Number */
    ;
END;
$procedure$
