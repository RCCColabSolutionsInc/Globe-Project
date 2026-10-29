CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_reconusd_p()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    -- ========================================================================
    -- 1. Create Temporary Table: tmp_headerdates
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_headerdates;
    CREATE TEMP TABLE tmp_headerdates ON COMMIT DROP AS
    SELECT 
        ''::VARCHAR AS "SORT",
        ''::VARCHAR AS "DESCRIPTION",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC01' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 1",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC06' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 2",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC08' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 3",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC10' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 4",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC11' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 5",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC13' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 6",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC16' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 7",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC18' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 8",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC21' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 9",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC24' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 10",
        (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC27' AND column2 LIKE '%/%' LIMIT 1) AS "Cycle Code 11",
        ''::VARCHAR AS "TOTAL";

    -- ========================================================================
    -- 2. Create Temporary Table: tmp_report_description_layout
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_report_description_layout;
    CREATE TEMP TABLE tmp_report_description_layout ON COMMIT DROP AS
    SELECT * FROM (
        SELECT 1 AS sort, 'Total Previous Balance'::VARCHAR AS description
        UNION ALL SELECT 2, 'Total Payments Billed'
        UNION ALL SELECT 3, 'Total Fin Act'
        UNION ALL SELECT 4, 'Total Brought Forward Balance'
        UNION ALL SELECT 5, 'Total Rental'
        UNION ALL SELECT 6, 'Total Handset Financing'
        UNION ALL SELECT 7, 'Total Promotion/Discount'
        UNION ALL SELECT 8, 'Total Traffic Processed'
        UNION ALL SELECT 9, 'TOTAL INT''L ECONOCALL'
        UNION ALL SELECT 10, 'Total VAS Charge'
        UNION ALL SELECT 11, 'Total Free Minutes'
        UNION ALL SELECT 12, 'Total Less Consumable MSF'
        UNION ALL SELECT 13, 'Total Adjustments'
        UNION ALL SELECT 14, 'Total Onetime Charges'
        UNION ALL SELECT 15, 'Total Overseas Communication Tax'
        UNION ALL SELECT 16, 'Total Overseas Tax (ECONOCALL)'
        UNION ALL SELECT 17, 'Total Surcharge'
        UNION ALL SELECT 18, 'Total VAT'
        UNION ALL SELECT 19, 'Total Adjustment VAT'
        UNION ALL SELECT 20, 'Total Number of Accounts'
        UNION ALL SELECT 21, 'Total Current Charges'
        UNION ALL SELECT 22, 'Total Amount Due'
    ) AS xx;

    -- ========================================================================
    -- 3. Create Temporary Table: tmp_clubbed_data
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_clubbed_data;
    CREATE TEMP TABLE tmp_clubbed_data ON COMMIT DROP AS
    SELECT
        CAST(x.description AS VARCHAR(200)) AS "DESCRIPTION",
        MAX(CASE WHEN y.billcycle = 'BC01' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 01",
        MAX(CASE WHEN y.billcycle = 'BC06' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 06",
        MAX(CASE WHEN y.billcycle = 'BC08' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 08",
        MAX(CASE WHEN y.billcycle = 'BC10' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 10",
        MAX(CASE WHEN y.billcycle = 'BC11' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 11",
        MAX(CASE WHEN y.billcycle = 'BC13' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 13",
        MAX(CASE WHEN y.billcycle = 'BC16' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 16",
        MAX(CASE WHEN y.billcycle = 'BC18' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 18",
        MAX(CASE WHEN y.billcycle = 'BC21' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 21",
        MAX(CASE WHEN y.billcycle = 'BC24' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 24",
        MAX(CASE WHEN y.billcycle = 'BC27' THEN ROUND(CAST(REPLACE(y.column3, ',', '') AS NUMERIC), 2) END) AS "Cycle Code 27",
        MAX(x.sort) AS sort
    FROM tmp_report_description_layout x
    LEFT JOIN sdbtdir2_bayan_dbo."411_Bill_Control_USD_ssis" y ON x.description = y.column1
    GROUP BY x.description;

    CREATE INDEX idx_sort_usd ON tmp_clubbed_data (sort);

    -- ========================================================================
    -- 4. Create Temporary Table: tmp_318_billed_charges_header_item
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_318_billed_charges_header_item;
    CREATE TEMP TABLE tmp_318_billed_charges_header_item ON COMMIT DROP AS
    SELECT header.*, item.*
    FROM (  
        SELECT
            billcycle AS "BillCycle_H",
            MAX(CASE WHEN column1 LIKE '%Cycle Code%' THEN column2 END) AS "Cycle_Code",  
            MAX(CASE WHEN column1 LIKE '%Cycle Year%' THEN column2 END) AS "Cycle_Year",  
            MAX(CASE WHEN column1 LIKE '%Cycle Instance%' THEN column2 END) AS "Cycle_Instance"  
        FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis"  
        WHERE column1 LIKE '%Cycle%'
        GROUP BY billcycle
    ) header  
    JOIN (  
        SELECT
            billcycle,
            column1 AS "Customer Type",  
            column2 AS "Customer Sub Type",  
            column3 AS "Subscriber Type",  
            column4 AS "Revenue Type",  
            column5 AS "Charge Code/Tax Code",  
            column6 AS "Charge Type/Tax Type",  
            column7 AS "Discount Plan Code",  
            column8 AS "Total Amount",  
            column9 AS "Document Demand Type",  
            column10 AS "Legal Entity",  
            column11 AS "Currency",  
            sequencialid
        FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis"  
        WHERE LENGTH(column1) = 1  
    ) item ON item.billcycle = header."BillCycle_H"
    ORDER BY item.sequencialid;

    -- ========================================================================
    -- 5. Create Temporary Table: tmp_308_billed_adjustments_header_item
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_308_billed_adjustments_header_item;
    CREATE TEMP TABLE tmp_308_billed_adjustments_header_item ON COMMIT DROP AS
    SELECT header.*, item.*
    FROM (  
        SELECT
            billcycle AS "BillCycle_H", 
            MAX(CASE WHEN column1 LIKE '%Cycle Code%' THEN column2 END) AS "Cycle_Code",  
            MAX(CASE WHEN column1 LIKE '%Cycle Year%' THEN column2 END) AS "Cycle_Year",  
            MAX(CASE WHEN column1 LIKE '%Cycle Instance%' THEN column2 END) AS "Cycle_Instance"  
        FROM sdbtdir2_bayan_dbo."308_Billed_Adjustments_ssis"  
        WHERE column1 LIKE '%Cycle%'  
        GROUP BY billcycle
    ) header  
    JOIN (  
        SELECT
            billcycle,
            column1 AS "Customer Type",  
            column2 AS "Customer Sub Type",  
            column3 AS "Subscriber Type",  
            column4 AS "Adjustment Type",  
            column5 AS "Adjustment Code",  
            column6 AS "Adjustment Reason",  
            column7 AS "Legal Entity",  
            column8 AS "Currency",  
            column9 AS "Amount",  
            column10 AS "Write-Off Activity Indicator",
            sequencialid
        FROM sdbtdir2_bayan_dbo."308_Billed_Adjustments_ssis"  
        WHERE LENGTH(column1) = 1  
    ) item ON header."BillCycle_H" = item.billcycle
    ORDER BY item.sequencialid;

    -- ========================================================================
    -- 6. Create Temporary Table: tmp_clubbed_data_calculation
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_clubbed_data_calculation;
    CREATE TEMP TABLE tmp_clubbed_data_calculation ON COMMIT DROP AS
    SELECT * FROM (
        SELECT 
            ''::VARCHAR AS "DESCRIPTION",  
            ''::VARCHAR AS "Cycle Code 01", ''::VARCHAR AS "Cycle Code 06", ''::VARCHAR AS "Cycle Code 08",  
            ''::VARCHAR AS "Cycle Code 10", ''::VARCHAR AS "Cycle Code 11", ''::VARCHAR AS "Cycle Code 13",  
            ''::VARCHAR AS "Cycle Code 16", ''::VARCHAR AS "Cycle Code 18", ''::VARCHAR AS "Cycle Code 21",  
            ''::VARCHAR AS "Cycle Code 24", ''::VARCHAR AS "Cycle Code 27"
        
        UNION ALL  
        
        SELECT 
            '' AS "DESCRIPTION",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data WHERE "DESCRIPTION" = 'Total Current Charges'), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"
        FROM tmp_clubbed_data     
        WHERE "DESCRIPTION" IN (
            'Total Rental', 'Total Promotion/Discount', 'Total Traffic Processed', 'Total VAS Charge', 
            'Total Onetime Charges', 'Total Overseas Communication Tax', 'Total Overseas Tax (ECONOCALL)', 
            'Total Surcharge', 'Total VAT'
        )  
        
        UNION ALL  
        SELECT 'Current Charges' AS "DESCRIPTION",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"   
        FROM tmp_clubbed_data     
        WHERE "DESCRIPTION" IN (
            'Total Rental', 'Total Promotion/Discount', 'Total Traffic Processed', 'Total VAS Charge', 
            'Total Onetime Charges', 'Total Overseas Communication Tax', 'Total Overseas Tax (ECONOCALL)', 
            'Total Surcharge', 'Total VAT'
        )  
  
        UNION ALL  
        SELECT 'Current Adjustments' AS "DESCRIPTION",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06", 
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"   
        FROM tmp_clubbed_data     
        WHERE "DESCRIPTION" IN ('Total Adjustments', 'Total Adjustment VAT')  
        
        UNION ALL  
        SELECT 'Total Billed' AS "DESCRIPTION",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06", 
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",  		
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",  
            CAST(CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))) + (SELECT SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))) FROM tmp_clubbed_data WHERE "DESCRIPTION" IN('Total Adjustments','Total Adjustment VAT')),2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"   
        FROM tmp_clubbed_data     
        WHERE "DESCRIPTION" IN (
            'Total Rental', 'Total Promotion/Discount', 'Total Traffic Processed', 'Total VAS Charge', 
            'Total Onetime Charges', 'Total Overseas Communication Tax', 'Total Overseas Tax (ECONOCALL)', 
            'Total Surcharge', 'Total VAT'
        )  
        
        UNION ALL  
        SELECT '' AS "DESCRIPTION", '' AS "Cycle Code 01", '' AS "Cycle Code 06", '' AS "Cycle Code 08", '' AS "Cycle Code 10", '' AS "Cycle Code 11", '' AS "Cycle Code 13", '' AS "Cycle Code 16", '' AS "Cycle Code 18", '' AS "Cycle Code 21", '' AS "Cycle Code 24", '' AS "Cycle Code 27"  
        
        UNION ALL  
        SELECT '' AS "DESCRIPTION", '1' AS "Cycle Code 01", '6' AS "Cycle Code 06", '8' AS "Cycle Code 08", '10' AS "Cycle Code 10", '11' AS "Cycle Code 11", '13' AS "Cycle Code 13", '16' AS "Cycle Code 16", '18' AS "Cycle Code 18", '21' AS "Cycle Code 21", '24' AS "Cycle Code 24", '27' AS "Cycle Code 27"  

        UNION ALL  
        SELECT 
            'Billed charges report' AS "DESCRIPTION",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC01' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC06' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC08' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC10' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC11' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC13' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC16' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC18' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC21' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC24' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC27' THEN CAST(REPLACE("Total Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"
        FROM tmp_318_billed_charges_header_item
        WHERE "Currency" = 'USD'

        UNION ALL  

        SELECT 
            'Billed Adj report' AS "DESCRIPTION",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC01' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC06' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC08' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC10' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC11' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC13' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC16' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC18' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC21' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC24' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC27' THEN CAST(REPLACE("Amount", ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"
        FROM tmp_308_billed_adjustments_header_item
        WHERE "Currency" = 'USD'
  
        UNION ALL  
        SELECT 
            'sapglbilled' AS "DESCRIPTION",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC01' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC06' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC08' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC10' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC11' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC13' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC16' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC18' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC21' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC24' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",
            CAST(CAST(ROUND(SUM(CASE WHEN billcycle = 'BC27' THEN CAST(REPLACE(column8, ',', '') AS NUMERIC(38,10)) END), 2) AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27"
        FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
        WHERE column12 = 'USD'
    ) AS A_Clubbed_Data_Calculation;

    -- ========================================================================
    -- 7. Create Temporary Table: tmp_clubbed_data_calculation2
    -- ========================================================================
    DROP TABLE IF EXISTS tmp_clubbed_data_calculation2;
    CREATE TEMP TABLE tmp_clubbed_data_calculation2 ON COMMIT DROP AS
    SELECT * FROM (
        SELECT '' AS "DESCRIPTION",
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 01",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 06",
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 08",  		 
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 10",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 11",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 13",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 16",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 18",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 21",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 24",  
            CAST(ROUND(SUM(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10))) - (SELECT CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 27"  
        FROM tmp_clubbed_data_calculation  
        WHERE "DESCRIPTION" IN ('Billed charges report', 'Billed Adj report')  

        UNION ALL  
        SELECT 'Diff in billed charges' AS "DESCRIPTION",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 01",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 06",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 08",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 10",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 11",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 13",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 16",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 18",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 21",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 24",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed charges report'), 2) AS VARCHAR) AS "Cycle Code 27"  
        FROM tmp_clubbed_data_calculation  
        WHERE "DESCRIPTION" = 'Current Charges'  
        
        UNION ALL  
        SELECT 'Diff in billed adj' AS "DESCRIPTION",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 01",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 06",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 08",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 10",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 11",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 13",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 16",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 18",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 21",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 24",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'Billed Adj report'), 2) AS VARCHAR) AS "Cycle Code 27"  
        FROM tmp_clubbed_data_calculation  
        WHERE "DESCRIPTION" = 'Current Adjustments'  
        
        UNION ALL  
        SELECT 'Diff in sapglbilled' AS "DESCRIPTION",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 01",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 06",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 08",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 10",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 11",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 13",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 16",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 18",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 21",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 24",  
            CAST(ROUND(CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) - (SELECT CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38,10)) FROM tmp_clubbed_data_calculation WHERE "DESCRIPTION" = 'sapglbilled'), 2) AS VARCHAR) AS "Cycle Code 27"  
        FROM tmp_clubbed_data_calculation  
        WHERE "DESCRIPTION" = 'Total Billed' 
    ) AS A_Clubbed_Data_Calculation2;

    -- ========================================================================
    -- 8. Insert Final Dataset into Target Table
    -- ========================================================================
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache;
    
    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache
    SELECT * FROM (
        SELECT
            "DESCRIPTION", "Cycle Code 1" AS "Cycle Code 01", "Cycle Code 2" AS "Cycle Code 06", 
            "Cycle Code 3" AS "Cycle Code 08", "Cycle Code 4" AS "Cycle Code 10", 
            "Cycle Code 5" AS "Cycle Code 11", "Cycle Code 6" AS "Cycle Code 13",
            "Cycle Code 7" AS "Cycle Code 16", "Cycle Code 8" AS "Cycle Code 18", 
            "Cycle Code 9" AS "Cycle Code 21", "Cycle Code 10" AS "Cycle Code 24", 
            "Cycle Code 11" AS "Cycle Code 27", "TOTAL"
        FROM tmp_headerdates
        
        UNION ALL
        
        SELECT    
            CAST("DESCRIPTION" AS VARCHAR(50)) AS "DESCRIPTION",  
            CAST(CAST("Cycle Code 01" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 01",  
            CAST(CAST("Cycle Code 06" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 06",  
            CAST(CAST("Cycle Code 08" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 08",  
            CAST(CAST("Cycle Code 10" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 10",  
            CAST(CAST("Cycle Code 11" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 11",  
            CAST(CAST("Cycle Code 13" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 13",  
            CAST(CAST("Cycle Code 16" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 16",  
            CAST(CAST("Cycle Code 18" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 18",  
            CAST(CAST("Cycle Code 21" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 21",  
            CAST(CAST("Cycle Code 24" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 24",  
            CAST(CAST("Cycle Code 27" AS NUMERIC(38,2)) AS VARCHAR) AS "Cycle Code 27",  
            ''::VARCHAR(50) AS "TOTAL"  
        FROM tmp_clubbed_data
  
        UNION ALL  
  
        SELECT "DESCRIPTION",
            "Cycle Code 01", "Cycle Code 06", "Cycle Code 08", "Cycle Code 10", "Cycle Code 11",
            "Cycle Code 13", "Cycle Code 16", "Cycle Code 18", "Cycle Code 21", "Cycle Code 24", "Cycle Code 27",
            CASE 
                WHEN "DESCRIPTION" IN ('Current Charges', 'Current Adjustments', 'Billed charges report', 'Billed Adj report', 'sapglbilled', 'Total Billed')
                    THEN CAST(
                        CAST(COALESCE("Cycle Code 01",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 06",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 08",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 10",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 11",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 13",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 16",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 18",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 21",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 24",'0') AS NUMERIC(38, 2)) + 
                        CAST(COALESCE("Cycle Code 27",'0') AS NUMERIC(38, 2)) 
                    AS VARCHAR)
                ELSE ''
            END AS "TOTAL"
        FROM tmp_clubbed_data_calculation

        UNION ALL  
  
        SELECT "DESCRIPTION",  
            CASE WHEN "Cycle Code 01" = '0.00' OR "Cycle Code 01" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 01" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 01",  
            CASE WHEN "Cycle Code 06" = '0.00' OR "Cycle Code 06" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 06" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 06", 
            CASE WHEN "Cycle Code 08" = '0.00' OR "Cycle Code 08" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 08" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 08", 
            CASE WHEN "Cycle Code 10" = '0.00' OR "Cycle Code 10" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 10" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 10",  
            CASE WHEN "Cycle Code 11" = '0.00' OR "Cycle Code 11" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 11" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 11",  
            CASE WHEN "Cycle Code 13" = '0.00' OR "Cycle Code 13" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 13" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 13",  
            CASE WHEN "Cycle Code 16" = '0.00' OR "Cycle Code 16" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 16" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 16",  
            CASE WHEN "Cycle Code 18" = '0.00' OR "Cycle Code 18" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 18" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 18",  
            CASE WHEN "Cycle Code 21" = '0.00' OR "Cycle Code 21" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 21" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 21",  
            CASE WHEN "Cycle Code 24" = '0.00' OR "Cycle Code 24" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 24" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 24",  
            CASE WHEN "Cycle Code 27" = '0.00' OR "Cycle Code 27" IS NULL THEN '-' ELSE CAST(CAST("Cycle Code 27" AS NUMERIC(38,2)) AS VARCHAR) END AS "Cycle Code 27",  
            '' AS "TOTAL"   
        FROM tmp_clubbed_data_calculation2
    ) AS final_results;

END;
$procedure$
