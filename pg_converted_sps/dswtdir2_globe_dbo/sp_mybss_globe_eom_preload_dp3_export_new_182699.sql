CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp3_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_export_count INT := 0;
    v_tgt_cols     TEXT[];
    v_src_cols     TEXT[];
    v_tgt_clause   TEXT;
    v_select_parts TEXT[];
    v_order_col    TEXT;
    v_sql          TEXT;
    i              INT;
BEGIN
    -- =========================================================================
    -- 0. SELF-HEALING EXPORT STAGING TABLE DDL
    -- 14 core extract columns matching legacy LoadFileSel
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export (
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
        column12          VARCHAR(50),
        column13          VARCHAR(50),
        column14          VARCHAR(100),
        zlegacycycle_code VARCHAR(10)
    );

    TRUNCATE TABLE dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export;

    -- =========================================================================
    -- 1. POPULATE EXPORT TABLE WITH CLEANED & FORMATTED ETL DATA
    -- Source: txglobe_dp3_unbilled_char_exportsel (legacy ExportSel source)
    -- =========================================================================
    IF EXISTS (
        SELECT 1 FROM information_schema.views 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'txglobe_dp3_unbilled_char_exportsel'
    ) OR EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'txglobe_dp3_unbilled_char_exportsel'
    ) THEN

        -- Retrieve physical column names for target (Columns 1-14)
        SELECT array_agg(column_name ORDER BY ordinal_position)
        INTO v_tgt_cols
        FROM information_schema.columns
        WHERE table_schema = 'dswtdir2_globe_dbo'
          AND table_name = 'txglobe_dp3_unbilled_char_exportsel_export'
          AND ordinal_position <= 14;

        -- Retrieve physical column names for source (Columns 1-14)
        SELECT array_agg(column_name ORDER BY ordinal_position)
        INTO v_src_cols
        FROM information_schema.columns
        WHERE table_schema = 'dswtdir2_globe_dbo'
          AND table_name = 'txglobe_dp3_unbilled_char_exportsel'
          AND ordinal_position <= 14;

        -- Format target column list: "column01", "column02", ...
        SELECT string_agg(quote_ident(c), ', ')
        INTO v_tgt_clause
        FROM unnest(v_tgt_cols) AS c;

        -- Replicate fn_CleanTxt logic: strip carriage returns, line feeds, tabs, trim
        v_select_parts := ARRAY[]::TEXT[];
        FOR i IN 1..cardinality(v_src_cols) LOOP
            v_select_parts := array_append(
                v_select_parts,
                format('TRIM(REGEXP_REPLACE(COALESCE(s.%I::TEXT, ''''), E''[\\r\\n\\t]+'', '' '', ''g''))', v_src_cols[i])
            );
        END LOOP;

        -- Order by Column 13 (zDSP_Order)
        v_order_col := v_src_cols[13];

        v_sql := format('
            INSERT INTO dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export (
                %s
            )
            SELECT 
                %s
            FROM dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel s
            ORDER BY 1, CAST(NULLIF(s.%I::TEXT, '''') AS INT);
        ', v_tgt_clause, array_to_string(v_select_parts, E',\n                '), v_order_col);

        EXECUTE v_sql;

    ELSIF EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'dswtdir2_globe_dbo' 
          AND table_name = 'ttglobe_dp3_unbilled_char'
    ) THEN
        -- Fallback directly from transformed staging table
        INSERT INTO dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export (
            column01, column02, column03, column04, column05, column06,
            column07, column08, column09, column10, column11, column12
        )
        SELECT 
            TRIM(REGEXP_REPLACE(COALESCE(column01::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column02::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column03::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column04::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column05::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column06::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column07::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column08::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column09::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column10::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column11::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g')),
            TRIM(REGEXP_REPLACE(COALESCE(column12::TEXT, ''), E'[\\r\\n\\t]+', ' ', 'g'))
        FROM dswtdir2_globe_dbo.ttglobe_dp3_unbilled_char
        ORDER BY 1;
    ELSE
        RAISE NOTICE 'WARNING: Source table or view for Unbilled Charges Preload Export was not found.';
    END IF;

    -- =========================================================================
    -- 2. TELEMETRY
    -- =========================================================================
    SELECT COUNT(1) INTO v_export_count 
    FROM dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export;

    RAISE NOTICE '=================================================================';
    RAISE NOTICE 'MYBSS GLOBE EOM DP3 UNBILLED CHARGES EXPORT READY: % record(s) staged.', v_export_count;
    RAISE NOTICE 'Target Table: dswtdir2_globe_dbo.txglobe_dp3_unbilled_char_exportsel_export';
    RAISE NOTICE 'FileExporter.py will now generate outbound/txGlobe_DP3_Unbilled_Char_ExportSel.txt';
    RAISE NOTICE '=================================================================';
END;
$procedure$
