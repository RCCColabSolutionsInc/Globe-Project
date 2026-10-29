CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_transform_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
BEGIN
    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- Establishes configuration lookup data across the pipeline dynamically
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10),
        billcycle VARCHAR(5),
        description VARCHAR(50),
        runday INT,
        keyword_ssrs VARCHAR(20),
        exportfilekey VARCHAR(100),
        exportfilename VARCHAR(100)
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
    
    -- Try to resolve BillCycle, fallback to par_cyclecode if table doesn't exist yet
    BEGIN
        SELECT billcycle INTO v_billcycle 
        FROM dswtdir2_innove_dbo.billcycles 
        WHERE cyclecode = par_cyclecode;
    EXCEPTION WHEN undefined_table THEN
        v_billcycle := par_cyclecode;
    END;
    
    v_billcycle := COALESCE(v_billcycle, par_cyclecode);

    -- =========================================================================
    -- CRASH PREVENTION (SELF-HEALING)
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

    -- =========================================================================
    -- TARGET DUMMY REFRESH
    -- Simulates the DELETE FROM ttInnove_Billed WHERE zlegacycycle_code = ...
    -- =========================================================================
    DELETE FROM dswtdir2_innove_dbo.ttinnove_billed 
    WHERE zlegacycycle_code = v_billcycle AND zsource = 'TDIR2_Innove_DUMMY';

    -- =========================================================================
    -- INSERT DUMMY TRANSFORMED DATA
    -- Populating all columns explicitly to bypass NOT NULL constraints
    -- =========================================================================
    INSERT INTO dswtdir2_innove_dbo.ttinnove_billed (
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, 
        column05, column06, column07, column08, column09, column10, column11, column12, 
        column13, column14, column15, column16, column17, column18, column19, 
        zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
    )
    SELECT 
        g.i AS zlegacydsp_order,
        v_billcycle AS zlegacycycle_code,
        CASE WHEN g.i = 1 THEN '00' ELSE '01' END AS column01, -- 1 Header, rest Data
        'DUMMY_INNOVE_' || g.i AS column02,
        'INNOVE' AS column03,
        'Val4_' || g.i AS column04,
        'Val5_' || g.i AS column05,
        'Val6_' || g.i AS column06,
        'Val7_' || g.i AS column07,
        '100.00' AS column08,
        '10.00' AS column09,
        'Val10_' || g.i AS column10,
        'Val11_' || g.i AS column11,
        'Val12_' || g.i AS column12,
        'Val13_' || g.i AS column13,
        'Val14_' || g.i AS column14,
        'Val15_' || g.i AS column15,
        'Val16_' || g.i AS column16,
        'Val17_' || g.i AS column17,
        'Val18_' || g.i AS column18,
        'Val19_' || g.i AS column19,
        g.i AS zdsp_order,
        'UNIQ_INNOVE_' || v_billcycle || '_' || g.i AS zdsp_uniquekey,
        1 AS zactive,
        'TDIR2_Innove_DUMMY' AS zsource,
        0 AS zduplicate,
        CASE WHEN g.i % 5 = 0 THEN 1 ELSE 0 END AS zloaded, -- Simulate loaded vs not loaded
        'Dummy Preload Transform' AS zload_message
    FROM generate_series(1, 15) AS g(i);

    RAISE NOTICE 'Dummy transform executed successfully for Innove cycle: %. 15 records processed.', v_billcycle;
END;
$procedure$
