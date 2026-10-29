CREATE OR REPLACE PROCEDURE public.sp_sync_ttbayan_billed()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author     : Winston Madiano                  */
/* Create date: Feb 9, 2023                      */
/* Description: Transform postload data          */
/* ============================================= */
/* Modified by: Kristian Corrales                */
/* Create date: October 14, 2026                 */
/* Description: Transform postload data          */
/* ============================================= */
BEGIN

    -- Step 1: Update existing records to mark them as loaded.
    UPDATE dswtdir2_bayan_dbo.ttbayan_billed AS tgt
    SET zloaded = 1
    WHERE EXISTS (
        SELECT 1
        FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
        WHERE lower(tgt.zdsp_order::text) =
              lower(odbc.zdsp_order::text)
    );

    -- Step 2: Insert new records and populate zsource.
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_billed
    (zdsp_order, zloaded)
SELECT DISTINCT odbc.zdsp_order, 1
FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
WHERE odbc.zdsp_order IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dswtdir2_bayan_dbo.ttbayan_billed AS tgt
      WHERE lower(tgt.zdsp_order::text) =
            lower(odbc.zdsp_order::text)
  );
    SELECT DISTINCT ON (lower(odbc.zdsp_order::text))
        odbc.zdsp_order,
        1,
        'ODBC'::varchar
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
    WHERE odbc.zdsp_order IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM dswtdir2_bayan_dbo.ttbayan_billed AS tgt
          WHERE lower(tgt.zdsp_order::text) =
                lower(odbc.zdsp_order::text)
      )
    ORDER BY lower(odbc.zdsp_order::text);

END;
$procedure$
