CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_amdocsvsbill()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache;

	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache
           ("Home Partner"
           ,"Partner Code"
           ,"Charge direction"
           ,"Amdocs Total Duration"
           ,"Billing Total Duration"
           ,"Amdocs Total Net Charge"
           ,"Billing Total Net Charge"
           ,"A v B Difference Duration"
           ,"A v B Difference Net Charge")
	SELECT "Home Partner"
      ,"Partner Code"
      ,"Charge direction"
      ,"Amdocs Total Duration"
      ,"Billing Total Duration"
      ,"Amdocs Total Net Charge"
      ,"Billing Total Net Charge"
      ,"A v B Difference Duration"
      ,"A v B Difference Net Charge"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_amdocsvsbillingrptsel;
END;
$procedure$
