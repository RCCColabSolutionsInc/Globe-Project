CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_analysis_ssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT
	"COLUMN1"
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
	FROM
	(
		SELECT *,0 as "Sort"
		FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
		WHERE (Column11 = 'Mins')
		UNION ALL
		SELECT *,1 as "Sort"
		FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
		WHERE (Column5 = 'Sum of SETTABLE DURATION')
		UNION ALL
		SELECT *,2 as "Sort"
		FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
		WHERE (COALESCE("COLUMN1",'') <> '' AND "COLUMN1" NOT LIKE '%Total%')
		UNION ALL
		SELECT *,3 as "Sort"
		FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
		WHERE ("COLUMN1" LIKE '%Total%')
	) XX
	ORDER BY "Sort",1,2,4,3;
END;
$procedure$
