CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE DUMMY TARGET TABLE
    -- Schema matches stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i
    -- Includes base columns (Column1-Column13) + 'z' columns inferred from downstream SPs
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_innove_dbo.stinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_dummy CASCADE;

    CREATE TABLE dswtdir2_innove_dbo.stinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_dummy (
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
        zbatchno VARCHAR(255),
        zdsp_uniquekey VARCHAR(255),
        zloaded NUMERIC(1,0) DEFAULT 0 NOT NULL
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS DUMMY DATA
    -- Mimics the "DELETE FROM [dbo].[stInnove_Unbilled_Adj_TDIR2_Innove_sap_glunbilled_i]" step
    -- ===============================================================================
    DELETE FROM dswtdir2_innove_dbo.stinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_dummy;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Simulates the result of the initial INSERT AND the 15 downstream SP executions.
    -- Targets Column1 IN ('00','01','99') mapping standard header, detail, and footer.
    -- ===============================================================================
    INSERT INTO dswtdir2_innove_dbo.stinnove_unbilled_adj_tdir2_innove_sap_glunbilled_i_dummy (
        zrownumber, column1, column2, column3, column4, column5, column6, column7, 
        column8, column9, column10, column11, column12, column13, zlegacydsp_order, 
        zdsp_order, zcolumn01, zcolumn02, zcolumn03, zcolumn04, zcolumn05, zcolumn06, 
        zcolumn07, zcolumn08, zcolumn09, zcolumn10, zcolumn11, zcolumn12, zcolumn13, 
        zbatchno, zdsp_uniquekey, zloaded
    )
    VALUES 
        -- Row 1: Header ('00')
        (1, '00', 'INNOVE_ADJ_HDR', 'SYS_A', 'UNBILLED_ADJ', 'GRP_1', 'CODE_H', '1000', 
         NULL, NULL, NULL, NULL, NULL, NULL, 'L_ORD_001', 'ORD_001', '00', 'INNOVE_ADJ_HDR', 
         'SYS_A', 'UNBILLED_ADJ', 'GRP_1', 'CODE_H', '1000', NULL, NULL, NULL, NULL, NULL, 
         NULL, 'BATCH_IN_ADJ_001', 'INNOVE-ADJ-KEY-000', 1),

        -- Row 2: Detail ('01') - Valid Unbilled Adjustment
        (2, '01', 'INNOVE_ADJ_DTL', 'SYS_A', 'CREDIT_ADJ', 'GRP_2', 'CODE_D', '500.25', 
         'VAL_8', 'VAL_9', 'VAL_10', 'VAL_11', 'VAL_12', 'VAL_13', 'L_ORD_002', 'ORD_002', 
         '01', 'INNOVE_ADJ_DTL', 'SYS_A', 'CREDIT_ADJ', 'GRP_2', 'CODE_D', '500.25', 'VAL_8', 
         'VAL_9', 'VAL_10', 'VAL_11', 'VAL_12', 'VAL_13', 'BATCH_IN_ADJ_001', 'INNOVE-ADJ-KEY-001', 1),

        -- Row 3: Footer ('99')
        (3, '99', 'INNOVE_ADJ_FTR', 'SYS_A', 'SUMMARY', 'GRP_ALL', 'CODE_F', '1500.25', 
         NULL, NULL, NULL, NULL, NULL, NULL, 'L_ORD_003', 'ORD_003', '99', 'INNOVE_ADJ_FTR', 
         'SYS_A', 'SUMMARY', 'GRP_ALL', 'CODE_F', '1500.25', NULL, NULL, NULL, NULL, NULL, 
         NULL, 'BATCH_IN_ADJ_001', 'INNOVE-ADJ-KEY-099', 1),

        -- Row 4: Error/Unloaded Row ('01') - Simulating trInnove_Unbilled_Adj_zLoaded_0_Error_LineUpd
        (4, '01', 'INNOVE_ADJ_ERR', 'SYS_A', 'UNKNOWN_ADJ', 'GRP_ERR', 'CODE_ERR', '100.00', 
         NULL, NULL, NULL, NULL, NULL, NULL, 'L_ORD_004', 'ORD_004', '01', 'INNOVE_ADJ_ERR', 
         'SYS_A', 'UNKNOWN_ADJ', 'GRP_ERR', 'CODE_ERR', '100.00', NULL, NULL, NULL, NULL, NULL, 
         NULL, 'BATCH_IN_ADJ_001', 'INNOVE-ADJ-KEY-ERR', 0);

END;
$procedure$
