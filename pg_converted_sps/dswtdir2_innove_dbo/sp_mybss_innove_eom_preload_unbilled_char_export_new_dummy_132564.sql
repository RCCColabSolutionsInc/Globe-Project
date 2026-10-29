CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_export_new_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE TARGET TABLE
    -- Creates the exact same table structure as the real Innove Unbilled Char Export SP
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export CASCADE;

    CREATE TABLE dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export (
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
    -- Clears out old dummy data before seeding
    -- ===============================================================================
    DELETE FROM dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Directly populates the table to simulate the cleansed text file output.
    -- Maps the 17 generic columns + metadata, simulating Header (00), Detail (01), and Footer (99).
    -- ===============================================================================
    INSERT INTO dswtdir2_innove_dbo.txinnove_unbilled_char_loadfilesel_export (
        column01, column02, column03, column04, column05, column06, 
        column07, column08, column09, column10, column11, column12, 
        column13, column14, column15, column16, column17, 
        zdsp_order, zdsp_uniquekey
    )
    VALUES 
        -- Row 1: Header ('00') - Column07 is traditionally formatted without decimals here
        ('00', 'HDR_DATA', '', 'SYS_INNOVE', 'UNBILLED', 'GRP_1', 
         '1000', '', '', '', '', '', 
         '', '', '', '', '', 
         '1', 'INNOVE-EXP-KEY-000'),

        -- Row 2: Detail ('01') - Column07 formatted with decimals
        ('01', 'DTL_DATA', 'CREDIT', 'SYS_INNOVE', 'UNBILLED', 'GRP_2', 
         '500.25', 'VAL_8', 'VAL_9', 'VAL_10', 'VAL_11', 'VAL_12', 
         'VAL_13', 'VAL_14', 'VAL_15', 'VAL_16', 'VAL_17', 
         '2', 'INNOVE-EXP-KEY-001'),

        -- Row 3: Footer ('99') - Column03 simulated as SUM of Column07 details
        ('99', 'FTR_DATA', '500.25', 'SYS_INNOVE', 'SUMMARY', 'GRP_ALL', 
         '1500.25', '', '', '', '', '', 
         '', '', '', '', '', 
         '3', 'INNOVE-EXP-KEY-099');

END;
$procedure$
