CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_export_count INT := 0; --call dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_export_new()
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING EXPORT TABLE DDL
    -- 12 core extract columns matching verified pgAdmin catalog
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export (
        column01          VARCHAR(50),
        column02          VARCHAR(50),
        column03          VARCHAR(50),
        column04          VARCHAR(50),
        column05          VARCHAR(50),
        column06          VARCHAR(50),
        column07          VARCHAR(50),
        column08          VARCHAR(50),
        column09          VARCHAR(50),
        column10          VARCHAR(50),
        column11          VARCHAR(50),
        column12          VARCHAR(100),
        zlegacycycle_code VARCHAR(10)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export;

    -- =========================================================================
    -- 1. POPULATE EXPORT TABLE WITH CLEANED & FORMATTED ETL DATA
    -- Clean text logic replicates legacy etl_db.dbo.fn_CleanTxt
    -- Order matches legacy: ORDER BY 1, CAST(zDSP_Order AS INT)
    -- =========================================================================
    IF EXISTS (
        SELECT 1 FROM information_schema.views 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'tvglobe_dp2_unearned_preload_rptsel'
    ) OR EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'tvglobe_dp2_unearned_preload_rptsel'
    ) THEN
        INSERT INTO dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export (
            column01, column02, column03, column04, column05, column06,
            column07, column08, column09, column10, column11, column12
        )
        SELECT 
            TRIM(REGEXP_REPLACE(COALESCE(data::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column01,
            TRIM(REGEXP_REPLACE(COALESCE(date::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column02,
            TRIM(REGEXP_REPLACE(COALESCE(brand::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column03,
            TRIM(REGEXP_REPLACE(COALESCE("Customer Type"::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column04,
            TRIM(REGEXP_REPLACE(COALESCE("Subscriber Type"::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column05,
            TRIM(REGEXP_REPLACE(COALESCE("Charge Code"::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column06,
            TRIM(REGEXP_REPLACE(
                CASE 
                    WHEN data = '00' THEN CAST(CAST(amount AS NUMERIC(18,0)) AS VARCHAR)
                    ELSE CAST(CAST(amount AS NUMERIC(18,2)) AS VARCHAR)
                END, E'[\\r\\n\\t]+', ' ', 'g')) AS column07,
            TRIM(REGEXP_REPLACE(COALESCE("Cost Center"::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column08,
            TRIM(REGEXP_REPLACE(COALESCE(gl::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column09,
            TRIM(REGEXP_REPLACE(COALESCE("NB Indicator"::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column10,
            TRIM(REGEXP_REPLACE(COALESCE(zdsp_order::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column11,
            TRIM(REGEXP_REPLACE(COALESCE(zdsp_uniquekey::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column12
        FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_preload_rptsel
        ORDER BY 1, CAST(NULLIF(zdsp_order::TEXT, '') AS INT);

    ELSIF EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'ttglobe_dp2_unearned'
    ) THEN
        INSERT INTO dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export (
            column01, column02, column03, column04, column05, column06,
            column07, column08, column09, column10, column11, column12
        )
        SELECT 
            TRIM(REGEXP_REPLACE(COALESCE(data::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column01,
            TRIM(REGEXP_REPLACE(COALESCE(posting_date::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column02,
            TRIM(REGEXP_REPLACE(COALESCE(sapfigl::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column03,
            TRIM(REGEXP_REPLACE(COALESCE(ct::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column04,
            TRIM(REGEXP_REPLACE(COALESCE(st::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column05,
            TRIM(REGEXP_REPLACE(COALESCE(ch_code::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column06,
            TRIM(REGEXP_REPLACE(
                CASE 
                    WHEN data = '00' THEN CAST(CAST(amount AS NUMERIC(18,0)) AS VARCHAR)
                    ELSE CAST(CAST(amount AS NUMERIC(18,2)) AS VARCHAR)
                END, E'[\\r\\n\\t]+', ' ', 'g')) AS column07,
            TRIM(REGEXP_REPLACE(COALESCE(cc::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column08,
            TRIM(REGEXP_REPLACE(COALESCE(gl_code::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column09,
            TRIM(REGEXP_REPLACE(COALESCE(nb_ind::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column10,
            TRIM(REGEXP_REPLACE(COALESCE(CASE WHEN data <> '01' THEN NULL ELSE zdsp_order END::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column11,
            TRIM(REGEXP_REPLACE(COALESCE(zdsp_uniquekey::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')) AS column12
        FROM dswtdir2_globe_dbo.ttglobe_dp2_unearned
        WHERE zloaded = '0'
        ORDER BY 1, CAST(NULLIF(zdsp_order::TEXT, '') AS INT);
    ELSE
        RAISE NOTICE 'WARNING: Source table or view for Unearned Preload Export was not found.';
    END IF;

    -- =========================================================================
    -- 2. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_export_count 
    FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM PRELOAD EXPORT READY: % record(s) staged.', v_export_count;
    RAISE NOTICE 'Target Table: dswtdir2_globe_dbo.tvglobe_dp2_unearned_loadfilesel_export';
    RAISE NOTICE 'FileExporter.py will now generate outbound/txGlobe_DP2_Unearned_LoadFileSel.txt';
    RAISE NOTICE '=================================================================';
END;
$procedure$
