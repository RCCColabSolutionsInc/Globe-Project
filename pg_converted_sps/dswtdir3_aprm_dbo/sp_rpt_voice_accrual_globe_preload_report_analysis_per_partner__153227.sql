CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_analysis_per_partner_()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT "COLUMN1"
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
		  ,"COLUMN15"
	FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_detailed_cache;
END;
$procedure$
