CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_usd_billed_preload_transform02_volvooss()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Data loading */
    /* Data source 1 - Volvo for */
    TRUNCATE TABLE dswtdir1_dbo.stinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss;
    INSERT INTO dswtdir1_dbo.stinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss (column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, zrownumber)
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, zrownumber
        FROM sdbtdir1_iccbs_dbo.sap_falcon_billed_volvo_072020_oss_ssis;
    /* Data transformations */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zlegacyzdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zlegacyzrecordupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zdsp_orderupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zdocument_dateupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zposting_dateupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcust_class_codeupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zaccount_categoryupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zfranchise_areaupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zservice_type_upd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zrevenue_item_codeupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcurrency_upd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zamount_upd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zmarket_segmentupd();
    /* Updates zMarketSegment */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zproduct_groupupd();
    /* Updates zProduct_Group */
    /* EXEC [dbo].[srInnove_USD_Billed_TDIR1_ICCBS_sap_falcon_billed_volvo_072020_oss_zAmountNew_Upd] --Update Target from Source */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zamountnew_upd_ssis();
    /* Update Target from Source. Winds */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zidentifierupd();
    /* Update Target from Source */
    /* EXEC [dbo].[srInnove_USD_Billed_TDIR1_ICCBS_sap_falcon_billed_volvo_072020_oss_zActiveUpd] -- */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zactiveupd_ssis();
    /* Update from source. Winds */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zactive2upd();
    /* Updates zActive for Header and Footer */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_record_idupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_source_systemupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_target_systemupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_eventupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_batch_numberupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_processing_dateupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zheader00_processing_timeupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zrecordupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zcurrencyupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zrecordcountupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zcontrol99_zamountupd();
    /* */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zfranchise_area_a_whnblnkorzeroupd();
    /* Updates zFranchise_Area to A when blank or zero */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_oss_zdsp_uniquekeyupd();
    /* Updates zDSP_UniqueKey */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_ossdel();
    /* Target Delete by Source */
    CALL dswtdir1_dbo.srinnove_usd_billed_tdir1_iccbs_sap_falcon_billed_volvo_072020_ossins()
    /* Source to Target Insert */
    ;
END;
$procedure$
