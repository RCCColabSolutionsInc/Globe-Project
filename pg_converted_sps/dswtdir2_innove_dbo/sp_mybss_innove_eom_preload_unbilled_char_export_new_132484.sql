CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_export_new()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Replaces the legacy text export loop. Prepares the final dataset so AWS Glue 
    -- can extract it directly to S3.
    -- ===============================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export (
        column01 VARCHAR(500),
        column02 VARCHAR(500),
        column03 VARCHAR(500),
        column04 VARCHAR(500),
        column05 VARCHAR(500),
        column06 VARCHAR(500),
        column07 VARCHAR(500),
        column08 VARCHAR(500),
        column09 VARCHAR(500),
        column10 VARCHAR(500),
        column11 VARCHAR(500),
        column12 VARCHAR(500),
        column13 VARCHAR(500),
        column14 VARCHAR(500),
        column15 VARCHAR(500),
        column16 VARCHAR(500),
        column17 VARCHAR(500),
        zdsp_order VARCHAR(500),
        zdsp_uniquekey VARCHAR(500)
    );

    -- ===============================================================================
    -- 2. CONCURRENCY FIX
    -- Safely clear old runs before populating the export table
    -- ===============================================================================
    DELETE FROM dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export; 

    -- ===============================================================================
    -- 3. TRANSFORM & LOAD 
    -- Consolidates sp_MyBSS_Innove_EOM_Preload_Unbilled_Char_Export_LoadFileSel
    -- Applies fn_CleanTxt logic and handles dynamic summation for Column03/Column07
    -- ===============================================================================
    INSERT INTO dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export
    SELECT 
        COALESCE(REGEXP_REPLACE(TRIM(column01), '[\t\n\r\0]', '', 'g'), '') AS column01,
        COALESCE(REGEXP_REPLACE(TRIM(column02), '[\t\n\r\0]', '', 'g'), '') AS column02,
        
        -- Logic for Column03: If Footer ('99'), sum Column07 of Details ('01')
        COALESCE(REGEXP_REPLACE(TRIM(
            CASE 
                WHEN column01 = '99' THEN 
                    (SELECT CAST(SUM(CAST(NULLIF(y.column07, '') AS NUMERIC(18,2))) AS VARCHAR) 
                     FROM dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel y 
                     WHERE y.column01 = '01')
                ELSE column03 
            END
        ), '[\t\n\r\0]', '', 'g'), '') AS column03,
        
        COALESCE(REGEXP_REPLACE(TRIM(column04), '[\t\n\r\0]', '', 'g'), '') AS column04,
        COALESCE(REGEXP_REPLACE(TRIM(column05), '[\t\n\r\0]', '', 'g'), '') AS column05,
        COALESCE(REGEXP_REPLACE(TRIM(column06), '[\t\n\r\0]', '', 'g'), '') AS column06,
        
        -- Logic for Column07: Decimal formatting based on Header ('00') vs others
        COALESCE(REGEXP_REPLACE(TRIM(
            CASE 
                WHEN column01 = '00' THEN TO_CHAR(CAST(NULLIF(column07, '') AS NUMERIC(18,0)), 'FM9999999999999990')
                ELSE TO_CHAR(CAST(NULLIF(column07, '') AS NUMERIC(18,2)), 'FM9999999999999990.99')
            END
        ), '[\t\n\r\0]', '', 'g'), '') AS column07,
        
        COALESCE(REGEXP_REPLACE(TRIM(column08), '[\t\n\r\0]', '', 'g'), '') AS column08,
        COALESCE(REGEXP_REPLACE(TRIM(column09), '[\t\n\r\0]', '', 'g'), '') AS column09,
        COALESCE(REGEXP_REPLACE(TRIM(column10), '[\t\n\r\0]', '', 'g'), '') AS column10,
        COALESCE(REGEXP_REPLACE(TRIM(column11), '[\t\n\r\0]', '', 'g'), '') AS column11,
        COALESCE(REGEXP_REPLACE(TRIM(column12), '[\t\n\r\0]', '', 'g'), '') AS column12,
        COALESCE(REGEXP_REPLACE(TRIM(column13), '[\t\n\r\0]', '', 'g'), '') AS column13,
        COALESCE(REGEXP_REPLACE(TRIM(column14), '[\t\n\r\0]', '', 'g'), '') AS column14,
        COALESCE(REGEXP_REPLACE(TRIM(column15), '[\t\n\r\0]', '', 'g'), '') AS column15,
        COALESCE(REGEXP_REPLACE(TRIM(column16), '[\t\n\r\0]', '', 'g'), '') AS column16,
        COALESCE(REGEXP_REPLACE(TRIM(column17), '[\t\n\r\0]', '', 'g'), '') AS column17,
        COALESCE(REGEXP_REPLACE(TRIM(zdsp_order), '[\t\n\r\0]', '', 'g'), '') AS zdsp_order,
        COALESCE(REGEXP_REPLACE(TRIM(zdsp_uniquekey), '[\t\n\r\0]', '', 'g'), '') AS zdsp_uniquekey
        
    FROM dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel
    ORDER BY column01, CAST(NULLIF(zdsp_order, '') AS INT);

END;
$procedure$
