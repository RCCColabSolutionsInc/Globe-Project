CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_delta_globe_preload_report_positiveamount_preload_()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
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
  FROM dswtdir3_aprm_dbo.rpt_voice_delta_globe_preload_report_positiveamount_preload_cache;
END;
$procedure$
