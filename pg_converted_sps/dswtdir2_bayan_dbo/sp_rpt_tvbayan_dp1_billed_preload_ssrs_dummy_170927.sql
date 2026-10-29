CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_ssrs_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    RAISE NOTICE 'Dummy Billed Preload fetch executed successfully for %.', par_cyclecode;
END;
$procedure$
