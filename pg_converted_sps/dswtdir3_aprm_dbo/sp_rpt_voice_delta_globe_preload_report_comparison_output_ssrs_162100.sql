CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_delta_globe_preload_report_comparison_output_ssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
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
  FROM dswtdir3_aprm_dbo.rpt_voice_delta_globe_preload_report_comparison_output_cache ORDER BY 1,2;
END;
$procedure$
