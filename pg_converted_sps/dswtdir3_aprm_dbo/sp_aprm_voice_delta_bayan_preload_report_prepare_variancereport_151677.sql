CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_bayan_preload_report_prepare_variancereport()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE rpt_Voice_Delta_Bayan_Preload_Report_VarianceReportvsExtract2_Cache;
	INSERT INTO "dbo"."rpt_Voice_Delta_Bayan_Preload_Report_VarianceReportvsExtract2_Cache"
           ("DIRECTION"
           ,"SAP VENDOR CODE"
           ,"INTERCONNECT PARTNER CODE"
           ,"Report DURATION"
           ,"Report SETTABLE AMT"
           ,"Extract DURATION"
           ,"Extract SETTABLE AMT"
           ,"Difference Duration"
           ,"Difference SETTABLE AMT")
	SELECT "DIRECTION"
      ,"SAP VENDOR CODE"
      ,"INTERCONNECT PARTNER CODE"
      ,"Report DURATION"
      ,"Report SETTABLE AMT"
      ,"Extract DURATION"
      ,"Extract SETTABLE AMT"
      ,"Difference Duration"
      ,"Difference SETTABLE AMT"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_bayan_variancereportvsextract_delta2rptsel;
END;
$procedure$
