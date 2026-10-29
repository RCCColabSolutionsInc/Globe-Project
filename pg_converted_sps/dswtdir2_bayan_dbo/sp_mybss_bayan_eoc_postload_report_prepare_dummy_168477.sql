CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_prepare_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5) := par_cyclecode;
BEGIN
    -- =========================================================================
    -- 0. SCHEMA REFRESH (SELF-HEALING)
    -- Forcefully dropping existing tables to ensure no old/bad schemas persist,
    -- then recreating them using EXACT legacy MSSQL table names.
    -- Table names are 60 characters, fitting safely within PostgreSQL's 63-char limit.
    -- =========================================================================
    
    DROP TABLE IF EXISTS dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache;
    CREATE TABLE dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (
        column01 VARCHAR(20), column02 VARCHAR(253), column03 VARCHAR(254), 
        column04 VARCHAR(255), column05 VARCHAR(256), column06 VARCHAR(257), 
        column07 VARCHAR(258), column08 VARCHAR(259), column09 VARCHAR(260), 
        column10 VARCHAR(261), column11 VARCHAR(262), column12 VARCHAR(263), 
        column13 VARCHAR(264), column14 VARCHAR(265), column15 VARCHAR(266), 
        column16 VARCHAR(255), column17 VARCHAR(255), column18 VARCHAR(255), 
        column19 VARCHAR(255), zdsp_order VARCHAR(251), zdsp_uniquekey VARCHAR(44), 
        billcycle VARCHAR(5)
    );

    DROP TABLE IF EXISTS dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache;
    CREATE TABLE dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (
        column01 VARCHAR(20), column02 VARCHAR(253), column03 VARCHAR(254), 
        column04 VARCHAR(255), column05 VARCHAR(256), column06 VARCHAR(257), 
        column07 VARCHAR(258), column08 VARCHAR(259), column09 VARCHAR(260), 
        column10 VARCHAR(261), column11 VARCHAR(262), column12 VARCHAR(263), 
        column13 VARCHAR(264), column14 VARCHAR(265), column15 VARCHAR(266), 
        column16 VARCHAR(255), column17 VARCHAR(255), column18 VARCHAR(255), 
        column19 VARCHAR(255), zdsp_order VARCHAR(251), zdsp_uniquekey VARCHAR(44), 
        posting_log_message VARCHAR(1024), billcycle VARCHAR(5)
    );

    -- =========================================================================
    -- PHASE 1: BILLED ERROR CACHE PREPARATION (DUMMY)
    -- =========================================================================
    INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (
        column01, column02, column03, column04, column05, column06, column07, 
        column08, column09, column10, column11, column12, column13, column14, 
        column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, billcycle
    )
    SELECT 
        '01', 'ErrVal2_' || g.i, 'ErrVal3_' || g.i, 'ErrVal4_' || g.i, 'ErrVal5_' || g.i, 
        'ErrVal6_' || g.i, 'ErrVal7_' || g.i, 'ErrVal8_' || g.i, 'ErrVal9_' || g.i, 'ErrVal10_' || g.i, 
        'ErrVal11_' || g.i, 'ErrVal12_' || g.i, 'ErrVal13_' || g.i, 'ErrVal14_' || g.i, 'ErrVal15_' || g.i, 
        'ErrVal16_' || g.i, 'ErrVal17_' || g.i, 'ErrVal18_' || g.i, 'ErrVal19_' || g.i,
        CAST(g.i AS VARCHAR), 'ERR_UNIQ_' || g.i, v_billcycle
    FROM generate_series(1, 55) AS g(i);

    -- =========================================================================
    -- PHASE 2: BILLED VALID CACHE PREPARATION (DUMMY)
    -- =========================================================================
    INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (
        column01, column02, column03, column04, column05, column06, column07, 
        column08, column09, column10, column11, column12, column13, column14, 
        column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        '01', 'Val2_' || g.i, 'Val3_' || g.i, 'Val4_' || g.i, 'Val5_' || g.i, 
        'Val6_' || g.i, 'Val7_' || g.i, '-36.27', '0.00', 'Val10_' || g.i, 
        'Val11_' || g.i, 'Val12_' || g.i, 'Val13_' || g.i, 'Val14_' || g.i, 'Val15_' || g.i, 
        'Val16_' || g.i, 'Val17_' || g.i, 'Val18_' || g.i, 'Val19_' || g.i,
        CAST(g.i AS VARCHAR), 'VALID_UNIQ_' || g.i, 'Dummy Valid Message ' || g.i, v_billcycle
    FROM generate_series(1, 55) AS g(i);

    RAISE NOTICE 'Dummy Postload Report Prepare phase completed for %. 55 dummy records generated in EXACT legacy cache tables.', par_cyclecode;
END;
$procedure$
