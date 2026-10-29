CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_adj_export_loadfilesel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        etl_db_dbo.fn_cleantxt(column01), etl_db_dbo.fn_cleantxt(column02),
        /* ,[etl_db].[dbo].[fn_CleanTxt]([Column03]) */
        (CASE
            WHEN LOWER(column01) = LOWER('99') THEN (SELECT
                CAST (SUM(CASE
                    WHEN aws_sqlserver_ext.ISNUMERIC(y.column07) THEN CAST (y.column07 AS NUMERIC(18, 2))
                    ELSE NULL
                END) AS VARCHAR(100))
                FROM dswtdir2_innove_dbo.txinnove_unbilled_adj_loadfilesel AS y
                WHERE LOWER(y.column01) = LOWER('01'))
            ELSE column03
        END), etl_db_dbo.fn_cleantxt(column04), etl_db_dbo.fn_cleantxt(column05), etl_db_dbo.fn_cleantxt(column06), etl_db_dbo.fn_cleantxt(CASE
            WHEN LOWER(column01) = LOWER('00') THEN CAST (CASE
                WHEN aws_sqlserver_ext.ISNUMERIC(column07) THEN CAST (column07 AS NUMERIC(18, 0))
                ELSE NULL
            END AS VARCHAR(200))
            ELSE CAST (CASE
                WHEN aws_sqlserver_ext.ISNUMERIC(column07) THEN CAST (column07 AS NUMERIC(18, 2))
                ELSE NULL
            END AS VARCHAR(200))
        END) AS column07, etl_db_dbo.fn_cleantxt(column08), etl_db_dbo.fn_cleantxt(column09), etl_db_dbo.fn_cleantxt(column10), etl_db_dbo.fn_cleantxt(column11), etl_db_dbo.fn_cleantxt(column12), etl_db_dbo.fn_cleantxt(column13), etl_db_dbo.fn_cleantxt(zdsp_order), etl_db_dbo.fn_cleantxt(zdsp_uniquekey)
        FROM dswtdir2_innove_dbo.txinnove_unbilled_adj_loadfilesel
        ORDER BY column01 NULLS FIRST, CAST (zdsp_order AS INTEGER) NULLS FIRST;
END;
$procedure$
