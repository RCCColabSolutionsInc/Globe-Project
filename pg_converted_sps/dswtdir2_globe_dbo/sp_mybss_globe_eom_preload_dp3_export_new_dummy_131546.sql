CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_export_new_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Creates the exact same table structure as the real DP3 Export stored procedure
    -- ===============================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export (
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
        zdsp_order VARCHAR(500),
        zdsp_uniquekey VARCHAR(500)
    );

    -- ===============================================================================
    -- 2. CONCURRENCY FIX
    -- Clears out old dummy data before seeding
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Directly populates the table to simulate the cleansed text file output.
    -- Mimics a Header ('00'), Detail ('01'), and Footer ('99') sequence.
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export (
        column01, column02, column03, column04, column05, column06, 
        column07, column08, column09, column10, column11, column12,
        zdsp_order, zdsp_uniquekey
    )
    VALUES 
        -- Row 1: Simulating the Header record ('00')
        ('00', 'HEADER_DATA', 'SYS_A', 'TYPE_X', 'GRP_1', 'CODE_H', 
         '1000.00', '', '', '', '', '', 
         '1', 'DP3-KEY-000'),

        -- Row 2: Simulating a Detail record ('01')
        ('01', 'DETAIL_DATA', 'SYS_A', 'TYPE_Y', 'GRP_2', 'CODE_D', 
         '500.25', '', '', '', '', '', 
         '2', 'DP3-KEY-001'),

        -- Row 3: Simulating the Footer/Summary record ('99')
        ('99', 'FOOTER_DATA', 'SYS_A', 'TYPE_Z', 'GRP_ALL', 'CODE_F',
         '1500.25', '', '', '', '', '', 
         '3', 'DP3-KEY-099');

END;
$procedure$
