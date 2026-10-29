CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE DUMMY TARGET TABLE
    -- Table name is truncated to comply with PostgreSQL's 63-character identifier limit
    -- Schema matches stGlobe_DP5_Unconfirmed_Adj_TDIR2_Globe_sap_glunbilled_unconf_G
    -- Includes base columns (Column1-Column7) + 'z' columns inferred from downstream SPs
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.stglobe_dp5_unconf_adj_tdir2_globe_sap_glunbilled_unconf_g CASCADE;

    CREATE TABLE dswtdir2_globe_dbo.stglobe_dp5_unconf_adj_tdir2_globe_sap_glunbilled_unconf_g (
        zrownumber INTEGER,
        column1 VARCHAR(255),
        column2 VARCHAR(255),
        column3 VARCHAR(255),
        column4 VARCHAR(255),
        column5 VARCHAR(255),
        column6 VARCHAR(255),
        column7 VARCHAR(255),
        
        -- 'z' columns populated by downstream srGlobe_* stored procedures
        zlegacydsp_order VARCHAR(255),
        zdsp_order VARCHAR(255),
        zposting_date VARCHAR(255),
        zspa VARCHAR(255),
        zrev_type VARCHAR(255),
        zgl_zspb VARCHAR(255),
        zgl2 VARCHAR(255),
        ztax DOUBLE PRECISION,
        zamount_net DOUBLE PRECISION,
        zremark VARCHAR(255),
        zbrand VARCHAR(255),
        zactive NUMERIC(1,0) DEFAULT 0 NOT NULL,
        zloaded NUMERIC(1,0) DEFAULT 0 NOT NULL
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS DUMMY DATA
    -- Mimics the "DELETE FROM [dbo].[stGlobe_DP5_Unconfirmed_Adj_...]" step
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp5_unconf_adj_tdir2_globe_sap_glunbilled_unconf_g;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Simulates the result of the initial INSERT AND the 15 downstream SP executions.
    -- Targets Column1 IN ('00','01','99') mapping standard header, detail, and footer.
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp5_unconf_adj_tdir2_globe_sap_glunbilled_unconf_g (
        zrownumber, column1, column2, column3, column4, column5, column6, column7, 
        zlegacydsp_order, zdsp_order, zposting_date, zspa, zrev_type, zgl_zspb, zgl2, 
        ztax, zamount_net, zremark, zbrand, zactive, zloaded
    )
    VALUES 
        -- Row 1: Header ('00')
        (1, '00', 'HEADER_DATA', 'SYS_A', 'UNCONF_ADJ', 'GRP_1', 'CODE_H', '1000', 
         'L_ORD_001', 'ORD_001', '20260819', 'SPA_H', 'REV_H', 'GL_SPB_H', 'GL2_H', 
         0.0, 1000.00, 'Header Init', 'GLOBE', 1, 1),

        -- Row 2: Detail ('01') - Valid Unconfirmed Adjustment
        (2, '01', 'DETAIL_DATA', 'SYS_A', 'CREDIT_ADJ', 'GRP_2', 'CODE_D', '500.25', 
         'L_ORD_002', 'ORD_002', '20260819', 'SPA_01', 'REV_ADJ', 'GL_SPB_01', 'GL2_01', 
         60.03, 440.22, 'Valid Unconfirmed Adjustment', 'GLOBE', 1, 1),

        -- Row 3: Footer ('99')
        (3, '99', 'FOOTER_DATA', 'SYS_A', 'SUMMARY', 'GRP_ALL', 'CODE_F', '1500.25', 
         'L_ORD_003', 'ORD_003', '20260819', 'SPA_F', 'REV_F', 'GL_SPB_F', 'GL2_F', 
         0.0, 1500.25, 'Footer Summary', 'GLOBE', 1, 1),

        -- Row 4: Error/Unloaded Row ('01') - Simulating trGlobe_DP5_Unconfirmed_Adj_zLoaded_0_Error_LineUpd
        (4, '01', 'DETAIL_ERR', 'SYS_A', 'UNKNOWN_ADJ', 'GRP_ERR', 'CODE_ERR', '100.00', 
         'L_ORD_004', 'ORD_004', '20260819', 'SPA_ERR', 'REV_ERR', 'GL_SPB_ERR', 'GL2_ERR', 
         0.0, 100.00, 'Error: Missing GL Mapping', 'GLOBE', 0, 0);

END;
$procedure$
