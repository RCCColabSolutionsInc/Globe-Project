CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_tending_1_sv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
			   ("EVENT"
			   ,"COLUMN1"
			   ,"COLUMN2"
			   ,"COLUMN3"
			   ,"COLUMN4"
			   ,"COLUMN5"
			   ,"COLUMN6"
			   ,"COLUMN7"
			   ,"COLUMN8"
			   ,"COLUMN9"
			   ,"COLUMN10"
			   ,"COLUMN11"
			   ,"COLUMN12"
			   ,"COLUMN13"
			   ,"COLUMN14")
	SELECT "EVENT"
      ,"COLUMN1"
      ,"COLUMN2"
      ,"COLUMN3"
      ,"COLUMN4"
      ,"COLUMN5"
      ,"COLUMN6"
      ,"COLUMN7"
      ,"COLUMN8"
      ,"COLUMN9"
      ,"COLUMN10"
      ,"COLUMN11"
      ,"COLUMN12"
      ,"COLUMN13"
      ,"COLUMN14"
  FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_trending_1_sapvsaur_rptsel;
END;
$procedure$
