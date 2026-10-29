CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_transform()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_rows_inserted INTEGER;
    v_rows_updated INTEGER;
    v_start_timestamp TIMESTAMP;
    v_end_timestamp TIMESTAMP;
    v_duration INTERVAL;
BEGIN
    v_start_timestamp := clock_timestamp();

    -- 1. INSERT NEW RECORDS
    INSERT INTO dswtdir2_bayan_dbo.rpt_Postload_Report_DP1_Billed_Error_Cache(
        column01, column02, column03, column04, column05,
        column06, column07, column08, column09,
        column10, column11, column12, column13, column14,
        column15, column16, column17, column18, column19,
        zdsp_order, zdsp_uniquekey, billcycle, zloaded
    )
    SELECT
        src.mandt,          -- column01
        src.z_source_name,  -- column02
        src.z_upld_filename,-- column03
        src.z_line_item,    -- column04
        src.z_prog_name,    -- column05
        src.z_message,      -- column06
        src.z_date,         -- column07
        src.z_time,         -- column08
        src.z_user_id,      -- column09
        NULL, NULL, NULL, NULL, NULL,  -- column10–14
        NULL, NULL, NULL, NULL, NULL,  -- column15–19
        src.zdsp_order,
        src.zdsp_uniquekey,
        NULL,               -- billcycle (map later if available)
        1                   -- zloaded
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs src
    WHERE src.zdsp_order IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dswtdir2_bayan_dbo.ttbayan_billed tgt
          WHERE lower(tgt.zdsp_order::TEXT) = lower(src.zdsp_order::TEXT)
      );

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;

    -- 2. UPDATE EXISTING RECORDS
    UPDATE dswtdir2_bayan_dbo.ttbayan_billed AS tgt
    SET zloaded = 1
    WHERE EXISTS (
        SELECT 1
        FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS src
        WHERE lower(tgt.zdsp_order::TEXT) = lower(src.zdsp_order::TEXT)
    )
    AND tgt.zloaded IS DISTINCT FROM 1;

    GET DIAGNOSTICS v_rows_updated = ROW_COUNT;

    -- Capture end time and duration
    v_end_timestamp := clock_timestamp();
    v_duration := v_end_timestamp - v_start_timestamp;

    -- Output execution metrics
    RAISE NOTICE '=====================================================';
    RAISE NOTICE 'Procedure: sp_mybss_bayan_eoc_postload_transform';
    RAISE NOTICE 'Start Time       : %', v_start_timestamp;
    RAISE NOTICE 'End Time         : %', v_end_timestamp;
    RAISE NOTICE 'Duration         : %', v_duration;
    RAISE NOTICE 'Rows Inserted    : %', v_rows_inserted;
    RAISE NOTICE 'Rows Updated     : %', v_rows_updated;
    RAISE NOTICE '=====================================================';

END;
$procedure$
