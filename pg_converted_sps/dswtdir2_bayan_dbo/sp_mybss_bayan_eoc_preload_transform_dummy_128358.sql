CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_transform_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5) := par_cyclecode;
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING TABLE CREATION
    -- Guarantees the target table exists. 
    -- The original MSSQL target is 'ttBayan_Billed'. We use a dummy equivalent 
    -- 'ttbayan_billed_preload_dmy' to keep it distinct and under 63 characters.
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.ttbayan_billed_preload_dmy (
        zlegacydsp_order INT,
        zlegacycycle_code VARCHAR(5),
        column01 VARCHAR(50),
        column02 VARCHAR(50),
        column03 VARCHAR(50),
        column04 VARCHAR(50),
        column05 VARCHAR(50),
        column06 VARCHAR(50),
        column07 VARCHAR(50),
        column08 NUMERIC(18,2),
        column09 NUMERIC(18,2),
        column10 VARCHAR(50),
        column11 VARCHAR(50),
        column12 VARCHAR(50),
        column13 VARCHAR(50),
        column14 VARCHAR(50),
        column15 VARCHAR(50),
        column16 VARCHAR(50),
        column17 VARCHAR(50),
        column18 VARCHAR(50),
        column19 VARCHAR(50),
        zdsp_order INT,
        zdsp_uniquekey VARCHAR(100),
        zactive INT,
        zsource VARCHAR(50),
        zduplicate INT,
        zloaded NUMERIC(1,0),
        zload_message VARCHAR(255)
    );

    -- =========================================================================
    -- 1. DELETE EXISTING RECORDS FOR THE CYCLE
    -- Simulates the MSSQL DELETE: DELETE FROM [dbo].[ttBayan_Billed] WHERE ...
    -- =========================================================================
    DELETE FROM dswtdir2_bayan_dbo.ttbayan_billed_preload_dmy 
    WHERE zlegacycycle_code = v_billcycle AND zsource = 'TDIR2_Bayan_DUMMY';

    -- =========================================================================
    -- 2. INSERT DUMMY TRANSFORMED DATA
    -- Simulates the final INSERT into ttBayan_Billed.
    -- FIXED: Ensuring exact 1:1 mapping between the 28 target columns and the 28 SELECT values.
    -- =========================================================================
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_billed_preload_dmy (
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, 
        column06, column07, column08, column09, column10, column11, column12, column13, 
        column14, column15, column16, column17, column18, column19, zdsp_order, 
        zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
    )
    SELECT 
        g.i AS zlegacydsp_order,
        v_billcycle AS zlegacycycle_code,
        '01' AS column01, -- Setting '01' to simulate valid records that pass downstream filters
        'Val2_' || g.i AS column02,
        'Val3_' || g.i AS column03,
        'Val4_' || g.i AS column04,
        'Val5_' || g.i AS column05,
        'Val6_' || g.i AS column06,
        'Val7_' || g.i AS column07,
        100.50 AS column08, -- Numeric mapped to DECIMAL(18,2) equivalent
        0.00 AS column09,   -- Numeric mapped to DECIMAL(18,2) equivalent
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
        'UNIQ_PRELOAD_' || v_billcycle || '_' || g.i AS zdsp_uniquekey,
        1 AS zactive,
        'TDIR2_Bayan_DUMMY' AS zsource,
        0 AS zduplicate,
        0 AS zloaded, -- Simulating 'not yet loaded to SAP'
        'Dummy Preload Transform' AS zload_message
    FROM generate_series(1, 55) AS g(i);

    -- =========================================================================
    -- 3. SIMULATE TARGET RULE UPDATE
    -- Simulates the UPDATE tt SET tt.zLoaded = '1' logic based on the ODBC logs
    -- =========================================================================
    -- In this dummy version, we arbitrarily set zloaded = 1 for a few records 
    -- to mimic the behavior of the complex INNER JOIN to vw_ZFFI_REPORT_ODBC_LATESTLOGS
    UPDATE dswtdir2_bayan_dbo.ttbayan_billed_preload_dmy
    SET zloaded = 1,
        zload_message = 'Simulated ODBC Success'
    WHERE zlegacycycle_code = v_billcycle 
      AND zsource = 'TDIR2_Bayan_DUMMY'
      AND zdsp_order % 5 = 0; -- Set every 5th record as "loaded"

    RAISE NOTICE 'Dummy Preload Transform completed for %. 55 records processed.', par_cyclecode;

END;
$procedure$
