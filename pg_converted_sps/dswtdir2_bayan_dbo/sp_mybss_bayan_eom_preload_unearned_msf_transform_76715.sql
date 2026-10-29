CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unearned_msf_transform()
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Data transformation */
/* ============================================= */


/* ============================================= */
/* Modified by:		Zyril Madlangawa */
/* Modified date: October 20, 2026 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_bayan_dbo.stbayan_unearned_msf_tdir2_bayan_sap_airc_b;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    /*
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column7] = [etl_db].[dbo].fn_TrimSpaces(Column7);
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column7] = CAST(CAST(Column7 as DECIMAL(18,2)) as NVARCHAR(50)) WHERE [Column1] = '01';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column8] = NULL WHERE [Column8]  = '';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column9] = NULL WHERE [Column9]  = '';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column10] = NULL WHERE [Column10]  = '';
    */
    INSERT INTO dswtdir2_bayan_dbo.stbayan_unearned_msf_tdir2_bayan_sap_airc_b (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15)
    SELECT
        zrownumber AS zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15
        FROM sdbtdir2_bayan_dbo.sap_airc_b AS x
        WHERE LOWER(column1) IN (LOWER('00'), LOWER('01'), LOWER('99'))
        ORDER BY x.zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zlegacydsp_orderupd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zdsp_orderupd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn01upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn02upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn03upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn04upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn05upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn06upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn07upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn08upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn09upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn10upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn11upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn12upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn13upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn14upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn15upd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b__column05_batchno_upd();
    /* Updates Batch Number */
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zdsp_uniquekeyupd();
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_bdel();
    /* Target Delete by Source */
    CALL dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_bins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_bayan_dbo.trbayan_unearned_msf_zloaded_upd();
    /* Loaded Records 
    ;*/
END;
$procedure$
