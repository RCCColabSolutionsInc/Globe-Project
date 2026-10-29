CREATE OR REPLACE PROCEDURE public.sp_sync_rpt_postload_error_cache()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_rows_inserted BIGINT := 0;
    v_rows_updated  BIGINT := 0;
    v_start_time    TIMESTAMPTZ;
    v_end_time      TIMESTAMPTZ;
    v_duration      INTERVAL;
    v_sqlstate      TEXT;
    v_sqlerrm       TEXT;
BEGIN
    v_start_time := clock_timestamp();
    RAISE NOTICE 'Procedure started at: %', v_start_time;

    -- Step 1: Update existing records
    UPDATE dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache AS tgt
    SET zloaded = 1
    WHERE EXISTS (
        SELECT 1
        FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS src
        WHERE src.zdsp_order IS NOT NULL
          AND lower(tgt.zdsp_order::TEXT) = lower(src.zdsp_order::TEXT)
          AND tgt.zloaded IS DISTINCT FROM 1
    );
    GET DIAGNOSTICS v_rows_updated = ROW_COUNT;

    -- Step 2: Insert new records
    INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache (
        column01, column02, column03, column04, column05,
        column06, column07, column08, column09,
        column10, column11, column12, column13, column14,
        column15, column16, column17, column18, column19,
        zdsp_order, zdsp_uniquekey, billcycle
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
        NULL                -- billcycle (map later if available)
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs src
    WHERE src.zdsp_order IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache tgt
          WHERE lower(tgt.zdsp_order::TEXT) = lower(src.zdsp_order::TEXT)
      );

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;

    -- Step 3: Report execution metrics
    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE 'Rows updated: %', v_rows_updated;
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE 'Execution duration: %', v_duration;
    RAISE NOTICE 'Procedure completed at: %', v_end_time;

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS
            v_sqlstate = RETURNED_SQLSTATE,
            v_sqlerrm = MESSAGE_TEXT;

        v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;

        RAISE LOG
            'sp_sync_rpt_postload_error_cache failed. SQLSTATE: %, SQLERRM: %, Rows inserted: %, Rows updated: %, Duration: %',
            v_sqlstate, v_sqlerrm, v_rows_inserted, v_rows_updated, v_duration;

        RAISE EXCEPTION
            'Error syncing postload error cache. SQLSTATE: %, SQLERRM: %',
            v_sqlstate, v_sqlerrm;
END;
$procedure$
