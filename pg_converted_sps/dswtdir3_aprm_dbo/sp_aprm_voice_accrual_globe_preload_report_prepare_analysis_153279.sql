CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_prepare_analysis()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
DROP TABLE IF EXISTS analysis_per_partner_curr_conversion;
CREATE TEMP TABLE analysis_per_partner_curr_conversion ON COMMIT DROP AS
SELECT *
FROM ANALYSIS_PER_PARTNER_CURR_CONVERSION;

	-- SUB_ANALYSIS_PER_PARTNER
	DROP TABLE IF EXISTS sub_analysis_per_partner;
CREATE TEMP TABLE sub_analysis_per_partner ON COMMIT DROP AS
SELECT MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."SERVICE"      
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."CURRENCY"     
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."CHARGE DIRECTION"   
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."TYPE"      
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."MONTH"  
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."Sum of SETTABLE DURATION"  
		,MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."Sum of NET SETTABLE AMT"     
		,CASE WHEN PREV_MON_ANALYSIS_PER_PARTNER."MONTH" IS NULL THEN (SELECT "MONTH" FROM	PREV_MON_ANALYSIS_PER_PARTNER WHERE "MONTH" IS NOT NULL LIMIT 1) ELSE PREV_MON_ANALYSIS_PER_PARTNER."MONTH" END AS  "Prev MONTH"  
		,COALESCE(PREV_MON_ANALYSIS_PER_PARTNER."Sum of SETTABLE DURATION",0) AS "Prev Sum of SETTABLE DURATION"  
		,COALESCE(PREV_MON_ANALYSIS_PER_PARTNER."Sum of NET SETTABLE AMT",0)  AS "Prev Sum of NET SETTABLE AMT"
FROM MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON LEFT JOIN PREV_MON_ANALYSIS_PER_PARTNER ON  
	   MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."SERVICE"   = PREV_MON_ANALYSIS_PER_PARTNER."SERVICE"  
	AND MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."CURRENCY"   = PREV_MON_ANALYSIS_PER_PARTNER."CURRENCY"  
	AND MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."CHARGE DIRECTION" = PREV_MON_ANALYSIS_PER_PARTNER."CHARGE DIRECTION"  
	AND MoM_SAP_REPORT_GLB_ACCRUAL_Analysis_CURRENT_MON."TYPE"    = PREV_MON_ANALYSIS_PER_PARTNER."TYPE";

	-- ANALYSIS_PER_PARTNER_LAYOUT
	DROP TABLE IF EXISTS analysis_per_partner_layout;
CREATE TEMP TABLE analysis_per_partner_layout ON COMMIT DROP AS
SELECT *
FROM
	(
		SELECT DISTINCT             
		'' AS COLUMN1            
		,'' AS COLUMN2            
		,'' AS COLUMN3            
		,'' AS COLUMN4            
		,FORMAT(CAST("MONTH" AS DATE),'Y') AS COLUMN5            
		,'' AS COLUMN6            
		,FORMAT(CAST("Prev MONTH"  AS DATE),'Y') AS COLUMN7            
		,'' AS COLUMN8      
	
		-- ,'Rate per min ' AS COLUMN9            
		-- ,'Rate per min '  AS COLUMN10   
		,FORMAT(CAST("MONTH" AS DATE),'Y')  AS COLUMN9            
		,FORMAT(CAST("Prev MONTH" AS DATE),'Y')   AS COLUMN10      
	

		,'Mins' as COLUMN11            
		,'Increase/Decrease($)' as COLUMN12           
		, 'PHP'  AS COLUMN13           
		FROM sub_analysis_per_partner WHERE "Prev MONTH" IS NOT NULL            
		UNION ALL            
		SELECT DISTINCT             
		'' AS COLUMN1            
		,'' AS COLUMN2            
		,'' AS COLUMN3            
		,'' AS COLUMN4            
		,'Sum of SETTABLE DURATION' AS COLUMN5            
		,'Sum of NET SETTABLE AMT' AS COLUMN6            
		,'Sum of SETTABLE DURATION'  AS COLUMN7  
		,'Sum of NET SETTABLE AMT' AS COLUMN8   
	
		-- ,FORMAT(CAST("MONTH" AS DATE),'Y')  AS COLUMN9            
		-- ,FORMAT(CAST("Prev MONTH" AS DATE),'Y')   AS COLUMN10      
		,'Rate per min ' AS COLUMN9            
		,'Rate per min '  AS COLUMN10   
	
		,'SETTABLE DURATION' as COLUMN11            
		,'NET SETTABLE AMT' as COLUMN12     
	
		,CAST(FORMAT((SELECT UKURS FROM analysis_per_partner_curr_conversion),'###,#0.00##')AS VARCHAR)  AS COLUMN13            
		FROM sub_analysis_per_partner WHERE "Prev MONTH" IS NOT NULL
		UNION ALL                 
		SELECT             
		"SERVICE"       AS COLUMN1            
		,"CURRENCY"       AS COLUMN2            
		,CASE WHEN "CHARGE DIRECTION" ='P' THEN  'Payout' WHEN "CHARGE DIRECTION" ='R' THEN  'Inbound' End  AS COLUMN3            
		,"TYPE"        AS COLUMN4            
		,CAST(FORMAT("Sum of SETTABLE DURATION"   ,'###,#0.00##')AS VARCHAR)   AS COLUMN5            
		,CAST(FORMAT("Sum of NET SETTABLE AMT"   ,'###,#0.00##')AS VARCHAR)  AS COLUMN6            
		,CAST(FORMAT("Prev Sum of SETTABLE DURATION"  ,'###,#0.00##')AS VARCHAR) AS COLUMN7            
		,CAST(FORMAT("Prev Sum of NET SETTABLE AMT"  ,'###,#0.00##')AS VARCHAR)   AS COLUMN8            
		,CASE WHEN "Sum of SETTABLE DURATION"<>0 THEN CAST(FORMAT(CAST("Sum of NET SETTABLE AMT"/"Sum of SETTABLE DURATION"   AS FLOAT),'###,#0.00##')AS VARCHAR) ELSE '0' END     AS COLUMN9            
		,CASE WHEN "Prev Sum of SETTABLE DURATION"<>0 THEN CAST(FORMAT(CAST("Prev Sum of NET SETTABLE AMT"/"Prev Sum of SETTABLE DURATION"AS FLOAT),'###,#0.00##')AS VARCHAR)   ELSE '0' END       AS COLUMN10            
		,CAST(FORMAT("Sum of SETTABLE DURATION" -"Prev Sum of SETTABLE DURATION",'###,#0.00##')AS VARCHAR) as COLUMN11            
		,CAST(FORMAT("Sum of NET SETTABLE AMT" -"Prev Sum of NET SETTABLE AMT" ,'###,#0.00##')AS VARCHAR)  as COLUMN12            
		,CAST(FORMAT(ROUND(("Sum of NET SETTABLE AMT" -"Prev Sum of NET SETTABLE AMT")*(SELECT UKURS FROM analysis_per_partner_curr_conversion),2),'###,#0.00##')AS VARCHAR) AS COLUMN13          
		FROM sub_analysis_per_partner 
	) as xx;

  DROP TABLE IF EXISTS tvaprm_voice_globe_analysis_per_partnerrptsel;
