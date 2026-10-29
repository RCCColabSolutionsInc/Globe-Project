CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_accural_vs_final()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_i_preload_report_accural_vs_final_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_i_preload_report_accural_vs_final_cache
			   ("Row Labels"
			   ,"BP END DATE"
			   ,"ORIGINAL BP END DATE"
			   ,"CHARGE DIRECTION"
			   ,"PARTNER CODE"
			   ,"PARTNER NAME"
			   ,"SERVICE PROVIDER"
			   ,"PRODUCT LINE INDICATOR"
			   ,"CUSTOMER SEGMENT"
			   ,"SUB SERVICE TYPE"
			   ,"CUSTOMER SUB TYPE"
			   ,"CONTENT TYPE"
			   ,"ACCESS CODE"
			   ,"CUR"
			   ,"Final HITS"
			   ,"Final Payout"
			   ,"Final VAT"
			   ,"Accrual HITS"
			   ,"Accrual Payout"
			   ,"Accrual VAT"
			   ,"Difference HITS"
			   ,"Difference Payout"
			   ,"Difference Vat")
	SELECT "Row Labels"
		  ,"BP END DATE"
		  ,"ORIGINAL BP END DATE"
		  ,"CHARGE DIRECTION"
		  ,"PARTNER CODE"
		  ,"PARTNER NAME"
		  ,"SERVICE PROVIDER"
		  ,"PRODUCT LINE INDICATOR"
		  ,"CUSTOMER SEGMENT"
		  ,"SUB SERVICE TYPE"
		  ,"CUSTOMER SUB TYPE"
		  ,"CONTENT TYPE"
		  ,"ACCESS CODE"
		  ,"CUR"
		  ,"Final HITS"
		  ,"Final Payout"
		  ,"Final VAT"
		  ,"Accrual HITS"
		  ,"Accrual Payout"
		  ,"Accrual VAT"
		  ,"Difference HITS"
		  ,"Difference Payout"
		  ,"Difference Vat"
	  FROM dswtdir3_aprm_dbo.tvaprm_content_accural_vs_finalrptsel;
END;
$procedure$
