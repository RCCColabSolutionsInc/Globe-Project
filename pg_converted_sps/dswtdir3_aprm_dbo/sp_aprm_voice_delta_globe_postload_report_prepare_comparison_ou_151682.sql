CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_globe_postload_report_prepare_comparison_ou()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_delta_globe_postload_report_comparison_output_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_delta_globe_postload_report_comparison_output_cache
           ("DIRECTION"
           ,"SAP VENDOR CODE"
           ,"INTERCONNECT PARTNER CODE"
           ,"CURRENCY"
           ,"Final DURATION"
           ,"Final SETTABLE AMT"
           ,"Accrual DURATION"
           ,"Accrual SETTABLE AMT"
           ,"Delta DURATION"
           ,"Delta SETTABLE AMT"
           ,"Difference FvA Duration"
           ,"Difference FvA SETTABLE AMT"
           ,"Difference F-AvD Duration"
           ,"Difference F-AvD SETTABLE AMT"
           ,"Output Duration"
           ,"Output Amount in PHP"
           ,"Output Amount in USD"
           ,"Difference in Duration"
           ,"Difference in SETTABLE AMT")
	SELECT "DIRECTION"
		  ,"SAP VENDOR CODE"
		  ,"INTERCONNECT PARTNER CODE"
		  ,"CURRENCY"
		  ,"Final DURATION"
		  ,"Final SETTABLE AMT"
		  ,"Accrual DURATION"
		  ,"Accrual SETTABLE AMT"
		  ,"Delta DURATION"
		  ,"Delta SETTABLE AMT"
		  ,"Difference FvA Duration"
		  ,"Difference FvA SETTABLE AMT"
		  ,"Difference F-AvD Duration"
		  ,"Difference F-AvD SETTABLE AMT"
		  ,"Output Duration"
		  ,"Output Amount in PHP"
		  ,"Output Amount in USD"
		  ,"Difference in Duration"
		  ,"Difference in SETTABLE AMT"
	  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_delta_comparison_output_rptsel;
END;
$procedure$
