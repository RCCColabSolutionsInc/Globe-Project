CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_report_prepare_dp1_billed_valid(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
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
    	 WHERE BillCycle = @BillCycle AND Column1 LIKE '%Cycle%'
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
    	 WHERE BillCycle = @BillCycle AND LEN(Column1) = 1
    	 ) Item
    	 ON 1 = 1
    )
    ,CTE_411_Bill_Control_G_Billed_Adjustment
    AS
    (
    	SELECT *
    	FROM sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
    	WHERE BillCycle = @BillCycle AND Column1 IN (
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
    	 FROM sdbTDIR2_Globe.[dbo].[318_Billed_Charges_ssis]
    	 WHERE BillCycle = @BillCycle AND Column1 LIKE '%Cycle%'
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
    	 FROM sdbTDIR2_Globe.[dbo].[318_Billed_Charges_ssis]
    	 WHERE BillCycle = @BillCycle AND LEN(Column1) = 1
    	 ) Item
    	 ON 1 = 1
    )
    
    ,CTE_411_Bill_Control_G_Billed_Charges
    AS
    (
    	SELECT *
    	FROM sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
    	WHERE BillCycle = @BillCycle AND Column1 IN (
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
    
    ,CTE_DP1_Billed_Control_Recon
    AS
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
      FROM   sdbTDIR2_Globe.[dbo].[411_Bill_Control_ssis]
      WHERE BillCycle = @BillCycle AND  ISNULL(Column1, '') <> 'Report Creator : Amdocs BI Team'
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
      FROM   CTE_411_Bill_Control_G_Billed_Adjustment
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
             ''
      FROM   sdbTDIR2_Globe.[dbo].[sapglbilled_ssis]
      WHERE BillCycle = @BillCycle
    )
    
    
    -- Main Select
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
                              ttGlobe_DP1_Billed.zDSP_Order,
    
                              ttGlobe_DP1_Billed.zDSP_UniqueKey,
    
         x.Z_MESSAGE As Posting_Log_Message
    	 INTO #temp
      FROM   ttGlobe_DP1_Billed INNER JOIN [dgS4HANA_TDIR1].[dbo].[vw_ZFFI_REPORT_ODBC_LATESTLOGS] x -- [dgS4HANA_TDIR1].[dbo].vw_RT_ZFFI_REPORT_ODBC x -- ZFFI_REPORT_ODBC_LATESTLOGS
                     ON x.ZDSP_ORDER = ttGlobe_DP1_Billed.zDSP_Order
                        AND x.ZDSP_UNIQUEKEY = ttGlobe_DP1_Billed.zDSP_UniqueKey
      WHERE  zLegacyCycle_Code = @BillCycle
      -- Winds July 15 2022. Changed from CAST to parse. Cast(ISNULL(Column4, 0) as numeric(38, 2))
             AND ( (select ISNULL(parse(ISNULL(Column4, 0) as numeric(38, 2)),0)
                    from   CTE_DP1_Billed_Control_Recon
                    where  Column1 = 'sapglbilled') <= 100000.00
        -- winds July 15 2022. CAST to PARSE. AND (select Cast(ISNULL(Column4, 0) as numeric(38, 2))
                   AND (select ISNULL(parse(ISNULL(Column4, 0) as numeric(38, 2)),0)
                        from   CTE_DP1_Billed_Control_Recon
                        where  Column1 = 'sapglbilled') >= -100000.00 )
             AND zLoaded = '1'
      ORDER  BY Data;
    */
    DELETE FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache
        WHERE LOWER(billcycle) = LOWER(par_BillCycle);
    INSERT INTO dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache (data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", "Discount Code", amount, hits, uom, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message, billcycle)
    SELECT
        data, date, brand, "Customer Type", "Subscriber Type", "Charge Code", "Discount Code", amount, hits, uom, "WO Indicator", "Cost Center", gl, "NB Indicator", remarks, zdsp_order, zdsp_uniquekey, posting_log_message, par_BillCycle
        FROM t$temp;
    /*
    
    DROP TABLE IF EXISTS t$temp;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
