CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE t$tvglobe_dp2_unearned_preload_rptsel
    AS
    WITH qu
    AS (SELECT
        zlegacydsp_order, data AS data, posting_date AS date, sapfigl AS brand, ct AS "Customer Type", st AS "Subscriber Type", ch_code AS "Charge Code", amount AS amount, wo_ind AS "WO Indicator", cc AS "Cost Center", gl_code AS gl, nb_ind AS "NB Indicator", remarks,
        CASE
            WHEN LOWER(data) <> LOWER('01') THEN NULL
            ELSE zdsp_order
        END AS zdsp_order, zdsp_uniquekey
        FROM dswtdir2_globe_dbo.ttglobe_dp2_unearned
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
        zloaded = '0'
        ORDER BY data NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_preload_cache (zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey)
    SELECT
        zlegacydsp_order, data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", amount, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey
        FROM t$tvglobe_dp2_unearned_preload_rptsel;
    /*
    
    DROP TABLE IF EXISTS t$tvglobe_dp2_unearned_preload_rptsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
