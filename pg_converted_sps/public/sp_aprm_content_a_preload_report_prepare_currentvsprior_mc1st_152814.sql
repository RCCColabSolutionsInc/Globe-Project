CREATE OR REPLACE PROCEDURE public.sp_aprm_content_a_preload_report_prepare_currentvsprior_mc1st()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_a_preload_report_currentvsprior_month_comparison_1st_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_a_preload_report_currentvsprior_month_comparison_1st_cache
			   ("PARTNER CODE"
			   ,"PARTNER NAME"
			   ,"CM HITS"
			   ,"CM PAYOUT"
			   ,"CM VAT"
			   ,"CM TOTAL PAYOUT"
			   ,"PM HITS"
			   ,"PM PAYOUT"
			   ,"PM VAT"
			   ,"PM TOTAL PAYOUT"
			   ,"I/D HITS"
			   ,"I/D PAYOUT"
			   ,"I/D VAT"
			   ,"I/D TOTAL PAYOUT/SF"
			   ,"I/D PAYOUT / PM PAYOUT"
			   ,"I/D TOTAL PAYOUT/SF / PM TOTAL PAYOUT")
	SELECT "PARTNER CODE"
		  ,"PARTNER NAME"
		  ,"CM HITS"
		  ,"CM PAYOUT"
		  ,"CM VAT"
		  ,"CM TOTAL PAYOUT"
		  ,"PM HITS"
		  ,"PM PAYOUT"
		  ,"PM VAT"
		  ,"PM TOTAL PAYOUT"
		  ,"I/D HITS"
		  ,"I/D PAYOUT"
		  ,"I/D VAT"
		  ,"I/D TOTAL PAYOUT/SF"
		  ,"I/D PAYOUT / PM PAYOUT"
		  ,"I/D TOTAL PAYOUT/SF / PM TOTAL PAYOUT"
	  FROM dswtdir3_aprm_dbo.tvaprm_content_currentvsprior_month_comparison_1strptsel;
END;
$procedure$
