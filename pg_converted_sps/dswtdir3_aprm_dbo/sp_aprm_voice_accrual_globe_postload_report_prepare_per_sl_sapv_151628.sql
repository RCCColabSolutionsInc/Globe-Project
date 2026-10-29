CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_postload_report_prepare_per_sl_sapv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_per_sl_sapvsoutput_php_cache;

	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_per_sl_sapvsoutput_php_cache
			   ("SAP VENDOR CODE"
			   ,"CURRENCY"
			   ,"DIRECTION"
			   ,"Sum of SETTABLE DURATION"
			   ,"Sum of NET SETTABLE AMT"
			   ,"Sum of Quantity (Settable duration)"
			   ,"Sum of Amount in PHP"
			   ,"Difference Duration"
			   ,"Difference Amount")
	SELECT "SAP VENDOR CODE"
      ,"CURRENCY"
      ,"DIRECTION"
      ,"Sum of SETTABLE DURATION"
      ,"Sum of NET SETTABLE AMT"
      ,"Sum of Quantity (Settable duration)"
      ,"Sum of Amount in PHP"
      ,"Difference Duration"
      ,"Difference Amount"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_per_sl_sapvsoutput_phprptsel;
END;
$procedure$
