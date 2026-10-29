CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_manualreport_ssrs_pg(IN p_cyclecode character varying, INOUT p_result refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_bccode VARCHAR(5);
BEGIN
v_bccode := 'BC01';
	
	SELECT billCycle FROM BillCycles WHERE billcycle = p_cyclecode;
--	SELECT BillCycle INTO v_bccode FROM BillCycles WHERE CycleCode = p_cyclecode;
	-- EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Manual_Report] @BCCode

	OPEN p_result FOR
		SELECT zLegacyDSP_Order
			,Data
			,posting_date
			,SAPFIGL
			,customer_type
			,subscriber_type
			,charge_code
			,discount_code
			,Amount
			,Hits
			,UOM
			,Brand
			,SPA
			,rev_type
			,GL
			,SPB
			,Remarks
		FROM rpt_Preload_Report_DP1_Billed_ManualReport_Cache
		WHERE BillCycle = v_bccode ORDER BY SequenceID;
END;
$procedure$
