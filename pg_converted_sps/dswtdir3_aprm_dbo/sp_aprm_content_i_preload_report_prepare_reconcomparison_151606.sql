CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_reconcomparison()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_i_preload_report_reconcomparison_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_i_preload_report_reconcomparison_cache
			   ("PARTNER CODE"
			   ,"PARTNER NAME"
			   ,"SUM of HITS"
			   ,"Sum of Payout, net of VAT"
			   ,"Sum of VAT"
			   ,"Report Sum of HITS"
			   ,"Report Sum of Payout, net of VAT"
			   ,"Report Sum of VAT"
			   ,"AUR Sum of HITS"
			   ,"AUR Sum of Payout, net of VAT"
			   ,"AUR Sum of VAT"
			   ,"DSR Sum of HITS"
			   ,"DSR Sum of Payout, net of VAT"
			   ,"DSR Sum of VAT"
			   ,"SAP Extract vs SAP Report HITS"
			   ,"SAP Extract vs SAP Report Payout"
			   ,"SAP Extract vs SAP Report VAT"
			   ,"SAP Extract vs AUR HITS"
			   ,"SAP Extract vs AUR Payout"
			   ,"SAP Extract vs AUR VAT"
			   ,"SAP Report vs AUR HITS"
			   ,"SAP Report vs AUR Payout"
			   ,"SAP Report vs AUR VAT"
			   ,"SAP Extract vs DSR HITS"
			   ,"SAP Extract vs DSR Payout"
			   ,"SAP Extract vs DSR VAT"
			   ,"AUR vs DSR HITS"
			   ,"AUR vs DSR Payout"
			   ,"AUR vs DSR VAT")
	SELECT "PARTNER CODE"
		  ,"PARTNER NAME"
		  ,"SUM of HITS"
		  ,"Sum of Payout, net of VAT"
		  ,"Sum of VAT"
		  ,"Report Sum of HITS"
		  ,"Report Sum of Payout, net of VAT"
		  ,"Report Sum of VAT"
		  ,"AUR Sum of HITS"
		  ,"AUR Sum of Payout, net of VAT"
		  ,"AUR Sum of VAT"
		  ,"DSR Sum of HITS"
		  ,"DSR Sum of Payout, net of VAT"
		  ,"DSR Sum of VAT"
		  ,"SAP Extract vs SAP Report HITS"
		  ,"SAP Extract vs SAP Report Payout"
		  ,"SAP Extract vs SAP Report VAT"
		  ,"SAP Extract vs AUR HITS"
		  ,"SAP Extract vs AUR Payout"
		  ,"SAP Extract vs AUR VAT"
		  ,"SAP Report vs AUR HITS"
		  ,"SAP Report vs AUR Payout"
		  ,"SAP Report vs AUR VAT"
		  ,"SAP Extract vs DSR HITS"
		  ,"SAP Extract vs DSR Payout"
		  ,"SAP Extract vs DSR VAT"
		  ,"AUR vs DSR HITS"
		  ,"AUR vs DSR Payout"
		  ,"AUR vs DSR VAT"
	  FROM dswtdir3_aprm_dbo.tvaprm_content_reconcomparisonrptsel;
END;
$procedure$
