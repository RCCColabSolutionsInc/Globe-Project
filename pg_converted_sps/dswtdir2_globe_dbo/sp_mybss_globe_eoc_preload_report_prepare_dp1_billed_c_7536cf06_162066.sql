CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_c_7536cf06(IN p_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
DROP TABLE IF EXISTS tmp_308_billed_adjustments_header_item;
	CREATE TEMP TABLE tmp_308_billed_adjustments_header_item AS
	-- Table 1
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
	 FROM sdbtdir2_globe."308_Billed_Adjustments_ssis"  
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
	 FROM sdbtdir2_globe."308_Billed_Adjustments_ssis"  
	 WHERE BillCycle = p_billcycle AND LENGTH(Column1) = 1  
	 ) Item  
	 ON 1 = 1;DROP TABLE IF EXISTS tmp_411_bill_control_g_billed_adjustment;
	CREATE TEMP TABLE tmp_411_bill_control_g_billed_adjustment AS
	-- Table 2
	SELECT *
	FROM sdbtdir2_globe."411_Bill_Control_ssis"  
	WHERE BillCycle = p_billcycle AND Column1 IN (  
	'Total Adjustments'  
	,'Total Adjustment VAT'  
	);DROP TABLE IF EXISTS tmp_318_billed_charges_header_item;
	CREATE TEMP TABLE tmp_318_billed_charges_header_item AS
	-- Table 3

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
	 FROM sdbtdir2_globe."318_Billed_Charges_ssis"  
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
	 FROM sdbtdir2_globe."318_Billed_Charges_ssis"
	 WHERE BillCycle = p_billcycle AND LENGTH(Column1) = 1  
	 ) Item  
	 ON 1 = 1;DROP TABLE IF EXISTS tmp_411_bill_control_g_billed_charges;
	CREATE TEMP TABLE tmp_411_bill_control_g_billed_charges AS
	-- table 4
	SELECT *
	FROM sdbtdir2_globe."411_Bill_Control_ssis"
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
	  );


-- Query

DELETE FROM rpt_Preload_Report_DP1_Billed_Control_Recon_Cache WHERE BillCycle = p_billcycle;

INSERT INTO dbo.rpt_Preload_Report_DP1_Billed_Control_Recon_Cache
           (SORT
           ,Column1
           ,Column2
           ,Column3
           ,Column4
           ,Column5
           ,Column6
           ,Column7
           ,BillCycle)
SELECT
	SORT
	,Column1
	,Column2
	,Column3
	,Column4
	,Column5
	,Column6
	,Column7
	,p_billcycle
FROM
(
	SELECT ''  AS SORT,  
			Column1,  
			CASE  
			WHEN Column2 LIKE '[0-9]%'  
					OR Column2 LIKE '-%' THEN Cast(TO_CHAR((Cast(Round(Column2, 2) AS NUMERIC(38, 2))), 'FM999,999,990.00')  AS VARCHAR)  
			ELSE Column2  
			END AS Column2,  
			CASE  
			WHEN Column3 LIKE '[0-9]%'  
					OR Column3 LIKE '-%' THEN Cast(TO_CHAR((Cast(Round(Column3, 2) AS NUMERIC(38, 2))), 'FM999,999,990.00') AS VARCHAR)  
			ELSE Column3  
			END AS Column3,  
			CASE  
			WHEN Column4 LIKE '[0-9]%'  
					OR Column4 LIKE '-%' THEN Cast(TO_CHAR((Cast(Round(Column4, 2) AS NUMERIC(38, 2))), 'FM999,999,990.00') AS VARCHAR)  
			ELSE Column4  
			END AS Column4,  
			CASE  
			WHEN Column5 LIKE '[0-9]%'  
					OR Column5 LIKE '-%' THEN Cast(Cast(Round(Column5, 2) * 100 AS NUMERIC(38, 2)) AS VARCHAR) || '%'  
			ELSE Column5  
			END AS Column5,  
			Column6,  
			Column7  
	FROM   sdbtdir2_globe."411_Bill_Control_ssis"  
	WHERE BillCycle = p_billcycle AND  COALESCE(Column1, '') <> 'Report Creator : Amdocs BI Team'
	UNION ALL  
	SELECT ''               AS SORT,  
			'Reconciliation' AS Column1,  
			''               Column2,  
			''               AS Column3,  
			''               AS Column4,  
			''               AS Column5,  
			''               AS Column6,  
			''               AS Column7  
	UNION ALL  
	SELECT ''           AS SORT,  
			''           AS Column1,  
			''           Column2,  
			'Report'     AS Column3,  
			'Difference' AS Column4,  
			''           AS Column5,  
			''           AS Column6,  
			''           AS Column7  
	UNION ALL
	SELECT ''                                                                                                           AS SORT,  
		'Billed Charges'                                                                                             AS Column1,  
		Cast(TO_CHAR((Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)                                             AS Column2,  
		(SELECT Cast(TO_CHAR((Sum(Cast(Round("Total Amount", 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)  
		FROM   tmp_318_billed_charges_header_item)                                                                    AS Column3,  
		Cast(TO_CHAR((Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round("Total Amount", 2) AS NUMERIC(38, 2)))  
															FROM   tmp_318_billed_charges_header_item)), 'FM999,999,990.00') AS VARCHAR) AS Column4,  
		''                                                                                                           AS Column5,  
		''                                                                                                           AS Column6,  
		''                                                                                                           AS Column7  
	FROM   tmp_411_bill_control_g_billed_charges
	UNION ALL  
	SELECT ''                                                                                                               AS SORT,  
		'Billed Adjustment'                                                                                              AS Column1,  
		Cast(TO_CHAR((Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)                                                 AS Column2,  
		(SELECT Cast(TO_CHAR((Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR)  
		FROM   tmp_308_billed_adjustments_header_item)                                                                    AS Column3,  
		Cast(TO_CHAR((Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))  
															FROM   tmp_308_billed_adjustments_header_item)), 'FM999,999,990.00') AS VARCHAR) AS Column4,  
		''                                                                                                               AS Column5,  
		''                                                                                                               AS Column6,  
		''                                                                                                               AS Column7  
	FROM   tmp_411_bill_control_g_billed_adjustment
	UNION ALL
	SELECT ''                                                                                                                           AS SORT,  
			'sapglbilled'                                                                                                                AS Column1,  
			Cast(TO_CHAR(((SELECT Sum(Cast(Round("Total Amount", 2) AS NUMERIC(38, 2)))  
				FROM   tmp_318_billed_charges_header_item) || ((SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))  
					FROM   tmp_308_billed_adjustments_header_item))), 'FM999,999,990.00') AS VARCHAR)                                                          AS Column2,  
			( Cast(TO_CHAR((Sum(Cast(Round(Column8, 2) AS NUMERIC(38, 2)))), 'FM999,999,990.00') AS VARCHAR) )                                                         AS Column3,  
			Cast(TO_CHAR((( (SELECT Sum(Cast(Round("Total Amount", 2) AS NUMERIC(38, 2)))  
					FROM   tmp_318_billed_charges_header_item) || ((SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))  
					FROM   tmp_308_billed_adjustments_header_item)) ) - ( Sum(Cast(Round(Column8, 2) AS NUMERIC(38, 2))) )), 'FM999,999,990.00') AS VARCHAR) AS Column4,  
			''                                                                                                                           AS Column5,  
			''                                                                                                                           AS Column6,  
			''
	FROM   sdbtdir2_globe.sapglbilled_ssis
	WHERE BillCycle = p_billcycle
) as xx;
END;
$procedure$
