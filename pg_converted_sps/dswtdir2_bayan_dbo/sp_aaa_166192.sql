CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_aaa()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
		SELECT * FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache; --order BY "billcycle" asc, "zdsp_order"::INTEGER asc;

END;
$procedure$
