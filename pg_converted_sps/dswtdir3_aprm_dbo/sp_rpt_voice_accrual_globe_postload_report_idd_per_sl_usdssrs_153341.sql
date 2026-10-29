CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_globe_postload_report_idd_per_sl_usdssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT "SAP VENDOR CODE"
		  ,"CURRENCY"
		  ,"DIRECTION"
		  ,"Sum of SETTABLE DURATION"
		  ,"Sum of NET SETTABLE AMT"
		  ,"Sum of Quantity (Settable duration)"
		  ,"Sum of Amount in USD"
		  ,"Difference Duration"
		  ,"Difference Amount"
	FROM
	(
		SELECT 1 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache AS x WHERE x."SAP VENDOR CODE" <> 'TOTAL'
		UNION ALL
		SELECT 2 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_postload_report_idd_per_sl_sapvsoutput_usd_cache AS x WHERE x."SAP VENDOR CODE" = 'TOTAL'
	) as xx ORDER BY "SortOrder","DIRECTION","SAP VENDOR CODE";
END;
$procedure$
