CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_bayan_postload_report_prepare_comparison2()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_postload_report_comparison2_cache;
	
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_postload_report_comparison2_cache
           ("DIRECTION"
           ,"SAP VENDOR CODE"
           ,"INTERCONNECT PARTNER CODE"
           ,"CM DURATION"
           ,"PM DURATION"
           ,"CM SETTABLE AMT"
           ,"PM SETTABLE AMT"
           ,"AUR Duration"
           ,"AUR SETTABLE AMT"
           ,"I/D Duration"
           ,"I/D SETTABLE AMT"
           ,"CM vs AUR Duration"
           ,"CM vs AUR SETTABLE AMT"
           ,"CM_RATE/MIN"
           ,"PM_RATE/MIN"
           ,"Output Sum of Quantity (Settable duration)"
           ,"Output Sum of Amount"
           ,"Difference Duration"
           ,"Difference Amount"
           ,"Currency")
	SELECT "DIRECTION"
      ,"SAP VENDOR CODE"
      ,"INTERCONNECT PARTNER CODE"
      ,"CM DURATION"
      ,"PM DURATION"
      ,"CM SETTABLE AMT"
      ,"PM SETTABLE AMT"
      ,"AUR Duration"
      ,"AUR SETTABLE AMT"
      ,"I/D Duration"
      ,"I/D SETTABLE AMT"
      ,"CM vs AUR Duration"
      ,"CM vs AUR SETTABLE AMT"
      ,"CM_RATE/MIN"
      ,"PM_RATE/MIN"
      ,"Output Sum of Quantity (Settable duration)"
      ,"Output Sum of Amount"
      ,"Difference Duration"
      ,"Difference Amount"
      ,"Currency"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_bayan_comparison2rptsel;
END;
$procedure$
