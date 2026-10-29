CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_postload_report_prepare_postload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_content_i_postload_report_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_content_i_postload_report_cache
			   ("SORT"
			   ,"Column1"
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
			   ,"TOTAL"
			   ,"Category")
	SELECT "SORT"
		  ,"Column1"
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
		  ,"TOTAL"
		  ,"Category"
	  FROM dswtdir3_aprm_dbo.tvaprm_content_postloadrptsel;
END;
$procedure$
