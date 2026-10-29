CREATE OR REPLACE PROCEDURE public.sp_sync_rpt_postload_report_dp1_billed_error_cache()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author     : Winston Madiano                  */
/* Create date: Feb 9, 2023                      */
/* Description: Transform postload data          */
/* ============================================= */
/* Modified by: Kristian Corrales                */
/* Create date: October 14, 2026                 */
/* Description: Sync billed data into error cache */
/* ============================================= */
DECLARE
    v_rows_inserted BIGINT := 0;
    v_rows_updated  BIGINT := 0;
    v_start_time    TIMESTAMP WITH TIME ZONE;
    v_end_time      TIMESTAMP WITH TIME ZONE;
    v_duration      INTERVAL;
BEGIN
    v_start_time := clock_timestamp();
    RAISE NOTICE 'Procedure started at: %', v_start_time;

    -- Step 1: Update existing records in error cache
    UPDATE public.rpt_Postload_Report_DP1_Billed_Error_Cache AS tgt
    SET zloaded = 1
    WHERE EXISTS (
        SELECT 1
        FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
        WHERE lower(tgt.zdsp_order::text) = lower(odbc.zdsp_order::text)
    );

    GET DIAGNOSTICS v_rows_updated = ROW_COUNT;
    RAISE NOTICE 'Rows updated in error cache: %', v_rows_updated;

    -- Step 2: Insert new records into error cache
    INSERT INTO public.rpt_Postload_Report_DP1_Billed_Error_Cache
        (zdsp_order, zloaded, zsource)
    SELECT DISTINCT odbc.zdsp_order, 1, 'ODBC'
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
    WHERE odbc.zdsp_order IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM public.rpt_Postload_Report_DP1_Billed_Error_Cache AS tgt
          WHERE lower(tgt.zdsp_order::text) = lower(odbc.zdsp_order::text)
      );

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    RAISE NOTICE 'Rows inserted into error cache: %', v_rows_inserted;

    -- Step 3: Report execution duration
    v_end_time := clock_timestamp();
    v_duration := v_end_time - v_start_time;
    RAISE NOTICE 'Procedure ended at: %', v_end_time;
    RAISE NOTICE 'Execution duration: %', v_duration;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Procedure failed at: %', clock_timestamp();
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE 'Error message: %', SQLERRM;
        RAISE;
END;
$procedure$
