CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_bayan_preload_report_prepare_negativeamount()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE rpt_Voice_Delta_Bayan_Preload_Report_NegativeAmount_Preload_Cache;
	INSERT INTO "dbo"."rpt_Voice_Delta_Bayan_Preload_Report_NegativeAmount_Preload_Cache"
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
	  FROM dswtdir3_aprm_dbo.tvaprm_voice_bayan_delta_negativeamount_preloadrptsel;
END;
$procedure$
