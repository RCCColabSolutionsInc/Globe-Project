CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_transform_dummy(IN par_cyclecode character varying)
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
    -- POSTLOAD TARGET DUMMY REFRESH
    -- (Identical target table as Preload)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.ttinnove_billed (
        zlegacydsp_order INT NOT NULL, 
        zlegacycycle_code VARCHAR(5), 
        column01 VARCHAR(50), column02 VARCHAR(50), column03 VARCHAR(50), 
        column04 VARCHAR(50), column05 VARCHAR(50), column06 VARCHAR(50), 
        column07 VARCHAR(50), column08 VARCHAR(50), column09 VARCHAR(50), 
        column10 VARCHAR(50), column11 VARCHAR(50), column12 VARCHAR(50), 
        column13 VARCHAR(50), column14 VARCHAR(50), column15 VARCHAR(50), 
        column16 VARCHAR(50), column17 VARCHAR(50), column18 VARCHAR(50), 
        column19 VARCHAR(50), zdsp_order INT, zdsp_uniquekey VARCHAR(200), 
        zactive INT, zsource VARCHAR(50), zduplicate INT, 
        zloaded NUMERIC(1,0), zload_message VARCHAR(500)
    );

    DELETE FROM dswtdir2_innove_dbo.ttinnove_billed 
    WHERE zlegacycycle_code = v_billcycle AND zsource = 'TDIR2_Innove_DUMMY_POSTLOAD';

    INSERT INTO dswtdir2_innove_dbo.ttinnove_billed (
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, 
        column05, column06, column07, column08, column09, column10, column11, column12, 
        column13, column14, column15, column16, column17, column18, column19, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
    )
    SELECT 
        g.i AS zlegacydsp_order, v_billcycle AS zlegacycycle_code,
        CASE WHEN g.i = 1 THEN '00' ELSE '01' END AS column01,
        'DUMMY_POSTLOAD_INNOVE_' || g.i, 'INNOVE', 'Val4_' || g.i, 'Val5_' || g.i, 
        'Val6_' || g.i, 'Val7_' || g.i, '100.00', '10.00', 'Val10_' || g.i, 
        'Val11_' || g.i, 'Val12_' || g.i, 'Val13_' || g.i, 'Val14_' || g.i, 
        'Val15_' || g.i, 'Val16_' || g.i, 'Val17_' || g.i, 'Val18_' || g.i, 
        'Val19_' || g.i, g.i AS zdsp_order, 
        'UNIQ_POSTLOAD_INNOVE_' || v_billcycle || '_' || g.i,
        1, 'TDIR2_Innove_DUMMY_POSTLOAD', 0, 
        CASE WHEN g.i % 5 = 0 THEN 1 ELSE 0 END, 
        'Dummy Postload Transform'
    FROM generate_series(1, 15) AS g(i);

    RAISE NOTICE 'Dummy postload transform executed successfully for Innove cycle: %.', v_billcycle;
END;
$procedure$
