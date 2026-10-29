CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_usd_billed_data_preload_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* 
     * STATE RESET 
     * Bypassing targeted DELETEs and temporary load procedures in favor of TRUNCATE 
     * to guarantee a completely clean environment for repetitive dummy data pipeline testing.
     */
    TRUNCATE TABLE dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd;
    TRUNCATE TABLE dswtdir1_dbo.ttbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd;

    /* 
     * DUMMY DATA INJECTION - STAGING TABLE
     * Replacing dynamic INSERT INTO ... SELECT and nested business rules with hardcoded dummy rows.
     */
    INSERT INTO dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd (
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
    ) VALUES
    -- Header Rows (1-8)
    (1, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_01', 'BATCH_001', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '1000.00', '1', 'EA'),
    (2, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_02', 'BATCH_002', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '2000.00', '1', 'EA'),
    (3, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_03', 'BATCH_003', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '3000.00', '1', 'EA'),
    (4, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_04', 'BATCH_004', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '4000.00', '1', 'EA'),
    (5, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_05', 'BATCH_005', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '5000.00', '1', 'EA'),
    (6, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_06', 'BATCH_006', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '6000.00', '1', 'EA'),
    (7, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_07', 'BATCH_007', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '7000.00', '1', 'EA'),
    (8, 'H00', 'SYS_SRC', 'SYS_TGT', 'EVT_08', 'BATCH_008', '20260101', '120000', 'HDR_DAT8', 'HDR_DAT9', 'USD', '8000.00', '1', 'EA'),
    
    -- Transaction/Detail Rows (9-25)
    (9,  'D01', '20260101', '20260102', 'CAT_A', 'AREA_1', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '150.00', '1', 'EA'),
    (10, 'D01', '20260101', '20260102', 'CAT_A', 'AREA_1', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '250.00', '1', 'EA'),
    (11, 'D01', '20260101', '20260102', 'CAT_A', 'AREA_1', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '350.00', '1', 'EA'),
    (12, 'D01', '20260101', '20260102', 'CAT_B', 'AREA_2', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '450.00', '1', 'EA'),
    (13, 'D01', '20260101', '20260102', 'CAT_B', 'AREA_2', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '550.00', '1', 'EA'),
    (14, 'D01', '20260101', '20260102', 'CAT_B', 'AREA_2', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '650.00', '1', 'EA'),
    (15, 'D01', '20260101', '20260102', 'CAT_C', 'AREA_3', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '750.00', '1', 'EA'),
    (16, 'D01', '20260101', '20260102', 'CAT_C', 'AREA_3', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '850.00', '1', 'EA'),
    (17, 'D01', '20260101', '20260102', 'CAT_C', 'AREA_3', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '950.00', '1', 'EA'),
    (18, 'D01', '20260101', '20260102', 'CAT_D', 'AREA_4', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1050.00', '1', 'EA'),
    (19, 'D01', '20260101', '20260102', 'CAT_D', 'AREA_4', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1150.00', '1', 'EA'),
    (20, 'D01', '20260101', '20260102', 'CAT_D', 'AREA_4', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1250.00', '1', 'EA'),
    (21, 'D01', '20260101', '20260102', 'CAT_E', 'AREA_5', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1350.00', '1', 'EA'),
    (22, 'D01', '20260101', '20260102', 'CAT_E', 'AREA_5', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1450.00', '1', 'EA'),
    (23, 'D01', '20260101', '20260102', 'CAT_E', 'AREA_5', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1550.00', '1', 'EA'),
    (24, 'D01', '20260101', '20260102', 'CAT_F', 'AREA_6', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1650.00', '1', 'EA'),
    (25, 'D01', '20260101', '20260102', 'CAT_F', 'AREA_6', 'DTL_DAT6', 'DTL_DAT7', 'DTL_DAT8', 'DTL_DAT9', 'USD', '1750.00', '1', 'EA')
    ON CONFLICT DO NOTHING;

    /* 
     * DUMMY DATA INJECTION - TARGET TABLE
     * Populating the target table directly to bypass the internal rules and triggers,
     * ensuring downstream pipeline components have required mock data.
     */
    INSERT INTO dswtdir1_dbo.ttbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd (
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
    ) 
    SELECT 
        zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13
    FROM dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd
    ON CONFLICT DO NOTHING;

    /* Note: Over 35 original CALL execution rules (including loaddata$TMP) omitted intentionally to bypass heavy business logic. */

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Table validation failed: %', SQLERRM;
END;
$procedure$
