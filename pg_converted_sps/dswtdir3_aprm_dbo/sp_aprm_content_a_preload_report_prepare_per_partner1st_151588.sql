CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_per_partner1st()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_a_preload_report_per_partner1st_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_a_preload_report_per_partner1st_cache
			   ("PARTNER CODE"
			   ,"PARTNER NAME"
			   ,"I/D PAYOUT")
	SELECT "PARTNER CODE"
		  ,"PARTNER NAME"
		  ,"I/D PAYOUT"
	 FROM dswtdir3_aprm_dbo.tvaprm_content_per_partner1strptsel;
END;
$procedure$
