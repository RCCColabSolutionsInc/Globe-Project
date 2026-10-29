CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_preload_report_analysis_sapvsaur_ssr()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT "CHARGE DIRECTION"
      ,"TYPE"
      ,"INTERCONNECT PARTNER NAME"
      ,"CURRENCY"
      ,"SAP_Sum of SETTABLE DURATION"
      ,"SAP_Sum of NET SETTABLE AMT"
      ,"AUR DURATION"
      ,"AUR NET CHARGE"
      ,"DIFF SAPvsAUR DURATION"
      ,"DIFF SAPvsAUR AMT"
	FROM
	(
	SELECT 1 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache AS x WHERE x."CHARGE DIRECTION" NOT IN('* TOTAL *','* PRELOAD *')
	UNION ALL
	SELECT 2 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache AS x WHERE x."CHARGE DIRECTION" = '* TOTAL *'
	UNION ALL
	SELECT 3 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache AS x WHERE x."CHARGE DIRECTION" = '* PRELOAD *'

	) as xx ORDER BY "SortOrder","CHARGE DIRECTION","TYPE";
END;
$procedure$
