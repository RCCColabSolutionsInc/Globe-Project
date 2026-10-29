CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_control_recon_ssrs_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_bccode VARCHAR(5);
BEGIN
-- = 'BC01';
	SELECT BillCycle INTO v_bccode FROM BillCycles WHERE CycleCode = p_cyclecode;
 
 
	PERFORM sort,column1,column2,column3,column4,column5,column6,column7
	FROM  dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_control_recon_cache
	WHERE BillCycle = v_bccode ORDER BY BillCycle,sort;
 
	-- EXEC [dbo].sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Control_Recon @BCCode
END;
$procedure$
