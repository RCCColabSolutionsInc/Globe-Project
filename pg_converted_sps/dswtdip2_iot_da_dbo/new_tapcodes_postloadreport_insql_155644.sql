CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.new_tapcodes_postloadreport_insql()
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
        var_createQuery0 := 'ALTER VIEW [dbo].[tvIOT_DA_' || var_Tapcode || '_PostloadRptSel]
							AS
							SELECT         Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, Column10, NULL 
                         AS Column11, Column12, Column13, Column14, Column15, Column16, Column17, Column18, Column19, Column20, Column21, NULL 
                         AS Column22, Column23, Column24, Column25, Column26, Column27, Column28, Column29, Column30, Column31, Column32, NULL 
                         AS Column33, Column34, Column35, Column36, Column37, Column38, Column39, Column40, Column41, Column42, Column43, NULL 
                         AS Column44, Column45, Column46, Column47, Column48, Column49, Column50, Column51, Column52, Column53, Column54, NULL 
                         AS Column55, Column56, Column57, Column58, Column59, Column60, Column61, Column62, Column63, Column64, Column65, NULL 
                         AS Column66, Column67, Column68, Column69, Column70, Column71, Column72, Column73,Column74, Column75
FROM (
';
        var_createQuery1 := '
						SELECT        ''OUTTAP POSTLOAD FILE'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73,NULL AS Column74, NULL AS Column75
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
                         ''Error Flag'' AS Column68, ''core product'' AS Column69, ''Product lines'' AS Column70, ''DSP_Order'' AS Column71, ''DSP_UniqueKey'' AS Column72, ''Z_MESSAGE'' AS Column73, ''Z_SOURCE_NAME'' AS Column74
UNION ALL

SELECT  TOP 10000      NULL AS Expr1, CAST(DENSE_RANK() OVER (ORDER BY Text) AS VARCHAR) AS Counter, Doc_Date, [Pstg date], Type, CoCd, CURR, TranslDate, Exchange_Rate, Ledger_Group, Period, Reference, Document_header_text, PK, GL_acct, SpecialGL,
					Amount_in_doc_curr, Amount_in_local_curr, 
                         Amount_in_local_cur_2, Ref_key_1, Ref_key_2, Ref_key_3, Bline_date, Purch_doc, PurchasingLineItem, WBS_Element, Material, Plnt, Value_date, PayT, [Order], Cost_ctr, Profit_ctr, Partner_Profit_Center, Tr_prt, Assignment, 
                         Text, Quantity, UoM, Brand, SubProduct_A, SubProduct_B, Franchise_Area, Business_Center, Revenue_Type, Event, Vat_Tax_Code, [MVNO Partner], Technology, [Charge Code], [Plan Type], Name, Street, Country, [Postal Code],
                          City, [Bank Key], [Bank Account], [Tax Number], [General Ledger Account], Message, [Main Asset Number], [Base Tax Amount], [Withholding Tax Type], [Withholding Tax Code], [Payment Method], [New Company Code], 
                         [Local file for upload/download], [Error Flag], [core product], [Product lines], DSP_Order, DSP_UniqueKey,Z_MESSAGE  ,Z_SOURCE_NAME
FROM            Summary_OUTTAP_Loadfile_Table
			INNER JOIN dbo.ZFFI_REPORT_ODBC AS ODBC  
                 ON Summary_OUTTAP_Loadfile_Table.DSP_Order = ODBC.ZDSP_ORDER  
                    AND Summary_OUTTAP_Loadfile_Table.DSP_UniqueKey = ODBC.ZDSP_UNIQUEKEY  
                    AND Z_MESSAGE <> ''Successful'' 
					WHERE Account_Group = ''' || var_Tapcode || ''' AND Amount_in_doc_curr <> ''0.00''
					ORDER BY TEXT,Sno';
        var_createQuery2 := '
UNION ALL
SELECT        NULL AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL AS Column11, NULL 
                         AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL AS Column22, NULL 
                         AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL AS Column33, NULL 
                         AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL AS Column44, NULL 
                         AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL AS Column55, NULL 
                         AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL AS Column66, NULL 
                         AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73,NULL AS Column74, NULL AS Column75
UNION ALL
SELECT        ''INTAP POSTLOAD FILE'' AS Column1, NULL AS Column2, NULL AS Column3, NULL AS Column4, NULL AS Column5, NULL AS Column6, NULL AS Column7, NULL AS Column8, NULL AS Column9, NULL AS Column10, NULL 
                         AS Column11, NULL AS Column12, NULL AS Column13, NULL AS Column14, NULL AS Column15, NULL AS Column16, NULL AS Column17, NULL AS Column18, NULL AS Column19, NULL AS Column20, NULL AS Column21, NULL 
                         AS Column22, NULL AS Column23, NULL AS Column24, NULL AS Column25, NULL AS Column26, NULL AS Column27, NULL AS Column28, NULL AS Column29, NULL AS Column30, NULL AS Column31, NULL AS Column32, NULL 
                         AS Column33, NULL AS Column34, NULL AS Column35, NULL AS Column36, NULL AS Column37, NULL AS Column38, NULL AS Column39, NULL AS Column40, NULL AS Column41, NULL AS Column42, NULL AS Column43, NULL 
                         AS Column44, NULL AS Column45, NULL AS Column46, NULL AS Column47, NULL AS Column48, NULL AS Column49, NULL AS Column50, NULL AS Column51, NULL AS Column52, NULL AS Column53, NULL AS Column54, NULL 
                         AS Column55, NULL AS Column56, NULL AS Column57, NULL AS Column58, NULL AS Column59, NULL AS Column60, NULL AS Column61, NULL AS Column62, NULL AS Column63, NULL AS Column64, NULL AS Column65, NULL 
                         AS Column66, NULL AS Column67, NULL AS Column68, NULL AS Column69, NULL AS Column70, NULL AS Column71, NULL AS Column72, NULL AS Column73, NULL AS Column74, NULL AS Column75
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
                         ''Error Flag'' AS Column68, ''core product'' AS Column69, ''Product lines'' AS Column70, ''DSP_Order'' AS Column71, ''DSP_UniqueKey'' AS Column72, ''Z_MESSAGE'' AS Column73, ''Z_SOURCE_NAME'' AS Column74
UNION ALL
SELECT   TOP 10000     NULL AS Expr1, CAST(DENSE_RANK() OVER (ORDER BY Text) AS VARCHAR) AS Counter, Doc_Date, [Pstg date], Type, CoCd, CURR, TranslDate, Exchange_Rate, Ledger_Group, Period, Reference, Document_header_text, PK, GL_acct, SpecialGL, 
		Amount_in_doc_curr, Amount_in_local_curr, 
                         Amount_in_local_cur_2, Ref_key_1, Ref_key_2, Ref_key_3, Bline_date, Purch_doc, PurchasingLineItem, WBS_Element, Material, Plnt, Value_date, PayT, [Order], Cost_ctr, Profit_ctr, Partner_Profit_Center, Tr_prt, Assignment, 
                         Text, Quantity, UoM, Brand, SubProduct_A, SubProduct_B, Franchise_Area, Business_Center, Revenue_Type, Event, Vat_Tax_Code, [MVNO Partner], Technology, [Charge Code], [Plan Type], Name, Street, Country, [Postal Code],
                          City, [Bank Key], [Bank Account], [Tax Number], [General Ledger Account], Message, [Main Asset Number], [Base Tax Amount], [Withholding Tax Type], [Withholding Tax Code], [Payment Method], [New Company Code], 
                         [Local file for upload/download], [Error Flag], [core product], [Product lines], DSP_Order, DSP_UniqueKey,Z_MESSAGE  ,Z_SOURCE_NAME 
FROM            [SumInTap_Loadfile_Table] 
			INNER JOIN dbo.ZFFI_REPORT_ODBC AS ODBC  
                 ON [SumInTap_Loadfile_Table].DSP_Order = ODBC.ZDSP_ORDER  
                    AND [SumInTap_Loadfile_Table].DSP_UniqueKey = ODBC.ZDSP_UNIQUEKEY  
                    AND Z_MESSAGE <> ''Successful'' 
					WHERE Account_Group = ''' || var_Tapcode || ''' AND Amount_in_doc_curr <> ''0.00''
					ORDER BY TEXT,Sno
					) A WHERE EXISTS (SELECT Account_group FROM SUMMARY_IB_OB_Summary_Header WHERE Account_Group = ''' || var_Tapcode || ''' GROUP BY Account_Group)
';
        /*
        [7672 - Severity CRITICAL - PostgreSQL doesn't support EXECUTE statements that run a character string. Convert your source code manually.]
        exec (@createQuery0+@createQuery1+@createQuery2)
        */
        DELETE FROM sdbtdip2_iot_da_dbo.tapcodesnew
            WHERE (LOWER(tapcode) = LOWER(var_Tapcode));
    END LOOP;
END;
$procedure$
