CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_globe_preload_report_prepare_variancereport()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_delta_globe_preload_report_variancereportvsextract_delta2_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_delta_globe_preload_report_variancereportvsextract_delta2_cache
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
  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_variancereportvsextract_delta2rptsel;
END;
$procedure$
