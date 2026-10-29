CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE DUMMY TARGET TABLE
    -- Schema matches stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I
    -- Includes base columns (Column1-Column15) + 'z' columns inferred from downstream SPs
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.stinnove_unearned_msf_tdir2_innove_sap_airc_i_dummy CASCADE;

    CREATE TABLE dswtdir2_innove_dbo.stinnove_unearned_msf_tdir2_innove_sap_airc_i_dummy (
        zrownumber INTEGER,
        column1 VARCHAR(255),
        column2 VARCHAR(255),
        column3 VARCHAR(255),
        column4 VARCHAR(255),
        column5 VARCHAR(255),
        column6 VARCHAR(255),
        column7 VARCHAR(255),
        column8 VARCHAR(255),
        column9 VARCHAR(255),
        column10 VARCHAR(255),
        column11 VARCHAR(255),
        column12 VARCHAR(255),
        column13 VARCHAR(255),
        column14 VARCHAR(255),
        column15 VARCHAR(255),
        
        -- 'z' columns populated by downstream srInnove_* stored procedures
        zlegacydsp_order VARCHAR(255),
        zdsp_order VARCHAR(255),
        zcolumn01 VARCHAR(255),
        zcolumn02 VARCHAR(255),
        zcolumn03 VARCHAR(255),
        zcolumn04 VARCHAR(255),
        zcolumn05 VARCHAR(255),
        zcolumn06 VARCHAR(255),
        zcolumn07 VARCHAR(255),
        zcolumn08 VARCHAR(255),
        zcolumn09 VARCHAR(255),
        zcolumn10 VARCHAR(255),
        zcolumn11 VARCHAR(255),
        zcolumn12 VARCHAR(255),
        zcolumn13 VARCHAR(255),
        zcolumn14 VARCHAR(255),
        zcolumn15 VARCHAR(255),
        zbatchno VARCHAR(255),
        zdsp_uniquekey VARCHAR(255),
        zloaded NUMERIC(1,0) DEFAULT 0 NOT NULL
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS DUMMY DATA
    -- Mimics the "DELETE FROM [dbo].[stInnove_Unearned_MSF_TDIR2_Innove_sap_airc_I]" step
    -- ===============================================================================
    DELETE FROM dswtdir2_innove_dbo.stinnove_unearned_msf_tdir2_innove_sap_airc_i_dummy;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Simulates the result of the initial INSERT AND the 22 downstream SP executions.
    -- Targets Column1 IN ('00','01','99') mapping standard header, detail, and footer.
    -- ===============================================================================
    INSERT INTO dswtdir2_innove_dbo.stinnove_unearned_msf_tdir2_innove_sap_airc_i_dummy (
        zrownumber, column1, column2, column3, column4, column5, column6, column7, 
        column8, column9, column10, column11, column12, column13, column14, column15, 
        zlegacydsp_order, zdsp_order, zcolumn01, zcolumn02, zcolumn03, zcolumn04, 
        zcolumn05, zcolumn06, zcolumn07, zcolumn08, zcolumn09, zcolumn10, zcolumn11, 
        zcolumn12, zcolumn13, zcolumn14, zcolumn15, zbatchno, zdsp_uniquekey, zloaded
    )
    VALUES 
        -- Row 1: Header ('00')
        (1, '00', 'INNOVE_MSF_HDR', 'SYS_A', 'UNEARNED', 'GRP_1', 'CODE_H', '1000', 
         NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
         'L_ORD_001', 'ORD_001', '00', 'INNOVE_MSF_HDR', 'SYS_A', 'UNEARNED', 'GRP_1', 
         'CODE_H', '1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
         'BATCH_MSF_001', 'INNOVE-MSF-KEY-000', 1),

        -- Row 2: Detail ('01') - Valid Unearned MSF Charge
        (2, '01', 'INNOVE_MSF_DTL', 'SYS_A', 'CREDIT', 'GRP_2', 'CODE_D', '500.25', 
         'VAL_8', 'VAL_9', 'VAL_10', 'VAL_11', 'VAL_12', 'VAL_13', 'VAL_14', 'VAL_15', 
         'L_ORD_002', 'ORD_002', '01', 'INNOVE_MSF_DTL', 'SYS_A', 'CREDIT', 'GRP_2', 
         'CODE_D', '500.25', 'VAL_8', 'VAL_9', 'VAL_10', 'VAL_11', 'VAL_12', 'VAL_13', 
         'VAL_14', 'VAL_15', 'BATCH_MSF_001', 'INNOVE-MSF-KEY-001', 1),

        -- Row 3: Footer ('99')
        (3, '99', 'INNOVE_MSF_FTR', 'SYS_A', 'SUMMARY', 'GRP_ALL', 'CODE_F', '1500.25', 
         NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
         'L_ORD_003', 'ORD_003', '99', 'INNOVE_MSF_FTR', 'SYS_A', 'SUMMARY', 'GRP_ALL', 
         'CODE_F', '1500.25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
         'BATCH_MSF_001', 'INNOVE-MSF-KEY-099', 1),

        -- Row 4: Error/Unloaded Row ('01') - Simulating trInnove_Unearned_MSF_zLoaded_0_Error_LineUpd
        (4, '01', 'INNOVE_MSF_ERR', 'SYS_A', 'UNKNOWN', 'GRP_ERR', 'CODE_ERR', '100.00', 
         NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
         'L_ORD_004', 'ORD_004', '01', 'INNOVE_MSF_ERR', 'SYS_A', 'UNKNOWN', 'GRP_ERR', 
         'CODE_ERR', '100.00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
         'BATCH_MSF_001', 'INNOVE-MSF-KEY-ERR', 0);

END;
$procedure$
