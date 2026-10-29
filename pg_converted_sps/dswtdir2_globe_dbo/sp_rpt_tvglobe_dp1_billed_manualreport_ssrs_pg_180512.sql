CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_manualreport_ssrs_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_bccode VARCHAR(5);
BEGIN
v_bccode := 'BC01';
	SELECT BillCycle INTO v_bccode FROM BillCycles WHERE CycleCode = p_cyclecode;
	-- EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Manual_Report] @BCCode
 
 
	PERFORM zLegacydsp_order
			,data
			,posting_date
			,sapfigl
			,customer_type
			,subscriber_type
			,charge_code
			,discount_code
			,amount
			,hits
			,uom
			,brand
			,spa
			,rev_type
			,gl
			,spb
			,remarks
	FROM rpt_Preload_Report_DP1_Billed_ManualReport_Cache
	WHERE BillCycle = v_bccode 
	ORDER BY zLegacydsp_order NULLS FIRST;
END;
$procedure$
