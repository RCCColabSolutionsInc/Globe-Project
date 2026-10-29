CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_export_new_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Creates the exact same table structure as the real stored procedure
    -- ===============================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export (
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
        column12 VARCHAR(500)
    );

    -- ===============================================================================
    -- 2. CONCURRENCY FIX
    -- Clears out old dummy data for the specific cycle code being tested
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Directly populates the table without querying tvglobe_dp2_unearned_preload_rptsel
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export (
        column01, column02, column03, column04, column05, column06, 
        column07, column08, column09, column10, column11, column12
    )
    VALUES 
        -- Row 1: Simulating '00' logic where amount has NO decimals (e.g., 1000 instead of 1000.00)
        ('00', '08/19/2026', 'GLOBE', 'CORP', 'POSTPAID', 'CHG-SUM', 
         '1000', 'CC-000', 'GL-000', 'N', '1', 'DUMMY-KEY-001'),

        -- Row 2: Simulating detail row where amount HAS decimals (e.g., 500.50)
        ('01', '08/19/2026', 'GLOBE', 'RETAIL', 'PREPAID', 'CHG-001', 
         '500.50', 'CC-123', 'GL-101', 'Y', '2', 'DUMMY-KEY-002'),

        -- Row 3: Simulating another detail row
        ('01', '08/19/2026', 'GLOBE', 'RETAIL', 'POSTPAID', 'CHG-002',
         '499.50', 'CC-124', 'GL-102', 'N', '3', 'DUMMY-KEY-003');

END;
$procedure$