CREATE TEMP TABLE tvaprm_voice_globe_analysis_per_partnerrptsel ON COMMIT DROP AS
SELECT *
FROM
	(
	  SELECT COLUMN1,            
			 COLUMN2,            
			 COLUMN4   AS COLUMN3,            
			 COLUMN3   AS COLUMN4,            
			 CASE WHEN  COLUMN5  SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN5 ,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN5  END AS COLUMN5  ,            
			 CASE WHEN  COLUMN6  SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN6 ,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN6  END AS COLUMN6  ,            
			 CASE WHEN  COLUMN7  SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN7 ,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN7  END AS COLUMN7  ,            
			 CASE WHEN  COLUMN8  SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN8 ,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN8  END AS COLUMN8  ,            
			 CASE WHEN  COLUMN9  SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN9 ,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN9  END AS COLUMN9  ,            
			 CASE WHEN  COLUMN10 SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN10,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN10 END AS COLUMN10,            
			 CASE WHEN  COLUMN11 SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN11,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN11 END AS COLUMN11,            
			 CASE WHEN  COLUMN12 SIMILAR TO '[0-9]%' THEN FORMAT(ROUND(CAST(REPLACE(COLUMN12,',','') AS FLOAT),2) ,'###,#0.00##') ELSE COLUMN12 END AS COLUMN12,            
			 CASE WHEN  COLUMN13 SIMILAR TO '[0-9]%' THEN FORMAT(CAST(REPLACE(COLUMN13,',','') AS FLOAT) ,'###,#0.00######') ELSE COLUMN13 END AS COLUMN13            
	  FROM   analysis_per_partner_layout            
	  UNION ALL            
	  SELECT '* TOTAL *'                                    AS COLUMN1,            
			 ''                                             AS COLUMN2,            
			 ''                                             AS COLUMN3,            
			 ''                                             AS COLUMN4,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN5,',','') AS FLOAT)) ,2),  '###,#0.00##')  AS COLUMN5,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN6,',','') AS FLOAT)) ,2),  '###,#0.00##')  AS COLUMN6,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN7,',','') AS FLOAT)) ,2),  '###,#0.00##')  AS COLUMN7,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN8,',','') AS FLOAT)) ,2),  '###,#0.00##')  AS COLUMN8,          
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN6,',','') AS FLOAT))/Sum(Cast(REPLACE(COLUMN5,',','') AS FLOAT)) ,2),  '###,#0.00##')  AS COLUMN9,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN8,',','')  AS FLOAT))/Sum(Cast(REPLACE(COLUMN7,',','') AS FLOAT)),2), '###,#0.00##') AS COLUMN10,       
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN11,',','')  AS FLOAT)),2), '###,#0.00##') AS COLUMN11,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN12,',','')  AS FLOAT)),2), '###,#0.00##') AS COLUMN12,            
			 FORMAT(ROUND(Sum(Cast(REPLACE(COLUMN13,',','')  AS FLOAT)),2), '###,#0.00######') AS COLUMN13            
	  FROM   analysis_per_partner_layout            
	  where  COLUMN1 <> '' 
	) as xx;

	TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache;
	INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
			("COLUMN1"
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
			,"COLUMN13")
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
	FROM dswtdir3_aprm_dbo.tvaprm_voice_globe_analysis_per_partnerrptsel;
END;
$procedure$
