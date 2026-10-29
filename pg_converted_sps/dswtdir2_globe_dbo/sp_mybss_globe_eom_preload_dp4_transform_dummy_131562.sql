CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp4_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE DUMMY TARGET TABLE
    -- FIX APPLIED: Drop the table first to prevent stale schema conflicts from IF NOT EXISTS
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_r CASCADE;

    CREATE TABLE dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_r (
        zrownumber INTEGER,
        customer_type VARCHAR(255),
        customer_sub_type VARCHAR(255),
        primary_subscriber_type VARCHAR(255),
        adjustment_type VARCHAR(255),
        adjustment_date VARCHAR(255),
        adjustment_code_tax_code VARCHAR(255),
        adjustment_reason VARCHAR(255),
        amount VARCHAR(255),
        legal_entity VARCHAR(255),
        currency VARCHAR(255),
        write_off_activity_indicator VARCHAR(255),
        
        -- 'z' columns populated by downstream srGlobe_* stored procedures
        zlegacydsp_order VARCHAR(255),
        zdsp_order VARCHAR(255),
        zcustomer_type VARCHAR(255),
        zcustomer_sub_type VARCHAR(255),
        zprimary_subscriber_type VARCHAR(255),
        zadjustment_type VARCHAR(255),
        zadjustment_code VARCHAR(255),
        zadjustment_reason VARCHAR(255),
        zamount DOUBLE PRECISION,
        zposting_date VARCHAR(255),
        zspa VARCHAR(255),
        zrev_type VARCHAR(255),
        zgl_zspb VARCHAR(255),
        zgl2 VARCHAR(255),
        ztf0002s_zgl_zspb VARCHAR(255),
        zamount_net DOUBLE PRECISION,
        zbrand VARCHAR(255),
        zremark VARCHAR(255),
        zactive NUMERIC(1,0) DEFAULT 0 NOT NULL,
        zloaded NUMERIC(1,0) DEFAULT 0 NOT NULL
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS DUMMY DATA
    -- (This DELETE is technically redundant now because of the DROP TABLE, but kept 
    -- to mirror your exact business logic flow)
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_r;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Data modeled directly from "307. Unbilled Adjustments Report_G.XLSX"
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp4_unbilled_adj_tdir2_globe_307_unbilled_adjustments_r (
        zrownumber, customer_type, customer_sub_type, primary_subscriber_type, adjustment_type, 
        adjustment_date, adjustment_code_tax_code, adjustment_reason, amount, legal_entity, 
        currency, write_off_activity_indicator, zlegacydsp_order, zdsp_order, zcustomer_type, 
        zcustomer_sub_type, zprimary_subscriber_type, zadjustment_type, zadjustment_code, 
        zadjustment_reason, zamount, zposting_date, zspa, zrev_type, zgl_zspb, zgl2, 
        ztf0002s_zgl_zspb, zamount_net, zbrand, zremark, zactive, zloaded
    )
    VALUES 
        -- Row 1: Typical UNCRWOAR Credit 
        (1, 'E', 'C', 'GD', 'CRD', '02/06/2021', 'UNCRWOAR', 'CCWOAA', '-879.58', 'G', 'PHP', NULL,
         'L_ORD_101', 'ORD_101', 'ENTERPRISE', 'CORP', 'GD_PRE', 'CREDIT', 'UNCRWOAR',
         'CCWOAA', -879.58, '20260819', 'SPA_01', 'REV_UNCR', 'GL_SPB_101', 'GL2_101', 
         'ZTF_GL_101', -879.58, 'GLOBE', 'Valid Credit', 1, 1),

        -- Row 2: Termination Credit
        (2, 'C', 'U', 'GD', 'CRD', '01/03/2022', 'PNTY_CONS_GADGE', 'TERMRC', '-38064.16', 'G', 'PHP', NULL,
         'L_ORD_102', 'ORD_102', 'CONSUMER', 'RETAIL', 'GD_POST', 'CREDIT', 'PNTY_CONS_GADGE',
         'TERMRC', -38064.16, '20260819', 'SPA_02', 'REV_TERM', 'GL_SPB_102', 'GL2_102', 
         'ZTF_GL_102', -38064.16, 'GLOBE', 'Valid Termination', 1, 1),

        -- Row 3: Debit Balance Transfer w/ NULL Reason 
        (3, 'C', 'R', 'GD', 'DBT', '01/03/2022', 'BALTRNSF', NULL, '2206.06', 'G', 'PHP', NULL,
         'L_ORD_103', 'ORD_103', 'CONSUMER', 'RETAIL', 'GD_POST', 'DEBIT', 'BALTRNSF',
         NULL, 2206.06, '20260819', 'SPA_03', 'REV_BAL', 'GL_SPB_103', 'GL2_103', 
         'ZTF_GL_103', 2206.06, 'GLOBE', 'Valid Debit Transfer', 1, 1),

        -- Row 4: Error/Unloaded Row testing 
        (4, 'C', 'R', 'GD', 'DBT', '01/03/2022', 'INVALID_CODE', 'UNKNOWN', '100.00', 'G', 'PHP', 'Y',
         'L_ORD_104', 'ORD_104', 'CONSUMER', 'RETAIL', 'GD_PRE', 'DEBIT', 'INVALID_CODE',
         'UNKNOWN', 100.00, '20260819', 'SPA_ERR', 'REV_ERR', 'GL_SPB_ERR', 'GL2_ERR', 
         'ZTF_GL_ERR', 100.00, 'GLOBE', 'Error: Invalid Tax Code Mapping', 0, 0);

END;
$procedure$
