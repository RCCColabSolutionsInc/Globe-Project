CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_prepare_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_innove_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txInnove_Billed_Cycle2_LoadFileSel', 'txInnove_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txInnove_Billed_Cycle3_LoadFileSel', 'txInnove_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txInnove_Billed_Cycle4_LoadFileSel', 'txInnove_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txInnove_Billed_Cycle5_LoadFileSel', 'txInnove_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txInnove_Billed_Cycle6_LoadFileSel', 'txInnove_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txInnove_Billed_Cycle7_LoadFileSel', 'txInnove_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txInnove_Billed_Cycle8_LoadFileSel', 'txInnove_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txInnove_Billed_Cycle9_LoadFileSel', 'txInnove_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txInnove_Billed_Cycle10_LoadFileSel', 'txInnove_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txInnove_Billed_Cycle11_LoadFileSel', 'txInnove_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_innove_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    -- Try to resolve BillCycle, fallback to par_cyclecode
    SELECT billcycle INTO v_billcycle FROM dswtdir2_innove_dbo.billcycles WHERE cyclecode = par_cyclecode;
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);


    -- =========================================================================
    -- 1. SCHEMA REFRESH & BILLED ERROR CACHE PREPARATION (DUMMY)
    -- Legacy Name: rpt_Postload_Report_Prepare_DP1_Billed_Error_Cache (62 chars)
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_error_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (
        column01 VARCHAR(20), column02 VARCHAR(255), column03 VARCHAR(255), 
        column04 VARCHAR(255), column05 VARCHAR(255), column06 VARCHAR(255), 
        column07 VARCHAR(255), column08 VARCHAR(255), column09 VARCHAR(255), 
        column10 VARCHAR(255), column11 VARCHAR(255), column12 VARCHAR(255), 
        column13 VARCHAR(255), column14 VARCHAR(255), column15 VARCHAR(255), 
        column16 VARCHAR(255), column17 VARCHAR(255), column18 VARCHAR(255), 
        column19 VARCHAR(255), zdsp_order VARCHAR(255), zdsp_uniquekey VARCHAR(255), 
        billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (
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
    FROM generate_series(1, 15) AS g(i);

    -- =========================================================================
    -- 2. SCHEMA REFRESH & BILLED VALID CACHE PREPARATION (DUMMY)
    -- Legacy Name: rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache (62 chars)
    -- =========================================================================
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache;
    CREATE TABLE dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (
        column01 VARCHAR(20), column02 VARCHAR(255), column03 VARCHAR(255), 
        column04 VARCHAR(255), column05 VARCHAR(255), column06 VARCHAR(255), 
        column07 VARCHAR(255), column08 VARCHAR(255), column09 VARCHAR(255), 
        column10 VARCHAR(255), column11 VARCHAR(255), column12 VARCHAR(255), 
        column13 VARCHAR(255), column14 VARCHAR(255), column15 VARCHAR(255), 
        column16 VARCHAR(255), column17 VARCHAR(255), column18 VARCHAR(255), 
        column19 VARCHAR(255), zdsp_order VARCHAR(255), zdsp_uniquekey VARCHAR(255), 
        posting_log_message VARCHAR(1024), billcycle VARCHAR(5)
    );

    INSERT INTO dswtdir2_innove_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache (
        column01, column02, column03, column04, column05, column06, column07, 
        column08, column09, column10, column11, column12, column13, column14, 
        column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, posting_log_message, billcycle
    )
    SELECT 
        '01', 'Val2_' || g.i, 'Val3_' || g.i, 'Val4_' || g.i, 'Val5_' || g.i, 
        'Val6_' || g.i, 'Val7_' || g.i, '100.00', '10.00', 'Val10_' || g.i, 
        'Val11_' || g.i, 'Val12_' || g.i, 'Val13_' || g.i, 'Val14_' || g.i, 'Val15_' || g.i, 
        'Val16_' || g.i, 'Val17_' || g.i, 'Val18_' || g.i, 'Val19_' || g.i,
        CAST(g.i AS VARCHAR), 'VALID_UNIQ_' || g.i, 'Dummy Valid Message ' || g.i, v_billcycle
    FROM generate_series(1, 15) AS g(i);

    RAISE NOTICE 'Dummy Postload Report Prepare phase successfully simulated for Innove %. 15 dummy records generated per cache table.', v_billcycle;

END;
$procedure$
