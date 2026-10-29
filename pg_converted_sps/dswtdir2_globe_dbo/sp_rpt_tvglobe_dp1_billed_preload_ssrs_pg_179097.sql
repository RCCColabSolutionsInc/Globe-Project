CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_preload_ssrs_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    v_bccode VARCHAR(5);
BEGIN
v_bccode := 'BC01';
	SELECT billcycle INTO v_bccode FROM dswtdir2_globe_dbo.billcycles WHERE cyclecode = par_cyclecode;


	PERFORM data,date,brand,customer_type,subscriber_type,charge_code
	,discount_code,amount,hits,uom,wo_indicator,cost_center
	,gl,nb_indicator,remarks,zdsp_order,zdsp_uniquekey
	FROM dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_preload_cache
	WHERE billcycle = v_bccode ORDER BY Data,zdsp_order;


	-- 	EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Preload] @BCCode
END;
$procedure$
