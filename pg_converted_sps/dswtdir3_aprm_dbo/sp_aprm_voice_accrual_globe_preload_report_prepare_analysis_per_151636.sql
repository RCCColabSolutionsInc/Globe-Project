CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_analysis_per()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache
           ("CHARGE DIRECTION"
           ,"TYPE"
           ,"INTERCONNECT PARTNER NAME"
           ,"CURRENCY"
           ,"SAP_Sum of SETTABLE DURATION"
           ,"SAP_Sum of NET SETTABLE AMT"
           ,"AUR DURATION"
           ,"AUR NET CHARGE"
           ,"DIFF SAPvsAUR DURATION"
           ,"DIFF SAPvsAUR AMT")
	SELECT "CHARGE DIRECTION"
		  ,"TYPE"
		  ,"INTERCONNECT PARTNER NAME"
		  ,"CURRENCY"
		  ,"SAP_Sum of SETTABLE DURATION"
		  ,"SAP_Sum of NET SETTABLE AMT"
		  ,"AUR DURATION"
		  ,"AUR NET CHARGE"
		  ,"DIFF SAPvsAUR DURATION"
		  ,"DIFF SAPvsAUR AMT"
	  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_analysis_per_partner_sapvsaurrptsel;
END;
$procedure$
