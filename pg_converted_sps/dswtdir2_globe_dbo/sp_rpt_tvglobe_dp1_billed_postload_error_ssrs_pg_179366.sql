CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_postload_error_ssrs_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    v_bccode VARCHAR(5);
BEGIN
v_bccode := 'BC01';
	SELECT billcycle INTO v_bccode FROM dswtdir2_globe_dbo.billcycles WHERE cyclecode = par_cyclecode;
	-- EXEC [dbo].[sp_MyBSS_Globe_EOC_Postload_Report_DP1_Billed_Error] @BCCode

	PERFORM Data
      ,Date
      ,Brand
      ,"Customer Type"
      ,"Subscriber Type"
      ,"Charge Code"
      ,"Discount Code"
      ,amount
      ,hits
      ,uom
      ,"WO Indicator"
      ,"Cost Center"
      ,gl
      ,"NB Indicator"
      ,remarks
      ,zdsp_order
      ,zdsp_uniquekey
      ,posting_log_message
  FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache
  WHERE billcycle = v_bccode ORDER BY Data,zdsp_order;
END;
$procedure$
