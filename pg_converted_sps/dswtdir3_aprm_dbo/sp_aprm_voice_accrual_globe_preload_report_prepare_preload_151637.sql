CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_preload()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_preload_cache;

	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_preload_cache
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
           ,"Column20"
           ,"Column21"
           ,"Column22"
           ,"Column23")
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
		  ,"Column21"
		  ,"Column22"
		  ,"Column23"
	  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_accrual_preloadrptsel;
END;
$procedure$
