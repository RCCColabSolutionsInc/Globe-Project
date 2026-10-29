CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_preload_pg(IN p_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Author     : Winston Madiano                  */
/* Create date: Feb 9, 2023                      */
/* Description: Transform postload data          */
/* ============================================= */
/* Modified by: Kristian Corrales                */
/* Create date: October 19, 2026                 */
/* Description: Transform preload data          */
/* ============================================= */

BEGIN
	DROP TABLE IF EXISTS tmp_temp;
	
	CREATE TEMP TABLE tmp_temp AS
	WITH
	CTE_308_Billed_Adjustments_Header_Item AS
	(
		SELECT *  
		FROM (  
		 SELECT MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Code%'  
			 THEN COLUMN2  
			END) AS Cycle_Code  
		  ,MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Year%'  
			 THEN COLUMN2  
			END) AS Cycle_Year  
		  ,MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Instance%'  
			 THEN COLUMN2  
			END) AS Cycle_Instance  
		 FROM sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis"  
		 WHERE BillCycle = p_billcycle AND Column1 LIKE '%Cycle%'  
		 ) Header  
		JOIN (  
		 SELECT Column1 AS "Customer Type"  
		  ,Column2 AS "Customer Sub Type"  
		  ,Column3 AS "Subscriber Type"  
		  ,Column4 AS "Adjustment Type"  
		  ,Column5 AS "Adjustment Code"  
		  ,Column6 AS "Adjustment Reason"  
		  ,Column7 AS "Legal Entity"  
		  ,Column8 AS Currency  
		  ,Column9 AS Amount  
		  ,Column10 AS "Write-Off Activity Indicator"  
		 FROM sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis"  
		 WHERE BillCycle = p_billcycle AND LENGTH(Column1) = 1  
		 ) Item  
		 ON 1 = 1  
	)
	,CTE_411_Bill_Control_G_Billed_Adjustment AS
	(
		SELECT *  
		FROM sdbtdir2_globe_dbo."411_Bill_Control_ssis"  
		WHERE BillCycle = p_billcycle AND Column1 IN (  
		'Total Adjustments'  
		,'Total Adjustment VAT'  
		)
	)
	,CTE_318_Billed_Charges_Header_Item AS
	(
		SELECT *  
		FROM (  
		 SELECT MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Code%'  
			 THEN COLUMN2  
			END) AS Cycle_Code  
		  ,MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Year%'  
			 THEN COLUMN2  
			END) AS Cycle_Year  
		  ,MAX(CASE   
			WHEN COLUMN1 LIKE '%Cycle Instance%'  
			 THEN COLUMN2  
			END) AS Cycle_Instance  
		 FROM sdbtdir2_globe_dbo."318_Billed_Charges_ssis"  
		 WHERE BillCycle = p_billcycle AND Column1 LIKE '%Cycle%'  
		 ) Header  
		JOIN (  
		 SELECT Column1 AS "Customer Type"  
		  ,Column2 AS "Customer Sub Type"  
		  ,Column3 AS "Subscriber Type"  
		  ,Column4 AS "Revenue Type"  
		  ,Column5 AS "Charge Code/Tax Code"  
		  ,Column6 AS "Charge Type/Tax Type"  
		  ,Column7 AS "Discount Plan Code"  
		  ,Column8 AS "Total Amount"  
		  ,Column9 AS "Document Demand Type"  
		  ,Column10 AS "Legal Entity"  
		  ,Column11 AS Currency  
		 FROM sdbtdir2_globe_dbo."318_Billed_Charges_ssis"
		 WHERE BillCycle = p_billcycle AND LENGTH(Column1) = 1  
		 ) Item  
		 ON 1 = 1  
	)
	,CTE_411_Bill_Control_G_Billed_Charges AS
	(
		SELECT *  
		FROM sdbtdir2_globe_dbo."411_Bill_Control_ssis"
		WHERE BillCycle = p_billcycle AND Column1 IN (  
		  'Total Rental'  
		  ,'Total Promotion/Discount'  
		  ,'Total Traffic Processed'  
		  ,'Total VAS Charge'  
		  ,'Total Onetime Charges'  
		  ,'Total Overseas Communication Tax'  
		  ,'Total Overseas Tax (ECONOCALL)'  
		  ,'Total Surcharge'  
		  ,'Total VAT'  
		  )
	)
	,CTE_DP1_Billed_Control_Recon AS
	(
	  SELECT '' AS SORT,  
			 Column1,  
			 CASE  
			   WHEN Column2 ~ '^-?[0-9]' THEN Cast(TO_CHAR((Cast(Round(CAST(Column2 AS NUMERIC), 2) AS NUMERIC(38, 2))), 'FM999,999,990.00')  AS VARCHAR)  
			   ELSE Column2  
			 END AS Column2,  
			 CASE  
			   WHEN Column3 ~ '^-?[0-9]' THEN Cast(TO_CHAR((Cast(Round(CAST(Column3 AS NUMERIC), 2) AS NUMERIC(38, 2))), 'FM999,999,990.00') AS VARCHAR)  
			   ELSE Column3  
			 END AS Column3,  
			 CASE  
			   WHEN Column4 ~ '^-?[0-9]' THEN Cast(TO_CHAR((Cast(Round(CAST(Column4 AS NUMERIC), 2) AS NUMERIC(38, 2))), 'FM999,999,990.00') AS VARCHAR)  
			   ELSE Column4  
			 END AS Column4,  
			 CASE  
			   WHEN Column5 ~ '^-?[0-9]' THEN Cast(Cast(Round(CAST(Column5 AS NUMERIC), 2) * 100 AS NUMERIC(38, 2)) AS VARCHAR) || '%'  
			   ELSE Column5  
			 END AS Column5,  
			 Column6,  
			 Column7  
	  FROM   sdbtdir2_globe_dbo."411_Bill_Control_ssis"  
	  WHERE BillCycle = p_billcycle AND  COALESCE(Column1, '') <> 'Report Creator : Amdocs BI Team'
	  UNION ALL  
	  
	  SELECT ''                AS SORT,  
			 'Reconciliation'  AS Column1,  
			 ''                AS Column2,  
			 ''                AS Column3,  
			 ''                AS Column4,  
			 ''                AS Column5,  
			 ''                AS Column6,  
			 ''                AS Column7  
	  UNION ALL  
	  SELECT ''            AS SORT,  
			 ''            AS Column1,  
			 ''            AS Column2,  
			 'Report'      AS Column3,  
			 'Difference'  AS Column4,  
			 ''            AS Column5,  
			 ''            AS Column6,  
			 ''            AS Column7  
	 UNION ALL
	  SELECT ''                                                                                                                                           AS SORT,  
			 'Billed Charges'                                                                                                                             AS Column1,  
			 Cast(TO_CHAR((Sum(Cast(Round(CAST(Column3 AS NUMERIC), 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)                              AS Column2,  
			 (SELECT Cast(TO_CHAR((Sum(Cast(Round(CAST("Total Amount" AS NUMERIC), 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)  
			  FROM   CTE_318_Billed_Charges_Header_Item)                                                                                                  AS Column3,  
			 Cast(TO_CHAR((Sum(Cast(Round(CAST(Column3 AS NUMERIC), 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round(CAST("Total Amount" AS NUMERIC), 2) AS NUMERIC(38, 2)))  
														FROM   CTE_318_Billed_Charges_Header_Item)), 'FM999,999,990.00') AS VARCHAR)                  AS Column4,  
			 ''                                                                                                                                           AS Column5,  
			 ''                                                                                                                                           AS Column6,  
			 ''                                                                                                                                           AS Column7  
	  FROM   CTE_411_Bill_Control_G_Billed_Charges
	  UNION ALL  
	  SELECT ''                                                                                                                                              AS SORT,  
			 'Billed Adjustment'                                                                                                                             AS Column1,  
			 Cast(TO_CHAR((Sum(Cast(Round(CAST(Column3 AS NUMERIC), 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)                                 AS Column2,  
			 (SELECT Cast(TO_CHAR((Sum(Cast(Round(CAST(Amount AS NUMERIC), 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)  
			  FROM   CTE_308_Billed_Adjustments_Header_Item)                                                                                                 AS Column3,  
			 Cast(TO_CHAR((Sum(Cast(Round(CAST(Column3 AS NUMERIC), 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round(CAST(Amount AS NUMERIC), 2) AS NUMERIC(38, 2)))  
														FROM   CTE_308_Billed_Adjustments_Header_Item)), 'FM999,999,990.00') AS VARCHAR)                 AS Column4,  
			 ''                                                                                                                                              AS Column5,  
			 ''                                                                                                                                              AS Column6,  
			 ''                                                                                                                                              AS Column7  
	  FROM   CTE_411_Bill_Control_G_Billed_Adjustment
	  UNION ALL  
	  SELECT ''                                                                                                                                                                  AS SORT,  
			 'sapglbilled'                                                                                                                                                       AS Column1,  
			 Cast(TO_CHAR(((SELECT Sum(Cast(Round(CAST("Total Amount" AS NUMERIC), 2) AS NUMERIC(38, 2)))  
				   FROM   CTE_318_Billed_Charges_Header_Item) + ((SELECT Sum(Cast(Round(CAST(Amount AS NUMERIC), 2) AS NUMERIC(38, 2)))  
					  FROM   CTE_308_Billed_Adjustments_Header_Item))), 'FM999,999,990.00') AS VARCHAR)                                                                      AS Column2,  
			 ( Cast(TO_CHAR((Sum(Cast(Round(CAST(Column8 AS NUMERIC), 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR) )                                                 AS Column3,  
			 Cast(TO_CHAR((( (SELECT Sum(Cast(Round(CAST("Total Amount" AS NUMERIC), 2) AS NUMERIC(38, 2)))  
					 FROM   CTE_318_Billed_Charges_Header_Item) + ((SELECT Sum(Cast(Round(CAST(Amount AS NUMERIC), 2) AS NUMERIC(38, 2)))  
						FROM   CTE_308_Billed_Adjustments_Header_Item)) ) - ( Sum(Cast(Round(CAST(Column8 AS NUMERIC), 2) AS NUMERIC(38, 2))) )), 'FM999,999,990.00') AS VARCHAR) AS Column4,  
			 ''                                                                                                                                                                  AS Column5,  
			 ''                                                                                                                                                                  AS Column6,  
			 ''                                                                                                                                                                  AS Column7
	  FROM   sdbtdir2_globe_dbo.sapglbilled_ssis
	  WHERE BillCycle = p_billcycle
	)

	  SELECT Data         AS Data,   
			 Posting_Date AS Date,   
			 SAPFIGL      AS Brand,   
			 CT           AS "Customer Type",   
			 ST           AS "Subscriber Type",   
			 CH_Code      AS "Charge Code",   
			 DP_Code      AS "Discount Code",   
			 Amount       AS Amount,   
			 Hits         AS Hits,   
			 UOM          AS UOM,   
			 WO_Ind       AS "WO Indicator",   
			 CC           AS "Cost Center",   
			 ''           AS GL,   
			 NB_IND       AS "NB Indicator",   
			 Remarks,   
			 CASE   
			   WHEN Data <> '01' THEN NULL   
			   ELSE zDSP_Order   
			 END          AS zDSP_Order,   
			 zDSP_UniqueKey
	  FROM   dswtdir2_globe_dbo.ttglobe_dp1_billed   
	  WHERE  zLegacyCycle_Code = p_billcycle   
			 AND ( (select Cast(COALESCE(Replace(Column4, ',', ''), '0') as numeric(38, 2))   
					from   CTE_DP1_Billed_Control_Recon   
					where  Column1 = 'sapglbilled') <= 100000.00   
				   AND (select Cast(COALESCE(Replace(Column4, ',', ''), '0') as numeric(38, 2))   
						from   CTE_DP1_Billed_Control_Recon   
						where  Column1 = 'sapglbilled') >= -100000.00 ) AND zLoaded = '0'   
	  ORDER  BY Data;

	DELETE FROM dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_preload_cache WHERE BillCycle = p_billcycle;
	
	INSERT INTO dswtdir2_globe_dbo.rpt_preload_report_dp1_billed_preload_cache
			   (Data
			   ,Date
			   ,Brand
			   ,"Customer Type"
			   ,"Subscriber Type"
			   ,"Charge Code"
			   ,"Discount Code"
			   ,Amount
			   ,Hits
			   ,UOM
			   ,"WO Indicator"
			   ,"Cost Center"
			   ,GL
			   ,"NB Indicator"
			   ,Remarks
			   ,zDSP_Order
			   ,zDSP_UniqueKey
			   ,BillCycle)
	SELECT Data
		  ,Date
		  ,Brand
		  ,"Customer Type"
		  ,"Subscriber Type"
		  ,"Charge Code"
		  ,"Discount Code"
		  ,Amount
		  ,Hits
		  ,UOM
		  ,"WO Indicator"
		  ,"Cost Center"
		  ,GL
		  ,"NB Indicator"
		  ,Remarks
		  ,zDSP_Order
		  ,zDSP_UniqueKey
		  ,p_billcycle
	  FROM tmp_temp;
END;
$procedure$
