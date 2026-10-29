CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_amvsbi_ssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT
		"Home Partner"
		,"Partner Code"
		,"Charge direction"
		,"Amdocs Total Duration"
		,"Billing Total Duration"
		,"Amdocs Total Net Charge"
		,"Billing Total Net Charge"
		,"A v B Difference Duration"
		,"A v B Difference Net Charge"
	FROM
		(
		SELECT "Home Partner"
			  ,"Partner Code"
			  ,"Charge direction"
			  ,"Amdocs Total Duration"
			  ,"Billing Total Duration"
			  ,"Amdocs Total Net Charge"
			  ,"Billing Total Net Charge"
			  ,"A v B Difference Duration"
			  ,"A v B Difference Net Charge"
			  , 0 as "Sort"
		  FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache
		  WHERE "Home Partner" <> 'Total'
		  UNION ALL
			SELECT "Home Partner"
				,"Partner Code"
				,"Charge direction"
				,"Amdocs Total Duration"
				,"Billing Total Duration"
				,"Amdocs Total Net Charge"
				,"Billing Total Net Charge"
				,"A v B Difference Duration"
				,"A v B Difference Net Charge",
				1 as "Sort"
			FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache
			WHERE "Home Partner" = 'Total'
			) as XX
	ORDER BY "Sort","Charge direction","Home Partner","Partner Code";
END;
$procedure$
