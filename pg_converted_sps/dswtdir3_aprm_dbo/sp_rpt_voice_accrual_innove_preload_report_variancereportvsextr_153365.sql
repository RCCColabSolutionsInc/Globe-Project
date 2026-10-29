CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_innove_preload_report_variancereportvsextr()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT "DIRECTION"
		  ,"SAP VENDOR CODE"
		  ,"INTERCONNECT PARTNER CODE"
		  ,"Report DURATION"
		  ,"Report SETTABLE AMT"
		  ,"Extract DURATION"
		  ,"Extract SETTABLE AMT"
		  ,"Difference Duration"
		  ,"Difference SETTABLE AMT"
	  FROM dswtdir3_aprm_dbo.rpt_voice_accrual_innove_preload_report_variancereportvsextract2_cache;
END;
$procedure$
