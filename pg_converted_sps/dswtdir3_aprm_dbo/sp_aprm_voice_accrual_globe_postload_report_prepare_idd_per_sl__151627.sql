CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_postload_report_prepare_idd_per_sl_()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache;

	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache
			   ("SAP VENDOR CODE"
			   ,"CURRENCY"
			   ,"DIRECTION"
			   ,"Sum of SETTABLE DURATION"
			   ,"Sum of NET SETTABLE AMT"
			   ,"Sum of Quantity (Settable duration)"
			   ,"Sum of Amount in USD"
			   ,"Difference Duration"
			   ,"Difference Amount")
	SELECT "SAP VENDOR CODE"
      ,"CURRENCY"
      ,"DIRECTION"
      ,"Sum of SETTABLE DURATION"
      ,"Sum of NET SETTABLE AMT"
      ,"Sum of Quantity (Settable duration)"
      ,"Sum of Amount in USD"
      ,"Difference Duration"
      ,"Difference Amount"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_idd_per_sl_sapvsoutput_usdrptsel;
END;
$procedure$
