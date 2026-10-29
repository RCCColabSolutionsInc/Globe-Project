CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_control_recon_ssrs_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- In legacy MSSQL, this queried [rpt_Preload_Report_DP1_Billed_Control_Recon_Cache].
    -- In AWS Glue, PySpark extracts the table directly. This is purely a validation hook.
    RAISE NOTICE 'Dummy Globe Control Recon fetch executed successfully for cycle: %', par_cyclecode;
END;
$procedure$
