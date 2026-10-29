CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_export_unearned_loadfilesel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    WITH qu
    AS (SELECT
        etl_db_dbo.fn_cleantxt(data) AS column01, etl_db_dbo.fn_cleantxt(date) AS column02, etl_db_dbo.fn_cleantxt(brand) AS column03, etl_db_dbo.fn_cleantxt("Customer Type") AS column04, etl_db_dbo.fn_cleantxt("Subscriber Type") AS column05, etl_db_dbo.fn_cleantxt("Charge Code") AS column06, etl_db_dbo.fn_cleantxt(CASE
            WHEN LOWER(data) = LOWER('00') THEN CAST (CAST (amount AS NUMERIC(18, 0)) AS VARCHAR(200))
            ELSE CAST (CAST (amount AS NUMERIC(18, 2)) AS VARCHAR(200))
        END) AS column07, etl_db_dbo.fn_cleantxt("Cost Center"), etl_db_dbo.fn_cleantxt(gl), etl_db_dbo.fn_cleantxt("NB Indicator"), etl_db_dbo.fn_cleantxt(zdsp_order), etl_db_dbo.fn_cleantxt(zdsp_uniquekey)
        FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_preload_rptsel
        ORDER BY 1 NULLS FIRST, CAST (zdsp_order AS INTEGER) NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);
END;
$procedure$
