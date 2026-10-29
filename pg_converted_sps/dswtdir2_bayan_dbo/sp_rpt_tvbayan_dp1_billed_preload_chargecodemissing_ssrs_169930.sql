CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_chargecodemissing_ssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    PERFORM 1
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    LIMIT 1;

    RAISE NOTICE 'Dummy Charge Code Missing fetch executed successfully.';

END;
$procedure$
