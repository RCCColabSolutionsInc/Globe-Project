CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_ss()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT
	"EVENT"
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
	FROM
	(
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
			  ,0 as "Sort"
		  FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
		  WHERE COALESCE("EVENT",'') = ''
		  UNION ALL
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
			  ,1 as "Sort"
		  FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
		  WHERE (COALESCE("EVENT",'') <> '') AND ("EVENT" NOT LIKE '%Total%')
		  UNION ALL
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
			  ,2 as "Sort"
		  FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
		  WHERE ("EVENT" LIKE '%Total%')
	) XX
	ORDER BY "Sort",1,2,3;
END;
$procedure$
