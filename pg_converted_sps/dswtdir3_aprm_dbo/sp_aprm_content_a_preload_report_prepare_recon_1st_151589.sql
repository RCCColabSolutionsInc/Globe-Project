CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_recon_1st()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_a_preload_report_recon_report_1st_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_a_preload_report_recon_report_1st_cache
			   ("Column1"
			   ,"Column2"
			   ,"Column3"
			   ,"Column4"
			   ,"Column5"
			   ,"Column6"
			   ,"Column7"
			   ,"Column8"
			   ,"Column9"
			   ,"Column10"
			   ,"Column11"
			   ,"Column12"
			   ,"Column13"
			   ,"Column14"
			   ,"Column15"
			   ,"Column16"
			   ,"Column17"
			   ,"Column18"
			   ,"Column19"
			   ,"Column20")
	SELECT "Column1"
		  ,"Column2"
		  ,"Column3"
		  ,"Column4"
		  ,"Column5"
		  ,"Column6"
		  ,"Column7"
		  ,"Column8"
		  ,"Column9"
		  ,"Column10"
		  ,"Column11"
		  ,"Column12"
		  ,"Column13"
		  ,"Column14"
		  ,"Column15"
		  ,"Column16"
		  ,"Column17"
		  ,"Column18"
		  ,"Column19"
		  ,"Column20"
	  FROM dswtdir3_aprm_dbo.tvaprm_content_recon_report_1strunrptsel;
END;
$procedure$
