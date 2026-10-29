CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_transform()
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 29, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_innove_dbo.stinnove_unbilled_char_tdir2_innove_sap_aiuc_i;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    /*
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column7] = [etl_db].[dbo].fn_TrimSpaces(Column7);
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column7] = CAST(CAST(Column7 as DECIMAL(18,2)) as NVARCHAR(50)) WHERE [Column1] = '01';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column8] = NULL WHERE [Column8]  = '';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column9] = NULL WHERE [Column9]  = '';
    UPDATE [sdbTDIR2_Globe].[dbo].[sap_airc]  SET [Column10] = NULL WHERE [Column10]  = '';
    */
    INSERT INTO dswtdir2_innove_dbo.stinnove_unbilled_char_tdir2_innove_sap_aiuc_i (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17)
    SELECT
        zrownumber AS zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17
        FROM sdbtdir2_innove_dbo.sap_aiuc_i AS x
        WHERE LOWER(column1) IN (LOWER('00'), LOWER('01'), LOWER('99'))
        ORDER BY x.zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zlegacydsp_orderupd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zdsp_orderupd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn01upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn02upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn03upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn04upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn05upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn06upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn07upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn08upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn09upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn10upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn11upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn12upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn13upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn14upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn15upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_column05_batchno_upd();
    /* Update Target from Source */
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn16upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zcolumn17upd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zdsp_uniquekeyupd();
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_idel();
    /* Target Delete by Source */
    CALL dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_iins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_innove_dbo.trinnove_unbilled_char_zloaded_1upd();
    /* Updates zloaded */
    CALL dswtdir2_innove_dbo.trinnove_unbilled_char_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
END;
$procedure$
