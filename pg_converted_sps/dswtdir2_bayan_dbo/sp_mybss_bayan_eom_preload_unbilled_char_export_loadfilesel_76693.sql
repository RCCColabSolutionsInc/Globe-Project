CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_char_export_loadfilesel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        etl_db_dbo.fn_cleantxt(column01) AS column01, etl_db_dbo.fn_cleantxt(column02) AS column02, etl_db_dbo.fn_cleantxt(column03) AS column03, etl_db_dbo.fn_cleantxt(column04) AS column04, etl_db_dbo.fn_cleantxt(column05) AS column05, etl_db_dbo.fn_cleantxt(column06) AS column06, etl_db_dbo.fn_cleantxt(CASE
            WHEN LOWER(column01) = LOWER('00') THEN CAST (CAST (column07 AS NUMERIC(18, 0)) AS VARCHAR(200))
            ELSE CAST (CAST (column07 AS NUMERIC(18, 2)) AS VARCHAR(200))
        END) AS column07, etl_db_dbo.fn_cleantxt(column08) AS column08, etl_db_dbo.fn_cleantxt(column09) AS column09, etl_db_dbo.fn_cleantxt(column10) AS column10, etl_db_dbo.fn_cleantxt(column11) AS column11, etl_db_dbo.fn_cleantxt(column12) AS column12, etl_db_dbo.fn_cleantxt(column13) AS column13, etl_db_dbo.fn_cleantxt(column14) AS column14, etl_db_dbo.fn_cleantxt(column16) AS column16, etl_db_dbo.fn_cleantxt(column16) AS column16, etl_db_dbo.fn_cleantxt(column17) AS column17, etl_db_dbo.fn_cleantxt(zdsp_order) AS zdsp_order, etl_db_dbo.fn_cleantxt(zdsp_uniquekey) AS zdsp_uniquekey
        FROM dswtdir2_bayan_dbo.txbayan_unbilled_char_loadfilesel
        ORDER BY column01 NULLS FIRST, CAST (zdsp_order AS INTEGER) NULLS FIRST;
END;
$procedure$
