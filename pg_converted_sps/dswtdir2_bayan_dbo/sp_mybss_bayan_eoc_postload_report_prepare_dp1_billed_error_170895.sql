CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_prepare_dp1_billed_error()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_rows_inserted  BIGINT := 0;
    v_rows_updated   BIGINT := 0;
    v_started_at     TIMESTAMP;
    v_duration       INTERVAL;
    v_sqlstate       TEXT;
    v_sqlerrm        TEXT;
BEGIN
    v_started_at := clock_timestamp();

    RAISE NOTICE
        'Starting sp_MyBSS_Bayan_EOC_Postload_Report_Prepare_DP1_Billed_Error';

    -- Step 1: Update existing report-cache records.
    UPDATE dswtdir2_bayan_dbo.rpt_postload_report_dp1_billed_error_cache AS tgt
    SET zloaded = 1
    WHERE EXISTS (
        SELECT 1
        FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS src
        WHERE src.zdsp_order IS NOT NULL
          AND lower(tgt.zdsp_order::TEXT) =
              lower(src.zdsp_order::TEXT)
    );

    GET DIAGNOSTICS v_rows_updated = ROW_COUNT;

    -- Step 2: Insert missing records with a non-NULL zsource.
    INSERT INTO dswtdir2_bayan_dbo.rpt_postload_report_dp1_billed_error_cache
        (zdsp_order, zloaded, zsource)
    SELECT DISTINCT ON (lower(src.zdsp_order::TEXT))
        src.zdsp_order,
        1,
        'ODBC'
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS src
    WHERE src.zdsp_order IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dswtdir2_bayan_dbo.rpt_postload_report_dp1_billed_error_cache AS tgt
          WHERE lower(tgt.zdsp_order::TEXT) =
                lower(src.zdsp_order::TEXT)
      )
    ORDER BY lower(src.zdsp_order::TEXT);

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;

    -- Step 3: Report execution metrics.
    v_duration := clock_timestamp() - v_started_at;

    RAISE NOTICE 'Procedure completed successfully.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE 'Rows updated: %', v_rows_updated;
    RAISE NOTICE 'Execution duration: %', v_duration;

EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS
            v_sqlstate = RETURNED_SQLSTATE,
            v_sqlerrm  = MESSAGE_TEXT;

        v_duration := clock_timestamp() - v_started_at;

        RAISE LOG
            'Procedure sp_MyBSS_Bayan_EOC_Postload_Report_Prepare_DP1_Billed_Error failed. SQLSTATE: %, SQLERRM: %, Rows inserted: %, Rows updated: %, Duration: %',
            v_sqlstate,
            v_sqlerrm,
            v_rows_inserted,
            v_rows_updated,
            v_duration;

        RAISE EXCEPTION
            'Postload report preparation failed. SQLSTATE: %, SQLERRM: %',
            v_sqlstate,
            v_sqlerrm;
END;
$procedure$
