CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp2_report_prepare_unearned_manual_r()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE t$ztf0188s
    AS
    SELECT
        *
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0188s
        WHERE LOWER(mandt) = LOWER('300');
    CREATE TEMPORARY TABLE t$tvglobe_dp2_unearned_manual_report_rptsel
    AS
    SELECT
        tt.ct, tt.st, tt.ch_code AS "Charge Code", tt.amount, CAST (COALESCE(ueg.total_unearned_sum, 0) AS NUMERIC(38, 2)) AS umsf, CAST (ROUND(CAST (COALESCE(tt.amount, 0) AS NUMERIC(38, 2)) - CAST (COALESCE(ueg.total_unearned_sum, 0) AS NUMERIC(38, 2)), 2) AS NUMERIC(38, 2)) AS diff, tt.spa, tt.rev_type, ztf.glcode AS gl, tt.spb, tt.remarks
        FROM dswtdir2_globe_dbo.ttglobe_dp2_unearned_agg AS tt
        LEFT OUTER JOIN dswtdir2_globe_dbo."324_Unearned_Group_Total" AS ueg
            ON LOWER(tt.ct) = LOWER(ueg."Customer Type") AND LOWER(tt.st) = LOWER(ueg."Service Type") AND LOWER(tt.ch_code) = LOWER(ueg."Charge Code")
        LEFT OUTER JOIN dswtdir2_globe_dbo.t$ztf0188s AS ztf
            ON LOWER(COALESCE(tt.ch_code, '')) = LOWER(ztf.chcode)
        WHERE (LOWER(tt.data) = LOWER('01'));
    TRUNCATE TABLE dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp2_unearned_manual_report_cache (ct, st, "Charge Code", amount, umsf, diff, spa, rev_type, gl, spb, remarks)
    SELECT
        ct, st, "Charge Code", amount, umsf, diff, spa, rev_type, gl, spb, remarks
        FROM t$tvglobe_dp2_unearned_manual_report_rptsel;
    /*
    
    DROP TABLE IF EXISTS t$ztf0188s;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$tvglobe_dp2_unearned_manual_report_rptsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
