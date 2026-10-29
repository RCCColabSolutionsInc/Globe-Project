CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 8, 2023 */
/* Description: Data transformation */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g;
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column7 = etl_db_dbo.fn_trimspaces(column7);
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column7 = CAST (CAST (column7 AS NUMERIC(18, 2)) AS VARCHAR(50))
        WHERE LOWER(column1) = LOWER('01');
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column8 = NULL
        WHERE LOWER(column8) = LOWER('');
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column9 = NULL
        WHERE LOWER(column9) = LOWER('');
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column10 = NULL
        WHERE LOWER(column10) = LOWER('');
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column11 = NULL
        WHERE LOWER(column11) = LOWER('');
    UPDATE sdbtdir2_globe_dbo.sap_aiuc_g
    SET column12 = NULL
        WHERE LOWER(column12) = LOWER('');
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g (zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12)
    SELECT
        zrownumber, column1, column2, column3, column4, column5, column6,
        CASE
            WHEN LOWER(column1) = LOWER('01') THEN CAST (CAST (column7 AS NUMERIC(18, 2)) AS VARCHAR(50))
            ELSE column7
            /* CAST(CAST(Column7 as DECIMAL(18,2)) as NVARCHAR(50)) */
        END AS column7, column8, column9, column10, column11, column12
        FROM sdbtdir2_globe_dbo.sap_aiuc_g
        WHERE LOWER(column1) IN (LOWER('00'), LOWER('01'), LOWER('99'))
        ORDER BY zrownumber NULLS FIRST;
    /* 3 Implement Source Rule */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zlegacydsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zdsp_orderupd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zposting_dateupd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zsum_of_amountupd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zctupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zdiffupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zspaupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zrev_typeupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zgl_zspbupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_ztax_rateupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_znet_of_taxupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zremarkupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn01upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn02upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn03upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn04upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn05upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn06upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn07upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn08upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn09upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn10upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn11upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zcolumn12upd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zdsp_uniquekeyupd();
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zactiveupd();
    /* Update Target from Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_gdel();
    /* Target Delete by Source */
    CALL dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_gins();
    /* Source to Target Insert */
    /* Rules */
    CALL dswtdir2_globe_dbo.trglobe_dp3_unbilled_char_zloaded_1upd();
    /* Loaded Records */
    CALL dswtdir2_globe_dbo.trglobe_dp3_unbilled_char_zloaded_0_error_lineupd()
    /* Update all records as not loaded if any error */
    ;
END;
$procedure$
