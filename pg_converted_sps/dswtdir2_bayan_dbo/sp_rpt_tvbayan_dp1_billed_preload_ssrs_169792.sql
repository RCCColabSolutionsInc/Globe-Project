CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_ssrs(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
    SET 
        column08 = CAST(ROUND(NULLIF(column08, '')::NUMERIC, 2) AS VARCHAR),
        column09 = CAST(ROUND(NULLIF(column09, '')::NUMERIC, 2) AS VARCHAR)
    WHERE billcycle = par_cyclecode;

    RAISE NOTICE 'Executed query returned successfully %.', par_cyclecode;
END;
$procedure$
