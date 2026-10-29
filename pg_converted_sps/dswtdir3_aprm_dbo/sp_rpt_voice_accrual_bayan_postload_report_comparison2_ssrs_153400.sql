CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_accrual_bayan_postload_report_comparison2_ssrs()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
SELECT
		"DIRECTION"
		,"SAP VENDOR CODE"
		,"INTERCONNECT PARTNER CODE"
		,"CM DURATION"
		,"PM DURATION"
		,"CM SETTABLE AMT"
		,"PM SETTABLE AMT"
		,"AUR Duration"
		,"AUR SETTABLE AMT"
		,"I/D Duration"
		,"I/D SETTABLE AMT"
		,"CM vs AUR Duration"
		,"CM vs AUR SETTABLE AMT"
		,"CM_RATE/MIN"
		,"PM_RATE/MIN"
		,"Output Sum of Quantity (Settable duration)"
		,"Output Sum of Amount"
		,"Difference Duration"
		,"Difference Amount"
		,"Currency"
	FROM
	(
		SELECT 1 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_postload_report_comparison2_cache AS x WHERE x.DIRECTION <> 'Total'
		UNION ALL
		SELECT 2 as "SortOrder",* FROM dswtdir3_aprm_dbo.rpt_voice_accrual_bayan_postload_report_comparison2_cache AS x WHERE x.DIRECTION = 'Total'
	) as xx ORDER BY "SortOrder","DIRECTION","SAP VENDOR CODE";
END;
$procedure$
