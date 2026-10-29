CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_export_dp1_billed_loadfilesel(IN par_billcycle character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    WITH
    	CTE_308_Billed_Adjustments_Header_Item
    	AS
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
    		FROM sdbTDIR2_Globe.[dbo].[308_Billed_Adjustments_ssis]
    		 WHERE BillCycle = @BillCycle
    		 AND Column1 LIKE '%Cycle%'
    		 ) Header
    		JOIN (
    		 SELECT Column1 AS [Customer Type]
    		  ,Column2 AS [Customer Sub Type]
    		  ,Column3 AS [Subscriber Type]
    		  ,Column4 AS [Adjustment Type]
    		  ,Column5 AS [Adjustment Code]
    		  ,Column6 AS [Adjustment Reason]
    		  ,Column7 AS [Legal Entity]
    		  ,Column8 AS [Currency]
    		  ,Column9 AS [Amount]
    		  ,Column10 AS [Write-Off Activity Indicator]
    		 FROM sdbTDIR2_Globe.[dbo].[308_Billed_Adjustments_ssis]
    		 WHERE BillCycle = @BillCycle
    		 AND LEN(Column1) = 1
    		 ) Item
    		 ON 1 = 1
    	)
    
    	,CTE_411_Bill_Control_G_Billed_Adjustment
    	AS
    	(
    	SELECT *
    	--FROM sdbTDIR2_Globe..[411_Bill_Control_G]
    	FROM sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
    	WHERE BillCycle = @BillCycle
    	AND Column1 IN (
    	  'Total Adjustments'
    	  ,'Total Adjustment VAT'
    	  )
    	)
    	,CTE_318_Billed_Charges_Header_Item
    	AS
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
    		 FROM sdbTDIR2_Globe..[318_Billed_Charges_ssis]
    		 WHERE BillCycle = @BillCycle
    		 AND
    		 Column1 LIKE '%Cycle%'
    		 ) Header
    		JOIN (
    		 SELECT Column1 AS [Customer Type]
    		  ,Column2 AS [Customer Sub Type]
    		  ,Column3 AS [Subscriber Type]
    		  ,Column4 AS [Revenue Type]
    		  ,Column5 AS [Charge Code/Tax Code]
    		  ,Column6 AS [Charge Type/Tax Type]
    		  ,Column7 AS [Discount Plan Code]
    		  ,Column8 AS [Total Amount]
    		  ,Column9 AS [Document Demand Type]
    		  ,Column10 AS [Legal Entity]
    		  ,Column11 AS [Currency]
    		 -- FROM sdbTDIR2_Globe..[318_Billed_Charges]
    		 FROM sdbTDIR2_Globe..[318_Billed_Charges_ssis]
    		 WHERE BillCycle = @BillCycle
    		 AND
    		 LEN(Column1) = 1
    		 ) Item
    		 ON 1 = 1
    	 )
    
    	,CTE_411_Bill_Control_G_Billed_Charges
    	AS
    	(
    		SELECT *
    		-- FROM sdbTDIR2_Globe..[411_Bill_Control_G]
    		FROM sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
    		WHERE BillCycle = @BillCycle
    		AND Column1 IN (
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
    
    	,CTE_tvGlobe_DP1_Billed_Control_Recon_Cycle1RptSel AS
    	(
    	  SELECT ''  AS SORT,
    			 Column1,
    			 CASE
    			   WHEN Column2 LIKE '[0-9]%'
    					 OR Column2 LIKE '-%' THEN Cast(FORMAT(Cast(Round(Column2, 2) AS NUMERIC(38, 2)),'###,###,#00.00')  AS NVARCHAR)
    			   ELSE Column2
    			 END AS Column2,
    			 CASE
    			   WHEN Column3 LIKE '[0-9]%'
    					 OR Column3 LIKE '-%' THEN Cast(FORMAT(Cast(Round(Column3, 2) AS NUMERIC(38, 2)),'###,###,#00.00') AS NVARCHAR)
    			   ELSE Column3
    			 END AS Column3,
    			 CASE
    			   WHEN Column4 LIKE '[0-9]%'
    					 OR Column4 LIKE '-%' THEN Cast(FORMAT(Cast(Round(Column4, 2) AS NUMERIC(38, 2)),'###,###,#00.00') AS NVARCHAR)
    			   ELSE Column4
    			 END AS Column4,
    			 CASE
    			   WHEN Column5 LIKE '[0-9]%'
    					 OR Column5 LIKE '-%' THEN Cast(Cast(Round(Column5, 2) * 100 AS NUMERIC(38, 2)) AS NVARCHAR)
    											   + '%'
    			   ELSE Column5
    			 END AS Column5,
    			 Column6,
    			 Column7
    	 FROM sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
    	  WHERE BillCycle = @BillCycle
    	  AND ISNULL(Column1, '') <> 'Report Creator : Amdocs BI Team'
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
    			 Cast(FORMAT(Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))),'###,###,#00.00') AS NVARCHAR)                                             AS Column2,
    			 (SELECT Cast(FORMAT(Sum(Cast(Round([Total Amount], 2) AS NUMERIC(38, 2))),'###,###,#00.00') AS NVARCHAR)
    			  FROM   CTE_318_Billed_Charges_Header_Item)                                                                    AS Column3,
    			 Cast(FORMAT(Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round([Total Amount], 2) AS NUMERIC(38, 2)))
    																	FROM   CTE_318_Billed_Charges_Header_Item),'###,###,#00.00') AS NVARCHAR) AS Column4,
    			 ''                                                                                                           AS Column5,
    			 ''                                                                                                           AS Column6,
    			 ''                                                                                                           AS Column7
    	  FROM   CTE_411_Bill_Control_G_Billed_Charges
    	  UNION ALL
    	  SELECT ''                                                                                                               AS SORT,
    			 'Billed Adjustment'                                                                                              AS Column1,
    			 Cast(FORMAT(Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))),'###,###,#00.00') AS NVARCHAR)                                                 AS Column2,
    			 (SELECT Cast(FORMAT(Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2))),'###,###,#00.00') AS NVARCHAR)
    			  FROM   CTE_308_Billed_Adjustments_Header_Item)                                                                    AS Column3,
    			 Cast(FORMAT(Sum(Cast(Round(Column3, 2) AS NUMERIC(38, 2))) - (SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))
    																	FROM   CTE_308_Billed_Adjustments_Header_Item),'###,###,#00.00') AS NVARCHAR) AS Column4,
    			 ''                                                                                                               AS Column5,
    			 ''                                                                                                               AS Column6,
    			 ''                                                                                                               AS Column7
    	  FROM CTE_411_Bill_Control_G_Billed_Adjustment
    	  UNION ALL
    	  SELECT ''                                                                                                                           AS SORT,
    			 'sapglbilled'                                                                                                                AS Column1,
    			 Cast(FORMAT((SELECT Sum(Cast(Round([Total Amount], 2) AS NUMERIC(38, 2)))
    				   FROM   CTE_318_Billed_Charges_Header_Item)
    				  + ((SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))
    					  FROM   CTE_308_Billed_Adjustments_Header_Item)),'###,###,#00.00') AS NVARCHAR)                                                          AS Column2,
    			 ( Cast(FORMAT(Sum(Cast(Round(Column8, 2) AS NUMERIC(38, 2))),'###,###,#00.00') AS NVARCHAR) )                                                         AS Column3,
    			 Cast(FORMAT(( (SELECT Sum(Cast(Round([Total Amount], 2) AS NUMERIC(38, 2)))
    					 FROM   CTE_318_Billed_Charges_Header_Item)
    					+ ((SELECT Sum(Cast(Round(Amount, 2) AS NUMERIC(38, 2)))
    						FROM   CTE_308_Billed_Adjustments_Header_Item)) ) - ( Sum(Cast(Round(Column8, 2) AS NUMERIC(38, 2))) ),'###,###,#00.00') AS NVARCHAR) AS Column4,
    			 ''                                                                                                                           AS Column5,
    			 ''                                                                                                                           AS Column6,
    			 ''                                                                                                                           AS Column7
    	  -- FROM   sdbTDIR2_Globe.[dbo].[sapglbilled]
    	  FROM   sdbTDIR2_Globe.[dbo].sapglbilled_ssis
    	  WHERE BillCycle = @BillCycle
    
    	)
    	,CTE_tvGlobe_DP1_Billed_Preload_Cycle1RptSel AS
    	(
    	  SELECT TOP(100) percent Data         AS [Data],
    							  Posting_Date AS [Date],
    							  SAPFIGL      AS [Brand],
    							  CT           AS [Customer Type],
    							  ST           AS [Subscriber Type],
    							  CH_Code      AS [Charge Code],
    							  DP_Code      AS [Discount Code],
    							  Amount       AS [Amount],
    							  Hits         AS [Hits],
    							  UOM          AS [UOM],
    							  WO_Ind       AS [WO Indicator],
    							  CC           AS [Cost Center],
    							  ''           AS [GL],
    							  NB_IND       AS [NB Indicator],
    							  Remarks,
    							  CASE
    								WHEN Data <> '01' THEN NULL
    								ELSE zDSP_Order
    							  END          AS zDSP_Order,
    							  zDSP_UniqueKey
    	  FROM   ttGlobe_DP1_Billed
    	  WHERE  zLegacyCycle_Code = @BillCycle
    			 AND ( (select Cast(ISNULL(Replace(Column4, ',', ''), 0) as numeric(38, 2))
    					from   CTE_tvGlobe_DP1_Billed_Control_Recon_Cycle1RptSel
    					where  Column1 = 'sapglbilled') <= 100000.00
    				   AND (select Cast(ISNULL(Replace(Column4, ',', ''), 0) as numeric(38, 2))
    						from   CTE_tvGlobe_DP1_Billed_Control_Recon_Cycle1RptSel
    						where  Column1 = 'sapglbilled') >= -100000.00 )
    			 AND zLoaded = '0'
    
    	)
    
    	,
    	CTE_txGlobe_DP1_Billed_Cycle1LoadFileSel AS (
    
    	  SELECT TOP (100) PERCENT Data              AS Column01,
    							   --CASE
    							   --  WHEN [Date] LIKE '%/%' THEN CONVERT(NVARCHAR, ( Dateadd(d, 1, [Date]) ), 101)
    							   --  ELSE [Date]
    							   --END
    			 [Date]               AS Column02,
    							   [Brand]           AS Column03,
    							   [Customer Type]   AS Column04,
    							   [Subscriber Type] AS Column05,
    							   [Charge Code]     AS Column06,
    							   [Discount Code]   AS Column07,
    							   Amount            AS Column08,
    							   Hits              AS Column09,
    							   UOM               AS Column10,
    							   [WO Indicator]    AS Column11,
    							   [Cost Center]     AS Column12,
    							   [GL]              AS Column13,
    							   [NB Indicator]    AS Column14,
    							   zDSP_Order,
    							   zDSP_UniqueKey
    	  FROM   CTE_tvGlobe_DP1_Billed_Preload_Cycle1RptSel
    	  ORDER  BY Data
    	 )
    
    /*
    	 SELECT
    	 [Column01]
    	 ,[Column02]
    	 ,[Column03]
    	 ,[Column04]
    	 ,[Column05]
    	 ,[Column06]
    	 ,[Column07]
    	 -- ,[etl_db].[dbo].[fn_RemoveDecimalOfZeroChar]([Column08]) AS [Column08]
    	 -- ,[etl_db].[dbo].[fn_RemoveDecimalOfZeroChar]([Column09]) AS [Column09]
    	 ,FORMAT(CAST([Column08] as DECIMAL(18,2)),'0.##') AS [Column08]
    	 -- FORMAT(TRY_PARSE([Column08] as DECIMAL(18,2)),'0.##')
    	 ,CAST(CAST([Column09] as DECIMAL(18,2)) as NVARCHAR(100)) AS [Column09]
    	 ,[Column10]
    	 ,[Column11]
    	 ,[Column12]
    	 ,[Column13]
    	 ,[Column14]
    	 ,zDSP_Order
    	 ,zDSP_UniqueKey
    	 FROM CTE_txGlobe_DP1_Billed_Cycle1LoadFileSel ORDER BY [Column01],zDSP_Order
    */
    
    	 SELECT
    	 [Column01]
    	 ,[Column02]
    	 -- Compute the header based on the details
    	 ,CASE WHEN [Column01] ='99'
    				THEN
    				ISNULL(FORMAT((SELECT  SUM(CAST([Column08] as DECIMAL(18,2))) FROM CTE_txGlobe_DP1_Billed_Cycle1LoadFileSel xx WHERE xx.[Column01] = '01'),'0.##'),[Column03])
    				ELSE [Column03] END  AS [Column03]
    	 ,[Column04]
    	 ,[Column05]
    	 ,[Column06]
    	 ,[Column07]
    	 ,FORMAT(CAST([Column08] as DECIMAL(18,2)),'0.##') AS [Column08]
    	 ,CAST(CAST([Column09] as DECIMAL(18,2)) as NVARCHAR(100)) AS [Column09]
    	 ,[Column10]
    	 ,[Column11]
    	 ,[Column12]
    	 ,[Column13]
    	 ,[Column14]
    	 ,zDSP_Order
    	 ,zDSP_UniqueKey
    	 FROM CTE_txGlobe_DP1_Billed_Cycle1LoadFileSel ORDER BY [Column01],zDSP_Order
    */
    BEGIN
    END;
END;
$procedure$
