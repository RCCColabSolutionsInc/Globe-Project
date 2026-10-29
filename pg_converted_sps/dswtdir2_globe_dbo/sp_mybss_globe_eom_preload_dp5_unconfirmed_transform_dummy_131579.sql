CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- ===============================================================================
    -- 1. MATERIALIZE DUMMY TARGET TABLE
    -- Table name is truncated to comply with PostgreSQL's 63-character identifier limit
    -- Schema matches stGlobe_DP5_Unconfirmed_TDIR2_Globe_Unconfirmed_Advanced_MSF_Charges
    -- Includes base columns from the report + the 'z' columns inferred from downstream SPs
    -- ===============================================================================
    DROP TABLE IF EXISTS dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_adv_msf_char CASCADE;

    CREATE TABLE dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_adv_msf_char (
        zrownumber INTEGER,
        customer_type VARCHAR(255),
        service_type VARCHAR(255),
        revenue_type VARCHAR(255),
        charge_code VARCHAR(255),
        offer_id VARCHAR(255),
        offer_description VARCHAR(255),
        charge_type VARCHAR(255),
        amount VARCHAR(255),
        
        -- 'z' columns populated by downstream srGlobe_* stored procedures
        zlegacydsp_order VARCHAR(255),
        zdsp_order VARCHAR(255),
        zposting_date VARCHAR(255),
        zspa VARCHAR(255),
        zrev_type VARCHAR(255),
        zgl_zspb VARCHAR(255),
        zamount_net DOUBLE PRECISION,
        zremark VARCHAR(255),
        zactive NUMERIC(1,0) DEFAULT 0 NOT NULL,
        zbrand VARCHAR(255),
        zloaded NUMERIC(1,0) DEFAULT 0 NOT NULL
    );

    -- ===============================================================================
    -- 2. CLEAR PREVIOUS DUMMY DATA
    -- Mimics the "DELETE FROM [dbo].[stGlobe_DP5_Unconfirmed_...]" step
    -- ===============================================================================
    DELETE FROM dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_adv_msf_char;

    -- ===============================================================================
    -- 3. INSERT DUMMY DATA
    -- Data modeled directly from "Unconfirmed Advanced MSF Charges Summary Report - Monthly.XLSX"
    -- Simulates the result of the initial INSERT AND the downstream SP executions.
    -- ===============================================================================
    INSERT INTO dswtdir2_globe_dbo.stglobe_dp5_unconfirmed_tdir2_globe_unconfirmed_adv_msf_char (
        zrownumber, customer_type, service_type, revenue_type, charge_code, offer_id, 
        offer_description, charge_type, amount, zlegacydsp_order, zdsp_order, zposting_date, 
        zspa, zrev_type, zgl_zspb, zamount_net, zremark, zactive, zbrand, zloaded
    )
    VALUES 
        -- Row 1: Typical Consumer (C) Debit Charge
        (1, 'C', 'MT', 'RC', 'MSF_GFLEX250_J', '8739983', 'GFLEXPLAN 250', 'DBT', '6473.09',
         'L_ORD_501', 'ORD_501', '20260819', 'SPA_01', 'REV_RC', 'GL_SPB_501', 
         6473.09, 'Valid Unconfirmed Charge', 1, 'GLOBE', 1),

        -- Row 2: Standard/SMB (S) Discount Charge
        (2, 'S', 'MT', 'RC', 'MYSTIQRC', '19083807', 'Pack - myBiz Unli AllNet Calls, Landline & SMS 400', 'DSC', '-4760676.2',
         'L_ORD_502', 'ORD_502', '20260819', 'SPA_02', 'REV_DSC', 'GL_SPB_502', 
         -4760676.20, 'Valid Unconfirmed Discount', 1, 'GLOBE', 1),

        -- Row 3: Enterprise (E) Debit Charge
        (3, 'E', 'MT', 'RC', 'MSF_BST2_2499', '18285608', 'Business Boost 2.0 2499', 'DBT', '2378512.5',
         'L_ORD_503', 'ORD_503', '20260819', 'SPA_03', 'REV_RC', 'GL_SPB_503', 
         2378512.50, 'Valid Enterprise Charge', 1, 'GLOBE', 1),

        -- Row 4: Error/Unloaded Row testing (Simulating trGlobe_DP5_Unconfirmed_zLoaded_0_Error_LineUpd)
        (4, 'C', 'MT', 'RC', 'INVALID_MSF', '000000', 'Unknown Plan', 'DBT', '100.00',
         'L_ORD_504', 'ORD_504', '20260819', 'SPA_ERR', 'REV_ERR', 'GL_SPB_ERR', 
         100.00, 'Error: Charge Code mapping missing', 0, 'GLOBE', 0);

END;
$procedure$
