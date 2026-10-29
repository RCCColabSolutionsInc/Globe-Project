CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp2_report_prepare_unearned_valid()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* RT_ZFFI_REPORT_ODBC_35D */
    /* SELECT * INTO #vw_RT_ZFFI_REPORT_ODBC FROM [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC]; */
    /* SELECT * INTO #LATEST_ODBC FROM [dgS4HANA_TDIR1].[dbo].[vw_ZFFI_REPORT_ODBC_LATESTLOGS] x; */
    CREATE TEMPORARY TABLE t$tvglobe_dp2_unearned_postload_validrptsel
    AS
    WITH qu
    AS (SELECT
        zlegacydsp_order, data AS data, posting_date AS date, sapfigl AS brand, ct AS "Customer Type", st AS "Subscriber Type", ch_code AS "Charge Code", amount AS amount, wo_ind AS "WO Indicator", cc AS "Cost Center", gl_code AS gl, nb_ind AS "NB Indicator", remarks, ttglobe_dp2_unearned.zdsp_order, ttglobe_dp2_unearned.zdsp_uniquekey, x.z_message AS posting_log_message
        FROM dswtdir2_globe_dbo.ttglobe_dp2_unearned
        INNER JOIN
        /* INNER JOIN [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_REPORT_ODBC] x -- ZFFI_REPORT_ODBC_LATESTLOGS */
        dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
        /* #vw_RT_ZFFI_REPORT_ODBC x */
            ON LOWER(x.zdsp_order) = LOWER(ttglobe_dp2_unearned.zdsp_order) AND LOWER(x.zdsp_uniquekey) = LOWER(ttglobe_dp2_unearned.zdsp_uniquekey)
        /*
        Start of change by ZBOA0022  - 03/08/2021
        WHERE  ( (select Cast(ISNULL(Difference, 0) as numeric(38, 2))
                  from   tvGlobe_DP2_Unearned_Recon_AmountRptSel) <= 100000.00
                 AND (select Cast(ISNULL(Difference, 0) as numeric(38, 2))
        */
        WHERE ((SELECT
            CAST (COALESCE(regexp_replace(difference, ',', '', 'gi'), 0) AS NUMERIC(38, 2))
            FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_recon_amountrptsel) <= 100000.00 AND (SELECT
            CAST (COALESCE(regexp_replace(difference, ',', '', 'gi'), 0) AS NUMERIC(38, 2))
            FROM dswtdir2_globe_dbo.tvglobe_dp2_unearned_recon_amountrptsel) >= - 100000.00) AND
        /* End of change by ZBOA0022  - 03/08/2021 */
        zloaded = '1'
        ORDER BY data NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp2_unearned_valid_cache (zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message)
    SELECT
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message
        /* FROM [tvGlobe_DP2_Unearned_Postload_ValidRptSel] */
        FROM t$tvglobe_dp2_unearned_postload_validrptsel;
    /*
    
    DROP TABLE IF EXISTS t$tvglobe_dp2_unearned_postload_validrptsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
