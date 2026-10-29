CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_deferred_preload_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$

BEGIN
    -- ==========================================================================
    -- Data loading: Clear staging table at start
    -- ==========================================================================
    TRUNCATE TABLE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php;

    -- ==========================================================================
    -- INSERT DUMMY DATA INTO ST TABLE
    -- ==========================================================================
    INSERT INTO dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php (
        zrownumber, 
        column1, 
        column2, 
        column3, 
        column4, 
        column5, 
        column6, 
        column7, 
        column8, 
        column9, 
        column10, 
        column11
    ) VALUES
    -- Header Records
    ('1', '00', 'AMAR', 'SAPFIGL', 'ARBC', '1679', '04072026', '210415', NULL, NULL, NULL, NULL),
    ('2', '00', 'AMAR', 'SAPFIGL', 'ARBC', '1680', '08072026', '221247', NULL, NULL, NULL, NULL),
    
    -- Transaction Records
    ('3', '01', '06/30/2026', '1', 'C', 'BBWL', 'MSFFH_1299100MU', NULL, '-2319.64', '0.00', 'PHP', '100.00'),
    ('4', '01', '07/05/2026', '1', 'C', 'BBWL', 'TX1', NULL, '3938.27', '0.00', 'PHP', '250.00'),
    ('5', '01', '07/10/2026', '1', 'C', 'BBWL', 'TX1', NULL, '310.50', '0.00', 'PHP', '500.00'),
    
    -- Control/Footer Records (01 Amount matches 99 record sum context)
    ('6', '99', 'PHP', '3', '850.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

    -- ==========================================================================
    -- Data transformations (Commented out/Skipped for Dummy Preload)
    -- ==========================================================================
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zlegacyzdsp_orderupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zlegacyzrecordupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zdsp_orderupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrecordupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zposting_dateupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zdocument_dateupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zaccount_categoryupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_areaupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcurrency_upd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zamount_upd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_record_idupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_source_systemupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_target_systemupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_eventupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_batch_numberupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_processing_dateupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_processing_timeupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zrecordupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zcurrencyupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zrecordcountupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zamountupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcust_class_codeupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zproduct_groupupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zservice_typeupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zmarket_segmentupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_item_code_zffi_rev_servupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_typeupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zrevenue_type_zffi_rev_servupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zfranchise_area_a_whnblnkorzeroupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zactiveupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zdsp_uniquekeyupd(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_phpdel(); */
    /* CALL dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_phpins(); */
    /* CALL dswtdir1_dbo.trinnove_php_deferred_zerrorupd(); */
    /* CALL dswtdir1_dbo.trinnove_php_deferred_zloadedupd(); */
    /* CALL dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_messageupd(); */
    /* CALL dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupd(); */

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Table validation failed: %', SQLERRM;
END;
$procedure$
