CREATE OR REPLACE PROCEDURE sdbtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_prepare_dp1_billed_control_re(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    -- 1. Clear the cache table for the current bill cycle
    DELETE FROM sdbtdir2_globe_dbo.rpt_preload_report_dp1_billed_control_recon_cache
    WHERE LOWER(billcycle) = LOWER(par_billcycle);

    -- 2. Direct INSERT using CTEs
    INSERT INTO sdbtdir2_globe_dbo.rpt_preload_report_dp1_billed_control_recon_cache 
        (sort, column1, column2, column3, column4, column5, column6, column7, billcycle)
    WITH
    CTE_308_Billed_Adjustments_Header_Item AS
    (
        SELECT *
        FROM (
            SELECT MAX(CASE WHEN column1 LIKE '%Cycle Code%' THEN column2 END) AS "Cycle_Code",
                   MAX(CASE WHEN column1 LIKE '%Cycle Year%' THEN column2 END) AS "Cycle_Year",
                   MAX(CASE WHEN column1 LIKE '%Cycle Instance%' THEN column2 END) AS "Cycle_Instance"
            FROM sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis"
            WHERE billcycle = par_billcycle AND column1 LIKE '%Cycle%'
        ) Header
        JOIN (
            SELECT column1 AS "Customer Type",
                   column2 AS "Customer Sub Type",
                   column3 AS "Subscriber Type",
                   column4 AS "Adjustment Type",
                   column5 AS "Adjustment Code",
                   column6 AS "Adjustment Reason",
                   column7 AS "Legal Entity",
                   column8 AS "Currency",
                   column9 AS "Amount",
                   column10 AS "Write-Off Activity Indicator"
            FROM sdbtdir2_globe_dbo."308_Billed_Adjustments_ssis"
            WHERE billcycle = par_billcycle AND LENGTH(column1) = 1
        ) Item ON 1 = 1
    ),
    CTE_411_Bill_Control_G_Billed_Adjustment AS
    (
        SELECT *
        FROM sdbtdir2_globe_dbo."411_Bill_Control_ssis"
        WHERE billcycle = par_billcycle 
          AND column1 IN ('Total Adjustments', 'Total Adjustment VAT')
    ),
    CTE_318_Billed_Charges_Header_Item AS
    (
        SELECT *
        FROM (
            SELECT MAX(CASE WHEN column1 LIKE '%Cycle Code%' THEN column2 END) AS "Cycle_Code",
                   MAX(CASE WHEN column1 LIKE '%Cycle Year%' THEN column2 END) AS "Cycle_Year",
                   MAX(CASE WHEN column1 LIKE '%Cycle Instance%' THEN column2 END) AS "Cycle_Instance"
            FROM sdbtdir2_globe_dbo."318_Billed_Charges_ssis"
            WHERE billcycle = par_billcycle AND column1 LIKE '%Cycle%'
        ) Header
        JOIN (
            SELECT column1 AS "Customer Type",
                   column2 AS "Customer Sub Type",
                   column3 AS "Subscriber Type",
                   column4 AS "Revenue Type",
                   column5 AS "Charge Code/Tax Code",
                   column6 AS "Charge Type/Tax Type",
                   column7 AS "Discount Plan Code",
                   column8 AS "Total Amount",
                   column9 AS "Document Demand Type",
                   column10 AS "Legal Entity",
                   column11 AS "Currency"
            FROM sdbtdir2_globe_dbo."318_Billed_Charges_ssis"
            WHERE billcycle = par_billcycle AND LENGTH(column1) = 1
        ) Item ON 1 = 1
    ),
    CTE_411_Bill_Control_G_Billed_Charges AS
    (
        SELECT *
        FROM sdbtdir2_globe_dbo."411_Bill_Control_ssis"
        WHERE billcycle = par_billcycle 
          AND column1 IN (
              'Total Rental',
              'Total Promotion/Discount',
              'Total Traffic Processed',
              'Total VAS Charge',
              'Total Onetime Charges',
              'Total Overseas Communication Tax',
              'Total Overseas Tax (ECONOCALL)',
              'Total Surcharge',
              'Total VAT'
          )
    ),
    CTE_411_Bill_Control_G AS
    (
        -- Main Selection
        SELECT '' AS sort,
               column1,
               CASE WHEN column2 ~ '^-?[0-9]' 
                    THEN TO_CHAR(ROUND(CAST(NULLIF(REPLACE(column2, ',', ''), '') AS NUMERIC), 2), 'FM999,999,990.00')
                    ELSE column2 END AS column2,
               CASE WHEN column3 ~ '^-?[0-9]' 
                    THEN TO_CHAR(ROUND(CAST(NULLIF(REPLACE(column3, ',', ''), '') AS NUMERIC), 2), 'FM999,999,990.00')
                    ELSE column3 END AS column3,
               CASE WHEN column4 ~ '^-?[0-9]' 
                    THEN TO_CHAR(ROUND(CAST(NULLIF(REPLACE(column4, ',', ''), '') AS NUMERIC), 2), 'FM999,999,990.00')
                    ELSE column4 END AS column4,
               CASE WHEN column5 ~ '^-?[0-9]' 
                    THEN CAST(ROUND(CAST(NULLIF(REPLACE(column5, ',', ''), '') AS NUMERIC), 2) * 100 AS VARCHAR) || '%'
                    ELSE column5 END AS column5,
               column6,
               column7
        FROM sdbtdir2_globe_dbo."411_Bill_Control_ssis"
        WHERE billcycle = par_billcycle 
          AND COALESCE(column1, '') <> 'Report Creator : Amdocs BI Team'
        
        UNION ALL
        
        SELECT '' AS sort, 'Reconciliation' AS column1, '' AS column2, '' AS column3, '' AS column4, '' AS column5, '' AS column6, '' AS column7
        
        UNION ALL
        
        SELECT '' AS sort, '' AS column1, '' AS column2, 'Report' AS column3, 'Difference' AS column4, '' AS column5, '' AS column6, '' AS column7
        
        UNION ALL
        
        -- Billed Charges Aggregation
        SELECT '' AS sort,
               'Billed Charges' AS column1,
               TO_CHAR(SUM(ROUND(CAST(NULLIF(REPLACE(column3, ',', ''), '') AS NUMERIC), 2)), 'FM999,999,990.00') AS column2,
               (SELECT TO_CHAR(SUM(ROUND(CAST(NULLIF(REPLACE("Total Amount", ',', ''), '') AS NUMERIC), 2)), 'FM999,999,990.00') 
                FROM CTE_318_Billed_Charges_Header_Item) AS column3,
               TO_CHAR(COALESCE(SUM(ROUND(CAST(NULLIF(REPLACE(column3, ',', ''), '') AS NUMERIC), 2)), 0) - 
                      COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Total Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_318_Billed_Charges_Header_Item), 0), 
                      'FM999,999,990.00') AS column4,
               '' AS column5, '' AS column6, '' AS column7
        FROM CTE_411_Bill_Control_G_Billed_Charges
        
        UNION ALL
        
        -- Billed Adjustment Aggregation
        SELECT '' AS sort,
               'Billed Adjustment' AS column1,
               TO_CHAR(SUM(ROUND(CAST(NULLIF(REPLACE(column3, ',', ''), '') AS NUMERIC), 2)), 'FM999,999,990.00') AS column2,
               (SELECT TO_CHAR(SUM(ROUND(CAST(NULLIF(REPLACE("Amount", ',', ''), '') AS NUMERIC), 2)), 'FM999,999,990.00') 
                FROM CTE_308_Billed_Adjustments_Header_Item) AS column3,
               TO_CHAR(COALESCE(SUM(ROUND(CAST(NULLIF(REPLACE(column3, ',', ''), '') AS NUMERIC), 2)), 0) - 
                      COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_308_Billed_Adjustments_Header_Item), 0), 
                      'FM999,999,990.00') AS column4,
               '' AS column5, '' AS column6, '' AS column7
        FROM CTE_411_Bill_Control_G_Billed_Adjustment
        
        UNION ALL
        
        -- sapglbilled Aggregation
        SELECT '' AS sort,
               'sapglbilled' AS column1,
               TO_CHAR(COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Total Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_318_Billed_Charges_Header_Item), 0) +
                       COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_308_Billed_Adjustments_Header_Item), 0), 
                       'FM999,999,990.00') AS column2,
               TO_CHAR(SUM(ROUND(CAST(NULLIF(REPLACE(column8, ',', ''), '') AS NUMERIC), 2)), 'FM999,999,990.00') AS column3,
               TO_CHAR((COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Total Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_318_Billed_Charges_Header_Item), 0) +
                        COALESCE((SELECT SUM(ROUND(CAST(NULLIF(REPLACE("Amount", ',', ''), '') AS NUMERIC), 2)) FROM CTE_308_Billed_Adjustments_Header_Item), 0)) - 
                        COALESCE(SUM(ROUND(CAST(NULLIF(REPLACE(column8, ',', ''), '') AS NUMERIC), 2)), 0), 
                        'FM999,999,990.00') AS column4,
               '' AS column5, '' AS column6, '' AS column7
        FROM sdbtdir2_globe_dbo.sapglbilled_ssis
        WHERE billcycle = par_billcycle
    )
    SELECT sort, column1, column2, column3, column4, column5, column6, column7, par_billcycle
    FROM CTE_411_Bill_Control_G;

END;
$procedure$
