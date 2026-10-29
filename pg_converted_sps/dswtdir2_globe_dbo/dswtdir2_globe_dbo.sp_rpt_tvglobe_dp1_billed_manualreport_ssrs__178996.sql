CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo."dswtdir2_globe_dbo.sp_rpt_tvglobe_dp1_billed_manualreport_ssrs_"()
 LANGUAGE plpgsql
AS $procedure$

	BEGIN
		SELECT * FROM BillCycles; 
	END;
$procedure$
