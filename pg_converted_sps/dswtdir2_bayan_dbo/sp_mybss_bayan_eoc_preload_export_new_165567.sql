CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_export_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. STAGING TABLE CREATION
    -- Creates a permanent table to hold the exact dataset for Glue to extract.
    -- Length is 52 chars, safely below the 63-character limit.
    -- ===============================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.tvbayan_billed_preload_cyclexrptsel_export (
        column01 VARCHAR(20), column02 VARCHAR(255), column03 VARCHAR(255), 
        column04 VARCHAR(255), column05 VARCHAR(255), column06 VARCHAR(255), 
        column07 VARCHAR(255), column08 VARCHAR(255), column09 VARCHAR(255), 
        column10 VARCHAR(255), column11 VARCHAR(255), column12 VARCHAR(255), 
        column13 VARCHAR(255), column14 VARCHAR(255), column15 VARCHAR(255), 
        column16 VARCHAR(255), column17 VARCHAR(255), column18 VARCHAR(255), 
        column19 VARCHAR(255), zdsp_order VARCHAR(255), zdsp_uniquekey VARCHAR(255), 
        zlegacycycle_code VARCHAR(5)
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS CYCLE DATA
    -- ===============================================================================
    DELETE FROM dswtdir2_bayan_dbo.tvbayan_billed_preload_cyclexrptsel_export 
    WHERE zlegacycycle_code = par_cyclecode;

    -- ===============================================================================
    -- 3. APPLY TRANSFORMATIONS AND LOAD TO STAGING
    -- Replicates the MSSQL logic exactly (Date addition for BC01, and Footer Aggregation).
    -- ===============================================================================
    IF par_cyclecode = 'BC01' THEN
        -- BC01 Specific Logic: Add 1 day to Column02 if it contains a slash
        INSERT INTO dswtdir2_bayan_dbo.tvbayan_billed_preload_cyclexrptsel_export
        SELECT * FROM (
            SELECT 
                   column01, 
                   CASE 
                       WHEN column02 LIKE '%/%' THEN TO_CHAR(TO_DATE(column02, 'MM/DD/YYYY') + INTERVAL '1 day', 'MM/DD/YYYY')
                       ELSE column02 
                   END AS column02,
                   column03, column04, column05, column06, column07, column08, column09, column10,
                   column11, column12, column13, column14, column15, column16, column17, column18, column19,
                   CAST(zdsp_order AS VARCHAR), zdsp_uniquekey, zlegacycycle_code
            FROM dswtdir2_bayan_dbo.ttbayan_billed
            WHERE zlegacycycle_code = par_cyclecode AND column01 <> '99'
            
            UNION ALL
            
            -- Footer Row Aggregation
            SELECT 
                   '99' AS column01,
                   (SELECT CAST(COUNT(column01) AS VARCHAR) FROM dswtdir2_bayan_dbo.ttbayan_billed WHERE zlegacycycle_code = par_cyclecode AND column01 = '01') AS column02,
                   (SELECT CAST(SUM(CAST(column08 AS NUMERIC(20,2))) AS VARCHAR) FROM dswtdir2_bayan_dbo.ttbayan_billed WHERE zlegacycycle_code = par_cyclecode) AS column03,
                   column04, column05, column06, column07, column08, column09, column10,
                   column11, column12, column13, column14, column15, column16, column17, column18, column19,
                   CAST(zdsp_order AS VARCHAR), zdsp_uniquekey, par_cyclecode AS zlegacycycle_code
            FROM dswtdir2_bayan_dbo.ttbayan_billed
            WHERE zlegacycycle_code = par_cyclecode AND column01 = '99'
        ) final_result
        ORDER BY column01, CAST(zdsp_order AS INTEGER);

    ELSE
        -- Standard Logic for all other Cycle Codes
        INSERT INTO dswtdir2_bayan_dbo.tvbayan_billed_preload_cyclexrptsel_export
        SELECT * FROM (
            SELECT 
                   column01, column02, column03, column04, column05, column06, column07, column08, column09, column10,
                   column11, column12, column13, column14, column15, column16, column17, column18, column19,
                   CAST(zdsp_order AS VARCHAR), zdsp_uniquekey, zlegacycycle_code
            FROM dswtdir2_bayan_dbo.ttbayan_billed
            WHERE zlegacycycle_code = par_cyclecode AND column01 <> '99'
            
            UNION ALL
            
            SELECT 
                   '99' AS column01,
                   (SELECT CAST(COUNT(column01) AS VARCHAR) FROM dswtdir2_bayan_dbo.ttbayan_billed WHERE zlegacycycle_code = par_cyclecode AND column01 = '01') AS column02,
                   (SELECT CAST(SUM(CAST(column08 AS NUMERIC(20,2))) AS VARCHAR) FROM dswtdir2_bayan_dbo.ttbayan_billed WHERE zlegacycycle_code = par_cyclecode) AS column03,
                   column04, column05, column06, column07, column08, column09, column10,
                   column11, column12, column13, column14, column15, column16, column17, column18, column19,
                   CAST(zdsp_order AS VARCHAR), zdsp_uniquekey, par_cyclecode AS zlegacycycle_code
            FROM dswtdir2_bayan_dbo.ttbayan_billed
            WHERE zlegacycycle_code = par_cyclecode AND column01 = '99'
        ) final_result
        ORDER BY column01, CAST(zdsp_order AS INTEGER);
    END IF;

    RAISE NOTICE 'Actual Export preparation successfully staged for %', par_cyclecode;
END;
$procedure$
