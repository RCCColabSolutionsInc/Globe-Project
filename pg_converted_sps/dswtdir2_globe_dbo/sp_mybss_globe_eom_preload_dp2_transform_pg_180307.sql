CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_transform_pg()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:      Winston Madiano                  */
/* Create date: February 13, 2023                */
/* Description: Data transformation              */
/* ============================================= */
BEGIN
    /* DSP Migrate equivalent */
    /* 1. Clear destination table */
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp2_unearned_tdir2_globe_saplairc;
    
    /* 2. Clean and insert new data */
    RAISE NOTICE 'Insert to initial staging table';
    
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column7 = etl_db_dbo.fn_trimspaces(column7);
    
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column7 = CAST(CAST(column7 AS NUMERIC(18, 2)) AS VARCHAR(50))
    WHERE LOWER(column1) = '01';
        
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column8 = NULL
    WHERE LOWER(column8) = '';
        
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column9 = NULL
    WHERE LOWER(column9) = '';
        
    UPDATE sdbtdir2_globe_dbo.sap_airc
    SET column10 = NULL
    WHERE LOWER(column10) = '';
        
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp2_unearned_tdir2_globe_saplairc (
        zrownumber, column1, column2, column3, column4, column5, 
        column6, column7, column8, column9, column10
    )
    SELECT
        zrownumber, column1, column2, column3, column4, column5, 
        column6, column7, column8, column9, column10
    FROM sdbtdir2_globe_dbo.sap_airc AS x
    WHERE LOWER(column1) IN ('00', '01', '99')
    ORDER BY x.zrownumber NULLS FIRST;
    
--    /* 3 Implement Source Rule */
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zlegacydsp_orderupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zdsp_orderupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zdataupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zposting_dateupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zsapfiglupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zctupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zstupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zch_codeupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zamountupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zccupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zgl_codeupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_znb_indupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zbrandupd();
--    
--    -- THIS IS THE CHILD PROCEDURE CAUSING THE ERROR:
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspaupd(); 
--    
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspa_rule2upd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zrev_typeupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspbupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zremarksupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zdsp_uniquekeyupd();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircdel();
--    CALL dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircins();
--    
--    /* Rules */
--    CALL dswtdir2_globe_dbo.trglobe_dp2_unearned_zloaded_1upd();
--    
--    /* Loaded Records */
--    /* Update all records as not loaded if any error */
--    CALL dswtdir2_globe_dbo.trglobe_dp2_unearned_zloaded_0_error_lineupd();

END;
$procedure$
