CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.new_tapcodes_report_insql()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Tapcode VARCHAR(5);
    var_createQuery0 TEXT;
    var_createQuery1 TEXT;
    var_createQuery2 TEXT;
    var_createQuery3 TEXT;
    var_createQuery4 TEXT;
    var_createQuery5 TEXT;
    var_createQuery6 TEXT;
    var_createQuery7 TEXT;
    var_createQuery8 TEXT;
    var_createQuery9 TEXT;
    var_createQuery10 TEXT;
BEGIN
    WHILE EXISTS (SELECT
        tapcode
        FROM sdbtdip2_iot_da_dbo.tapcodesnew) LOOP
        SELECT
            tapcode
            INTO var_Tapcode
            FROM sdbtdip2_iot_da_dbo.tapcodesnew
            ORDER BY tapcode ASC NULLS FIRST
            LIMIT 1;
        var_createQuery0 := 'ALTER VIEW [dbo].[tvIOT_DA_' || var_Tapcode || '_RptSel]
							AS
							SELECT        Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, Column10, Column11, NULL 
                         AS Column12, Column13, Column14, Column15, Column16, Column17, Column18, Column19, Column20, Column21, Column22, NULL 
                         AS Column23, Column24, Column25, Column26, Column27, Column28, Column29, Column30, Column31, Column32, Column33, NULL 
                         AS Column34, Column35, Column36, Column37, Column38, Column39, Column40, Column41, Column42, Column43, Column44, NULL 
                         AS Column45, Column46, Column47, Column48, Column49, Column50, Column51, Column52, Column53, Column54, Column55, NULL 
                         AS Column56, Column57, Column58, Column59, Column60, Column61, Column62, Column63, Column64, Column65, Column66, NULL 
                         AS Column67, Column68, Column69, Column70, Column71, Column72, Column73
						 FROM (
						 ';
        var_createQuery1 := '
						SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''SUMMARY'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, ''Partner TADIG Code'' AS Column1, ''Start of PRA'' AS Column2, ''End of PRA'' AS Column3, ''Service Covered'' AS Column4, ''Discount Scheme'' AS Column5, NULL AS Column6, NULL AS Column7, NULL 
                         AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL 
                         AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL 
                         AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL 
                         AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL 
                         AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL 
                         AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, [Partner TADIG Code], [Start of PRA], [End of PRA], [Service Covered], [Discount Scheme], NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM            SUMMARY_IB_OB_Summary_Header WHERE Account_Group =  ''' || var_Tapcode || '''';
        var_createQuery2 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, ''DIRECTION'' AS Expr1, ''Partner_Company'' AS Expr2, ''SERVICE'' AS Expr3, ''USD AMOUNT'' AS Expr4, 
                         ''Remarks'' AS Expr5, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL 
                         AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL 
                         AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT       NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, DIRECTION, Partner_Company, SERVICE, [USD AMOUNT], Remarks, NULL AS Column12, NULL 
                         AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL 
                         AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL 
                         AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column45, NULL 
                         AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL 
                         AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL 
                         AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM (
SELECT    TOP 10000    NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, DIRECTION, Partner_Company, SERVICE, [USD AMOUNT], Remarks, NULL AS Column12, NULL 
                         AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL 
                         AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL 
                         AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column45, NULL 
                         AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL 
                         AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL 
                         AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM       
	(SELECT        Partner_Company AS SortPartner,SortValDirection,''1'' AS AddSpace,NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, DIRECTION, Partner_Company, SERVICE, [USD AMOUNT], Remarks, NULL AS Column12, NULL 
                         AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL 
                         AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL 
                         AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column45, NULL 
                         AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL 
                         AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL 
                         AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
	FROM            SUMMARY_IB_OB_USD  WHERE Account_Group = ''' || var_Tapcode || '''
	UNION ALL
	SELECT        Partner_Company AS SortPartner,SortValDirection,''2'' AS AddSpace,NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS DIRECTION, NULL AS Partner_Company, NULL AS SERVICE, NULL AS [USD AMOUNT], NULL AS Remarks, NULL AS Column12, NULL 
                         AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL 
                         AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL 
                         AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column45, NULL 
                         AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL 
                         AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL 
                         AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
	FROM            SUMMARY_IB_OB_USD  WHERE Account_Group = ''' || var_Tapcode || ''' GROUP BY Partner_Company,SortValDirection
	) A ORDER BY SortPartner,SortValDirection,AddSpace
	) B';
        var_createQuery3 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''MONTHLY SDR'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column1, Column2 AS Expr1, Column3 AS Expr2, Column4 AS Expr3, Column5 AS Expr4, Column6 AS Expr5, Column7 AS Expr6, Column8 AS Expr7, Column9 AS Expr8, NULL AS Column10, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM            IB_OB_USD_SDR_UPSIDE_DOWNSIDE_HEADER
UNION ALL
SELECT      NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, 
                          Disc, Partner_Company, ACTUAL_AMOUNT_USD, ACCRUAL_AMOUNT_USD, [Upside/(Downside) USD], ACTUAL_AMOUNT_SDR, ACCRUAL_AMOUNT_SDR, [Upside/(Downside) SDR], [Upside/(Downside) PHP], NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL 
                         AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL 
                         AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM    (
	SELECT   TOP 10000     NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, 
                          Disc, Partner_Company, ACTUAL_AMOUNT_USD, ACCRUAL_AMOUNT_USD, [Upside/(Downside) USD], ACTUAL_AMOUNT_SDR, ACCRUAL_AMOUNT_SDR, [Upside/(Downside) SDR], [Upside/(Downside) PHP], NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL 
                         AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL 
                         AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
	FROM     

		(
		SELECT        Partner_Company AS SortPartner,''1'' AS AddSpace,NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, 
                         Column1 AS Disc, Partner_Company, ACTUAL_AMOUNT_USD, ACCRUAL_AMOUNT_USD, [Upside/(Downside) USD], ACTUAL_AMOUNT_SDR, ACCRUAL_AMOUNT_SDR, [Upside/(Downside) SDR], [Upside/(Downside) PHP], NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL 
                         AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL 
                         AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
		FROM            IB_OB_USD_SDR_UPSIDE_DOWNSIDE  WHERE Account_Group = ''' || var_Tapcode || '''
		UNION ALL
		SELECT        Partner_Company AS SortPartner,''2'' AS AddSpace,NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, 
                         NULL AS Disc,NULL AS Partner_Company,NULL AS ACTUAL_AMOUNT_USD,NULL AS ACCRUAL_AMOUNT_USD,NULL AS [Upside/(Downside) USD],NULL AS ACTUAL_AMOUNT_SDR,NULL AS ACCRUAL_AMOUNT_SDR,NULL AS [Upside/(Downside) SDR],NULL AS [Upside/(Downside) PHP], NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL 
                         AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL 
                         AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
		FROM            IB_OB_USD_SDR_UPSIDE_DOWNSIDE WHERE Account_Group = ''' || var_Tapcode || '''  GROUP BY Partner_Company
		) A ORDER BY SortPartner,AddSpace
		) B';
        var_createQuery4 := '
UNION ALL
SELECT        NULL AS Expr1, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL
                          AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL
                          AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL
                          AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL
                          AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL
                          AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL
                          AS Column72,NULL AS Column73 
FROM            MONTHLY_SDR_IB_OB_HEADER
UNION ALL
SELECT         NULL AS Expr1, DIRECTION, Partner_Company, Period, [SDR to USD], [Voice USD], [SMS USD], [GPRS USD], [Voice SDR], [SMS SDR], [GPRS SDR], NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL 
                         AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL 
                         AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL 
                         AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL 
                         AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL 
                         AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL 
                         AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM 
	(SELECT     TOP 10000    NULL AS Expr1, DIRECTION, Partner_Company, Period, [SDR to USD], [Voice USD], [SMS USD], [GPRS USD], [Voice SDR], [SMS SDR], [GPRS SDR], NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL 
                         AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL 
                         AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL 
                         AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL 
                         AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL 
                         AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL 
                         AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
	FROM            
	(
		SELECT        Partner_Company AS SortPart,DIRECTION AS SortDir,''1'' AS AddSpace,NULL AS Expr1, DIRECTION, Partner_Company, Period, [SDR to USD], [Voice USD], [SMS USD], [GPRS USD], [Voice SDR], [SMS SDR], [GPRS SDR], NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL 
                         AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL 
                         AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL 
                         AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL 
                         AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL 
                         AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL 
                         AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
		FROM            MONTHLY_SDR_IB_OB WHERE Account_Group = ''' || var_Tapcode || '''
		UNION ALL
		SELECT					 Partner_Company AS SortPart,DIRECTION AS SortDir,''2'' AS AddSpace,NULL AS Expr1,NULL AS  DIRECTION, NULL AS Partner_Company, NULL AS Period, NULL AS [SDR to USD], NULL AS [Voice USD], NULL AS [SMS USD], NULL AS [GPRS USD], NULL AS [Voice SDR], NULL AS [SMS SDR], NULL AS [GPRS SDR], 
							NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL 
                         AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL 
                         AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL 
                         AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL 
                         AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL 
                         AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL 
                         AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
		FROM            MONTHLY_SDR_IB_OB WHERE Account_Group = ''' || var_Tapcode || ''' GROUP BY 
		Partner_Company ,DIRECTION

		) A ORDER BY SortDir,SortPart,AddSpace
	) B';
        var_createQuery5 := '
UNION ALL
SELECT        ''AVERAGE CERA'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73

UNION ALL
SELECT        NULL AS Column1, MONTHS AS Column2, CAST(PHP AS VARCHAR) AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM
	Average_Cera  WHERE Account_Group = ''' || var_Tapcode || '''';
        var_createQuery6 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''SUMMARY OUTTAP'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, ''Partner_Company'' AS Expr2, ''Period'' AS Expr3, ''DIRECTION'' AS Expr4, ''Description'' AS Expr5, ''Voice'' AS Expr6, ''SMS'' AS Expr7, ''GPRS'' AS Expr8, ''TOTAL'' AS Expr9, NULL AS Column9, NULL 
                         AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL 
                         AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL 
                         AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL 
                         AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, Partner_Company, Period, DIRECTION, Description, Voice, SMS, GPRS, TOTAL, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL 
                         AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL 
                         AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL 
                         AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL 
                         AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL 
                         AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL 
                         AS Column71, NULL AS Column72, NULL AS Column73
FROM (     
	SELECT   TOP 100000     NULL AS Expr1, Partner_Company, Period, DIRECTION, Description, Voice, SMS, GPRS, TOTAL, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL 
	                         AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL 
	                         AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL 
	                         AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL 
	                         AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL 
	                         AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL 
	                         AS Column71, NULL AS Column72, NULL AS Column73
	FROM            
		(
		SELECT         Partner_Company AS SortPart,''1'' AS AddSpace,NULL AS Expr1, Partner_Company, Period, DIRECTION, Description, Voice, SMS, GPRS, TOTAL, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL 
                         AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL 
                         AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL 
                         AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL 
                         AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL 
                         AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL 
                         AS Column71, NULL AS Column72, NULL AS Column73
		FROM            Summary_OutTap_CN_Table  WHERE Account_Group = ''' || var_Tapcode || '''
		UNION ALL
		SELECT        Partner_Company AS SortPart,''2'' AS AddSpace,NULL AS Expr1, NULL AS Partner_Company, NULL AS Period, NULL AS DIRECTION, NULL AS Description, NULL AS Voice, NULL AS SMS, NULL AS GPRS, NULL AS TOTAL, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL 
                         AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL 
                         AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL 
                         AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL 
                         AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL 
                         AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL 
                         AS Column71, NULL AS Column72, NULL AS Column73
		FROM            Summary_OutTap_CN_Table WHERE Account_Group = ''' || var_Tapcode || ''' GROUP BY Partner_Company
		) A ORDER BY SortPart,AddSpace
	) B';
        var_createQuery7 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''OUTTAP LOAD FILE'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, ''Counter'' AS Column1, ''Doc_Date'' AS Column2, ''Pstg date'' AS Column3, ''Type'' AS Column4, ''CoCd'' AS Column5, ''CURR'' AS Column6, ''TranslDate'' AS Column7, ''Exchange_Rate'' AS Column8, 
                         ''Ledger_Group'' AS Column9, ''Period'' AS Column10, ''Reference'' AS Column11, ''Document_header_text'' AS Column12, ''PK'' AS Column13, ''GL_acct'' AS Column14, ''SpecialGL'' AS Column15, ''Amount_in_doc_curr'' AS Column16, 
                         ''Amount_in_local_curr'' AS Column17, ''Amount_in_local_cur_2'' AS Column18, ''Ref_key_1'' AS Column19, ''Ref_key_2'' AS Column20, ''Ref_key_3'' AS Column21, ''Bline_date'' AS Column22, ''Purch_doc'' AS Column23, 
                         ''PurchasingLineItem'' AS Column24, ''WBS_Element'' AS Column25, ''Material'' AS Column26, ''Plnt'' AS Column27, ''Value_date'' AS Column28, ''PayT'' AS Column29, ''Order'' AS Column30, ''Cost_ctr'' AS Column31, 
                         ''Profit_ctr'' AS Column32, ''Partner_Profit_Center'' AS Column33, ''Tr_prt'' AS Column34, ''Assignment'' AS Column35, ''Text'' AS Column36, ''Quantity'' AS Column37, ''UoM'' AS Column38, ''Brand'' AS Column39, 
                         ''SubProduct_A'' AS Column40, ''SubProduct_B'' AS Column41, ''Franchise_Area'' AS Column42, ''Business_Center'' AS Column43, ''Revenue_Type'' AS Column44, ''Event'' AS Column45, ''Vat_Tax_Code'' AS Column46, 
                         ''MVNO Partner'' AS Column47, ''Technology'' AS Column48, ''Charge Code'' AS Column49, ''Plan Type'' AS Column50, ''Name'' AS Column51, ''Street'' AS Column52, ''Country'' AS Column53, ''Postal Code'' AS Column54, 
                         ''City'' AS Column55, ''Bank Key'' AS Column56, ''Bank Account'' AS Column57, ''Tax Number'' AS Column58, ''General Ledger Account'' AS Column59, ''Message'' AS Column60, ''Main Asset Number'' AS Column61, 
                         ''Base Tax Amount'' AS Column62, ''Withholding Tax Type'' AS Column63, ''Withholding Tax Code'' AS Column64, ''Payment Method'' AS Column65, ''New Company Code'' AS Column66, ''Local file for upload/download'' AS Column67, 
                         ''Error Flag'' AS Column68, ''core product'' AS Column69, ''Product lines'' AS Column70, ''DSP_Order'' AS Column71, ''DSP_UniqueKey'' AS Column72
UNION ALL
SELECT    TOP 10000    NULL AS Expr1, CAST(DENSE_RANK() OVER (ORDER BY Text) AS VARCHAR) AS Counter, Doc_Date, [Pstg date], Type, CoCd, CURR, TranslDate, Exchange_Rate, Ledger_Group, Period, Reference, Document_header_text, PK, GL_acct, SpecialGL, Amount_in_doc_curr, Amount_in_local_curr, 
                         Amount_in_local_cur_2, Ref_key_1, Ref_key_2, Ref_key_3, Bline_date, Purch_doc, PurchasingLineItem, WBS_Element, Material, Plnt, Value_date, PayT, [Order], Cost_ctr, Profit_ctr, Partner_Profit_Center, Tr_prt, Assignment, 
                         Text, Quantity, UoM, Brand, SubProduct_A, SubProduct_B, Franchise_Area, Business_Center, Revenue_Type, Event, Vat_Tax_Code, [MVNO Partner], Technology, [Charge Code], [Plan Type], Name, Street, Country, [Postal Code],
                          City, [Bank Key], [Bank Account], [Tax Number], [General Ledger Account], Message, [Main Asset Number], [Base Tax Amount], [Withholding Tax Type], [Withholding Tax Code], [Payment Method], [New Company Code], 
                         [Local file for upload/download], [Error Flag], [core product], [Product lines], DSP_Order, DSP_UniqueKey
FROM            Summary_OUTTAP_Loadfile_Table WHERE Account_Group = ''' || var_Tapcode || ''' 
ORDER BY Text,Sno';
        var_createQuery8 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''SUMMARY INTAP'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Column61, Column0, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, Column10, Column11, Column12, Column13, Column14, Column15, Column16, Column17, Column18, Column19, Column20, 
                         Column21, Column22, Column23, Column24, Column25, Column26, Column27, Column28, Column29, Column30, Column31, Column32, Column33, Column34, Column35, Column36, Column37, Column38, Column39, Column40, 
                         Column41, Column42, Column43, Column44, Column45, Column46, Column47, Column48, Column49, Column50, Column51, Column52, Column53, Column54, Column55, Column56, Column57, Column58, Column59, 
                         Column60, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72
FROM            SumIntapCN_Header';
        var_createQuery9 := '
UNION ALL
SELECT        NULL AS Column1, Partner_Company, Period, DIRECTION, Description, RM_VOICE_O, RM_SMS_OUT, RM_GPRS, TOTAL, PT_CM_RM_VOICE_O, PT_CM_RM_SMS_OUT, PT_CM_RM_GPRS, PT_CM_TOTAL, 
                         PT_EG_RM_VOICE_O, PT_EG_RM_SMS_OUT, PT_EG_RM_GPRS, PT_EG_TOTAL, PT_SG_RM_VOICE_O, PT_SG_RM_SMS_OUT, PT_SG_RM_GPRS, PT_SG_TOTAL, PT_RM_VOICE, PT_RM_SMS_OUT, PT_RM_GPRS, 
                         PT_RM_TOTAL, GP_CM_RM_VOICE_O, GP_CM_RM_SMS_OUT, GP_CM_RM_GPRS, GP_CM_TOTAL, GP_EG_RM_VOICE_O, GP_EG_RM_SMS_OUT, GP_EG_RM_GPRS, GP_EG_TOTAL, GP_SG_RM_VOICE_O, 
                         GP_SG_RM_SMS_OUT, GP_SG_RM_GPRS, GP_SG_TOTAL, [GP_IBG-CONS_RM_VOICE_O], [GP_IBG-CONS_RM_SMS_OUT], [GP_IBG-CONS_RM_GPRS], [GP_IBG-CONS_TOTAL], GP_RM_VOICE, GP_RM_SMS_OUT, 
                         GP_RM_GPRS, GP_RM_TOTAL, TM_CM_RM_VOICE_O, TM_CM_RM_SMS_OUT, TM_CM_RM_GPRS, TM_CM_TOTAL, TM_EG_RM_VOICE_O, TM_EG_RM_SMS_OUT, TM_EG_RM_GPRS, TM_EG_TOTAL, TM_SG_RM_VOICE_O, 
                         TM_SG_RM_SMS_OUT, TM_SG_RM_GPRS, TM_SG_TOTAL, TM_RM_VOICE_O, TM_RM_SMS_OUT, TM_RM_GPRS, TM_RM_TOTAL, TOTAL_ADJUSTMENT, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
FROM            (
	SELECT   TOP 10000   NULL AS Column1, Partner_Company, Period, DIRECTION, Description, RM_VOICE_O, RM_SMS_OUT, RM_GPRS, TOTAL, PT_CM_RM_VOICE_O, PT_CM_RM_SMS_OUT, PT_CM_RM_GPRS, PT_CM_TOTAL, 
                         PT_EG_RM_VOICE_O, PT_EG_RM_SMS_OUT, PT_EG_RM_GPRS, PT_EG_TOTAL, PT_SG_RM_VOICE_O, PT_SG_RM_SMS_OUT, PT_SG_RM_GPRS, PT_SG_TOTAL, PT_RM_VOICE, PT_RM_SMS_OUT, PT_RM_GPRS, 
                         PT_RM_TOTAL, GP_CM_RM_VOICE_O, GP_CM_RM_SMS_OUT, GP_CM_RM_GPRS, GP_CM_TOTAL, GP_EG_RM_VOICE_O, GP_EG_RM_SMS_OUT, GP_EG_RM_GPRS, GP_EG_TOTAL, GP_SG_RM_VOICE_O, 
                         GP_SG_RM_SMS_OUT, GP_SG_RM_GPRS, GP_SG_TOTAL, [GP_IBG-CONS_RM_VOICE_O], [GP_IBG-CONS_RM_SMS_OUT], [GP_IBG-CONS_RM_GPRS], [GP_IBG-CONS_TOTAL], GP_RM_VOICE, GP_RM_SMS_OUT, 
                         GP_RM_GPRS, GP_RM_TOTAL, TM_CM_RM_VOICE_O, TM_CM_RM_SMS_OUT, TM_CM_RM_GPRS, TM_CM_TOTAL, TM_EG_RM_VOICE_O, TM_EG_RM_SMS_OUT, TM_EG_RM_GPRS, TM_EG_TOTAL, TM_SG_RM_VOICE_O, 
                         TM_SG_RM_SMS_OUT, TM_SG_RM_GPRS, TM_SG_TOTAL, TM_RM_VOICE_O, TM_RM_SMS_OUT, TM_RM_GPRS, TM_RM_TOTAL, TOTAL_ADJUSTMENT
	FROM            (
		SELECT        Partner_Company AS SortPart, ''1'' AS AddSpace, NULL AS Col1, Partner_Company, Period, DIRECTION, Description, RM_VOICE_O, RM_SMS_OUT, RM_GPRS, TOTAL, PT_CM_RM_VOICE_O, PT_CM_RM_SMS_OUT, 
                         PT_CM_RM_GPRS, PT_CM_TOTAL, PT_EG_RM_VOICE_O, PT_EG_RM_SMS_OUT, PT_EG_RM_GPRS, PT_EG_TOTAL, PT_SG_RM_VOICE_O, PT_SG_RM_SMS_OUT, PT_SG_RM_GPRS, PT_SG_TOTAL, PT_RM_VOICE, 
                         PT_RM_SMS_OUT, PT_RM_GPRS, PT_RM_TOTAL, GP_CM_RM_VOICE_O, GP_CM_RM_SMS_OUT, GP_CM_RM_GPRS, GP_CM_TOTAL, GP_EG_RM_VOICE_O, GP_EG_RM_SMS_OUT, GP_EG_RM_GPRS, GP_EG_TOTAL, 
                         GP_SG_RM_VOICE_O, GP_SG_RM_SMS_OUT, GP_SG_RM_GPRS, GP_SG_TOTAL, [GP_IBG-CONS_RM_VOICE_O], [GP_IBG-CONS_RM_SMS_OUT], [GP_IBG-CONS_RM_GPRS], [GP_IBG-CONS_TOTAL], GP_RM_VOICE, 
                         GP_RM_SMS_OUT, GP_RM_GPRS, GP_RM_TOTAL, TM_CM_RM_VOICE_O, TM_CM_RM_SMS_OUT, TM_CM_RM_GPRS, TM_CM_TOTAL, TM_EG_RM_VOICE_O, TM_EG_RM_SMS_OUT, TM_EG_RM_GPRS, TM_EG_TOTAL, 
                         TM_SG_RM_VOICE_O, TM_SG_RM_SMS_OUT, TM_SG_RM_GPRS, TM_SG_TOTAL, TM_RM_VOICE_O, TM_RM_SMS_OUT, TM_RM_GPRS, TM_RM_TOTAL, TOTAL_ADJUSTMENT
		FROM            SumIntapCN_Table
		WHERE        (Account_Group = ''' || var_Tapcode || ''')
		UNION ALL
		SELECT        Partner_Company AS SortPart, ''2'' AS AddSpace, NULL AS Col1, NULL AS Partner_Company, NULL AS Period, NULL AS DIRECTION, NULL AS Description, NULL AS RM_VOICE_O, NULL AS RM_SMS_OUT, NULL 
                         AS RM_GPRS, NULL AS TOTAL, NULL AS PT_CM_RM_VOICE_O, NULL AS PT_CM_RM_SMS_OUT, NULL AS PT_CM_RM_GPRS, NULL AS PT_CM_TOTAL, NULL AS PT_EG_RM_VOICE_O, NULL AS PT_EG_RM_SMS_OUT, NULL 
                         AS PT_EG_RM_GPRS, NULL AS PT_EG_TOTAL, NULL AS PT_SG_RM_VOICE_O, NULL AS PT_SG_RM_SMS_OUT, NULL AS PT_SG_RM_GPRS, NULL AS PT_SG_TOTAL, NULL AS PT_RM_VOICE, NULL 
                         AS PT_RM_SMS_OUT, NULL AS PT_RM_GPRS, NULL AS PT_RM_TOTAL, NULL AS GP_CM_RM_VOICE_O, NULL AS GP_CM_RM_SMS_OUT, NULL AS GP_CM_RM_GPRS, NULL AS GP_CM_TOTAL, NULL 
                         AS GP_EG_RM_VOICE_O, NULL AS GP_EG_RM_SMS_OUT, NULL AS GP_EG_RM_GPRS, NULL AS GP_EG_TOTAL, NULL AS GP_SG_RM_VOICE_O, NULL AS GP_SG_RM_SMS_OUT, NULL AS GP_SG_RM_GPRS, NULL 
                         AS GP_SG_TOTAL, NULL AS [GP_IBG-CONS_RM_VOICE_O], NULL AS [GP_IBG-CONS_RM_SMS_OUT], NULL AS [GP_IBG-CONS_RM_GPRS], NULL AS [GP_IBG-CONS_TOTAL], NULL AS GP_RM_VOICE, NULL 
                         AS GP_RM_SMS_OUT, NULL AS GP_RM_GPRS, NULL AS GP_RM_TOTAL, NULL AS TM_CM_RM_VOICE_O, NULL AS TM_CM_RM_SMS_OUT, NULL AS TM_CM_RM_GPRS, NULL AS TM_CM_TOTAL, NULL 
                         AS TM_EG_RM_VOICE_O, NULL AS TM_EG_RM_SMS_OUT, NULL AS TM_EG_RM_GPRS, NULL AS TM_EG_TOTAL, NULL AS TM_SG_RM_VOICE_O, NULL AS TM_SG_RM_SMS_OUT, NULL AS TM_SG_RM_GPRS, NULL 
                         AS TM_SG_TOTAL, NULL AS TM_RM_VOICE_O, NULL AS TM_RM_SMS_OUT, NULL AS TM_RM_GPRS, NULL AS TM_RM_TOTAL, NULL AS TOTAL_ADJUSTMENT
		FROM            SumIntapCN_Table
		WHERE        (Account_Group = ''' || var_Tapcode || ''')
		GROUP BY Partner_Company
			) A ORDER BY SortPart,AddSpace
	) B';
        var_createQuery10 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        ''INTAP LOAD FILE'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73
UNION ALL
SELECT        NULL AS Expr1, ''Counter'' AS Column1, ''Doc_Date'' AS Column2, ''Pstg date'' AS Column3, ''Type'' AS Column4, ''CoCd'' AS Column5, ''CURR'' AS Column6, ''TranslDate'' AS Column7, ''Exchange_Rate'' AS Column8, 
                         ''Ledger_Group'' AS Column9, ''Period'' AS Column10, ''Reference'' AS Column11, ''Document_header_text'' AS Column12, ''PK'' AS Column13, ''GL_acct'' AS Column14, ''SpecialGL'' AS Column15, ''Amount_in_doc_curr'' AS Column16, 
                         ''Amount_in_local_curr'' AS Column17, ''Amount_in_local_cur_2'' AS Column18, ''Ref_key_1'' AS Column19, ''Ref_key_2'' AS Column20, ''Ref_key_3'' AS Column21, ''Bline_date'' AS Column22, ''Purch_doc'' AS Column23, 
                         ''PurchasingLineItem'' AS Column24, ''WBS_Element'' AS Column25, ''Material'' AS Column26, ''Plnt'' AS Column27, ''Value_date'' AS Column28, ''PayT'' AS Column29, ''Order'' AS Column30, ''Cost_ctr'' AS Column31, 
                         ''Profit_ctr'' AS Column32, ''Partner_Profit_Center'' AS Column33, ''Tr_prt'' AS Column34, ''Assignment'' AS Column35, ''Text'' AS Column36, ''Quantity'' AS Column37, ''UoM'' AS Column38, ''Brand'' AS Column39, 
                         ''SubProduct_A'' AS Column40, ''SubProduct_B'' AS Column41, ''Franchise_Area'' AS Column42, ''Business_Center'' AS Column43, ''Revenue_Type'' AS Column44, ''Event'' AS Column45, ''Vat_Tax_Code'' AS Column46, 
                         ''MVNO Partner'' AS Column47, ''Technology'' AS Column48, ''Charge Code'' AS Column49, ''Plan Type'' AS Column50, ''Name'' AS Column51, ''Street'' AS Column52, ''Country'' AS Column53, ''Postal Code'' AS Column54, 
                         ''City'' AS Column55, ''Bank Key'' AS Column56, ''Bank Account'' AS Column57, ''Tax Number'' AS Column58, ''General Ledger Account'' AS Column59, ''Message'' AS Column60, ''Main Asset Number'' AS Column61, 
                         ''Base Tax Amount'' AS Column62, ''Withholding Tax Type'' AS Column63, ''Withholding Tax Code'' AS Column64, ''Payment Method'' AS Column65, ''New Company Code'' AS Column66, ''Local file for upload/download'' AS Column67, 
                         ''Error Flag'' AS Column68, ''core product'' AS Column69, ''Product lines'' AS Column70, ''DSP_Order'' AS Column71, ''DSP_UniqueKey'' AS Column72
UNION ALL
SELECT   TOP 10000     NULL AS Expr1, CAST(DENSE_RANK() OVER (ORDER BY TEXT) AS VARCHAR) AS Counter, Doc_Date, [Pstg date], Type, CoCd, CURR, TranslDate, Exchange_Rate, Ledger_Group, Period, Reference, Document_header_text, PK, GL_acct, SpecialGL, Amount_in_doc_curr, Amount_in_local_curr, 
                         Amount_in_local_cur_2, Ref_key_1, Ref_key_2, Ref_key_3, Bline_date, Purch_doc, PurchasingLineItem, WBS_Element, Material, Plnt, Value_date, PayT, [Order], Cost_ctr, Profit_ctr, Partner_Profit_Center, Tr_prt, Assignment, 
                         Text, Quantity, UoM, Brand, SubProduct_A, SubProduct_B, Franchise_Area, Business_Center, Revenue_Type, Event, Vat_Tax_Code, [MVNO Partner], Technology, [Charge Code], [Plan Type], Name, Street, Country, [Postal Code],
                          City, [Bank Key], [Bank Account], [Tax Number], [General Ledger Account], Message, [Main Asset Number], [Base Tax Amount], [Withholding Tax Type], [Withholding Tax Code], [Payment Method], [New Company Code], 
                         [Local file for upload/download], [Error Flag], [core product], [Product lines], DSP_Order, DSP_UniqueKey
FROM            [SumInTap_Loadfile_Table] WHERE Account_Group = ''' || var_Tapcode || '''
ORDER BY Text,Sno
) A WHERE EXISTS (SELECT Account_group FROM SUMMARY_IB_OB_Summary_Header WHERE Account_Group = ''' || var_Tapcode || ''' GROUP BY Account_Group)
';
        /*
        [7672 - Severity CRITICAL - PostgreSQL doesn't support EXECUTE statements that run a character string. Convert your source code manually.]
        exec (@createQuery0+@createQuery1+@createQuery2+@createQuery3+@createQuery4+@createQuery5+@createQuery6+@createQuery7+@createQuery8+@createQuery9+@createQuery10)
        */
        DELETE FROM sdbtdip2_iot_da_dbo.tapcodesnew
            WHERE (LOWER(tapcode) = LOWER(var_Tapcode));
    END LOOP;
END;
$procedure$
