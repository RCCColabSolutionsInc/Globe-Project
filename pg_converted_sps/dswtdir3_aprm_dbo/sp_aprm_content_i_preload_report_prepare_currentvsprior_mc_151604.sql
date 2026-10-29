CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_currentvsprior_mc()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_i_preload_report_currentvsprior_month_comparison_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_i_preload_report_currentvsprior_month_comparison_cache
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
	  FROM dswtdir3_aprm_dbo.tvaprm_content_currentvsprior_month_comparisonrptsel;
END;
$procedure$
