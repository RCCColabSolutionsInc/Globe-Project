CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_recon_summary_php_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE  IF NOT EXISTS  t$headerdates
    AS
    WITH qu
    AS (SELECT
        '' AS sort, '' AS description, (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC01') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 1", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC06') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 2", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC08') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 3", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC10') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 4", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC11') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 5", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC13') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 6", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC16') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 7", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC18') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 8", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC21') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 9", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC24') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 10", (SELECT DISTINCT
            column2
            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
            WHERE LOWER(billcycle) = LOWER('BC27') AND LOWER(column2) LIKE LOWER('%/%')) AS "Cycle Code 11", '' AS total)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * 100 / 100);
   
	 CREATE TEMPORARY TABLE  IF NOT EXISTS  t$report_description_layout
    AS
    SELECT
        *
        FROM (SELECT
            1 AS sort, 'Total Previous Balance' AS description
        UNION ALL
        SELECT
            2, 'Total Payments Billed' AS description
        UNION ALL
        SELECT
            3, 'Total Fin Act' AS description
        UNION ALL
        SELECT
            4, 'Total Brought Forward Balance' AS description
        UNION ALL
        SELECT
            5, 'Total Rental' AS description
        UNION ALL
        SELECT
            6, 'Total Handset Financing' AS description
        UNION ALL
        SELECT
            7, 'Total Promotion/Discount' AS description
        UNION ALL
        SELECT
            8, 'Total Traffic Processed' AS description
        UNION ALL
        SELECT
            9, 'TOTAL INT''L ECONOCALL' AS description
        UNION ALL
        SELECT
            10, 'Total VAS Charge' AS description
        UNION ALL
        SELECT
            11, 'Total Free Minutes' AS description
        UNION ALL
        SELECT
            12, 'Total Less Consumable MSF' AS description
        UNION ALL
        SELECT
            13, 'Total Adjustments' AS description
        UNION ALL
        SELECT
            14, 'Total Onetime Charges' AS description
        UNION ALL
        SELECT
            15, 'Total Overseas Communication Tax' AS description
        UNION ALL
        SELECT
            16, 'Total Overseas Tax (ECONOCALL)' AS description
        UNION ALL
        SELECT
            17, 'Total Surcharge' AS description
        UNION ALL
        SELECT
            18, 'Total VAT' AS description
        UNION ALL
        SELECT
            19, 'Total Adjustment VAT' AS description
        UNION ALL
        SELECT
            20, 'Total Number of Accounts' AS description
        UNION ALL
        SELECT
            21, 'Total Current Charges' AS description
        UNION ALL
        SELECT
            22, 'Total Amount Due' AS description) AS xx;

    /* 1. #BayanEOC_Clubbed_Data */
    CREATE TEMPORARY TABLE  IF NOT EXISTS  t$bayaneoc_clubbed_data
    AS
    SELECT
        CAST (x.description AS VARCHAR(200)) AS description, MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC01') THEN column3
        END) AS "Cycle Code 01", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC06') THEN column3
        END) AS "Cycle Code 06", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC08') THEN column3
        END) AS "Cycle Code 08", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC10') THEN column3
        END) AS "Cycle Code 10", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC11') THEN column3
        END) AS "Cycle Code 11", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC13') THEN column3
        END) AS "Cycle Code 13", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC16') THEN column3
        END) AS "Cycle Code 16", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC18') THEN column3
        END) AS "Cycle Code 18", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC21') THEN column3
        END) AS "Cycle Code 21", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC24') THEN column3
        END) AS "Cycle Code 24", MAX(CASE
            WHEN LOWER(billcycle) = LOWER('BC27') THEN column3
        END) AS "Cycle Code 27", MAX(x.sort) AS sort
        FROM t$report_description_layout AS x
        LEFT OUTER JOIN sdbtdir2_bayan_dbo."411_Bill_Control_PHP_ssis" AS y
            ON LOWER(x.description) = LOWER(y.column1)
        GROUP BY x.description;

    CREATE INDEX  IF NOT EXISTS  ix_t$bayaneoc_clubbed_data_sort ON t$bayaneoc_clubbed_data
        (sort);


	/* 2. #318_Billed_Charges_Header_Item */
	CREATE TEMPORARY TABLE  IF NOT EXISTS  t$318_billed_charges_header_item
	AS
	SELECT
	*
	FROM (SELECT
		billcycle AS billcycle_h, MAX(CASE
		WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Code%') THEN column2
		END) AS cycle_code, MAX(CASE
		WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Year%') THEN column2
		END) AS cycle_year, MAX(CASE
		WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Instance%') THEN column2
		END) AS cycle_instance
	FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis"
	WHERE LOWER(column1) LIKE LOWER('%Cycle%')
	GROUP BY billcycle) AS header
	JOIN (SELECT
		billcycle, column1 AS "Customer Type", column2 AS "Customer Sub Type", column3 AS "Subscriber Type", column4 AS "Revenue Type", column5 AS "Charge Code/Tax Code", column6 AS "Charge Type/Tax Type", column7 AS "Discount Plan Code", column8 AS "Total Amount", column9 AS "Document Demand Type", column10 AS "Legal Entity", column11 AS currency, sequencialid
		FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis"
		WHERE LENGTH(column1) = 1) AS item
	ON LOWER(item.billcycle) = LOWER(header.billcycle_h)
	ORDER BY sequencialid NULLS FIRST;

--    /* 3. 308_Billed_Adjustments_Header_Item */
--    CREATE TEMPORARY TABLE IF NOT EXISTS t$308_billed_adjustments_header_item
--    AS
--    SELECT
--        *
--        FROM (SELECT
--            billcycle AS billcycle_h, MAX(CASE
--                WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Code%') THEN column2
--            END) AS cycle_code, MAX(CASE
--                WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Year%') THEN column2
--            END) AS cycle_year, MAX(CASE
--                WHEN LOWER(column1) SIMILAR TO LOWER('%Cycle Instance%') THEN column2
--            END) AS cycle_instance
--            FROM sdbtdir2_bayan_dbo."308_Billed_Adjustments_ssis"
--            WHERE LOWER(column1) LIKE LOWER('%Cycle%')
--            GROUP BY billcycle) AS header
--        JOIN (SELECT
--            billcycle, column1 AS "Customer Type", column2 AS "Customer Sub Type", column3 AS "Subscriber Type", column4 AS "Adjustment Type", column5 AS "Adjustment Code", column6 AS "Adjustment Reason", column7 AS "Legal Entity", column8 AS currency, column9 AS amount, column10 AS "Write-Off Activity Indicator", sequencialid
--            FROM sdbtdir2_bayan_dbo."308_Billed_Adjustments_ssis"
--            WHERE LENGTH(column1) = 1) AS item
--            ON LOWER(header.billcycle_h) = LOWER(item.billcycle)
--        ORDER BY sequencialid NULLS FIRST;
--    /* #BayanEOC_Clubbed_Data_Calculation */
--    CREATE TEMPORARY TABLE t$bayaneoc_clubbed_data_calculation
--    AS
--    SELECT
--        *
--        FROM (SELECT
--            '' AS description, '' AS "Cycle Code 01", '' AS "Cycle Code 06", '' AS "Cycle Code 08", '' AS "Cycle Code 10", '' AS "Cycle Code 11", '' AS "Cycle Code 13", '' AS "Cycle Code 16", '' AS "Cycle Code 18", '' AS "Cycle Code 21", '' AS "Cycle Code 24", '' AS "Cycle Code 27"
--        UNION ALL
--        SELECT
--            '' AS description, CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10))) - (SELECT
--                CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) = LOWER('Total Current Charges')), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data
--            WHERE LOWER(description) IN (LOWER('Total Rental'), LOWER('Total Promotion/Discount'), LOWER('Total Traffic Processed'), LOWER('Total VAS Charge'), LOWER('Total Onetime Charges'), LOWER('Total Overseas Communication Tax'), LOWER('Total Overseas Tax (ECONOCALL)'), LOWER('Total Surcharge'), LOWER('Total VAT'))
--        UNION ALL
--        SELECT
--            'Current Charges' AS description, CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data
--            WHERE LOWER(description) IN (LOWER('Total Rental'), LOWER('Total Promotion/Discount'), LOWER('Total Traffic Processed'), LOWER('Total VAS Charge'), LOWER('Total Onetime Charges'), LOWER('Total Overseas Communication Tax'), LOWER('Total Overseas Tax (ECONOCALL)'), LOWER('Total Surcharge'), LOWER('Total VAT'))
--        UNION ALL
--        SELECT
--            'Current Adjustments' AS description, CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data
--            WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))
--        UNION ALL
--        SELECT
--            'Total Billed' AS description, CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 01", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 06", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 08", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 10", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 11", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 13", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 16", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 18", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 21", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 24", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10))) + (SELECT
--                SUM(CAST (COALESCE("Cycle Code 27", 0) AS NUMERIC(38, 10)))
--                FROM t$bayaneoc_clubbed_data
--                WHERE LOWER(description) IN (LOWER('Total Adjustments'), LOWER('Total Adjustment VAT'))), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data
--            WHERE LOWER(description) IN (LOWER('Total Rental'), LOWER('Total Promotion/Discount'), LOWER('Total Traffic Processed'), LOWER('Total VAS Charge'), LOWER('Total Onetime Charges'), LOWER('Total Overseas Communication Tax'), LOWER('Total Overseas Tax (ECONOCALL)'), LOWER('Total Surcharge'), LOWER('Total VAT'))
--        UNION ALL
--        SELECT
--            '' AS description, '' AS "Cycle Code 01", '' AS "Cycle Code 06", '' AS "Cycle Code 08", '' AS "Cycle Code 10", '' AS "Cycle Code 11", '' AS "Cycle Code 13", '' AS "Cycle Code 16", '' AS "Cycle Code 18", '' AS "Cycle Code 21", '' AS "Cycle Code 24", '' AS "Cycle Code 27"
--        UNION ALL
--        SELECT
--            '' AS description, '1' AS "Cycle Code 01", '6' AS "Cycle Code 06", '8' AS "Cycle Code 08", '10' AS "Cycle Code 10", '11' AS "Cycle Code 11", '13' AS "Cycle Code 13", '16' AS "Cycle Code 16", '18' AS "Cycle Code 18", '21' AS "Cycle Code 21", '24' AS "Cycle Code 24", '27' AS "Cycle Code 27"
--        UNION ALL
--        SELECT
--            'Billed charges report' AS description, CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC01') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC06') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC08') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC10') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC11') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC13') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC16') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC18') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC21') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC24') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC27') THEN CAST ("Total Amount" AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$318_billed_charges_header_item
--            WHERE LOWER(currency) = LOWER('PHP')
--        UNION ALL
--        SELECT
--            'Billed Adj report' AS description, CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC01') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC06') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC08') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC10') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC11') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC13') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC16') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC18') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC21') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC24') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC27') THEN CAST (amount AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$308_billed_adjustments_header_item
--            WHERE LOWER(currency) = LOWER('PHP')
--        UNION ALL
--        SELECT
--            'sapglbilled' AS description, CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC01') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC06') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC08') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC10') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC11') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC13') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC16') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC18') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC21') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC24') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST (ROUND(SUM(CASE
--                WHEN LOWER(billcycle) = LOWER('BC27') THEN CAST (column8 AS NUMERIC(38, 10))
--            END), 2) AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis
--            WHERE LOWER(column12) = LOWER('PHP')) AS a_bayan_eoc_clubbed_data_calculation;

--    /* #BayanEOC_Clubbed_Data_Calculation2 */
--    CREATE TEMPORARY TABLE t$bayaneoc_clubbed_data_calculation2
--    AS
--    SELECT
--        *
--        FROM (SELECT
--            '' AS description, CAST (ROUND(SUM(CAST ("Cycle Code 01" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 01" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 01", CAST (ROUND(SUM(CAST ("Cycle Code 06" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 06" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 06", CAST (ROUND(SUM(CAST ("Cycle Code 08" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 08" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 08", CAST (ROUND(SUM(CAST ("Cycle Code 10" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 10" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 10", CAST (ROUND(SUM(CAST ("Cycle Code 11" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 11" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 11", CAST (ROUND(SUM(CAST ("Cycle Code 13" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 13" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 13", CAST (ROUND(SUM(CAST ("Cycle Code 16" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 16" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 16", CAST (ROUND(SUM(CAST ("Cycle Code 18" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 18" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 18", CAST (ROUND(SUM(CAST ("Cycle Code 21" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 21" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 21", CAST (ROUND(SUM(CAST ("Cycle Code 24" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 24" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 24", CAST (ROUND(SUM(CAST ("Cycle Code 27" AS NUMERIC(38, 10))) - (SELECT
--                CAST ("Cycle Code 27" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data_calculation
--            WHERE LOWER(description) IN (LOWER('Billed charges report'), LOWER('Billed Adj report'))
--        UNION ALL
--        SELECT
--            'Diff in billed charges' AS description, CAST (ROUND(CAST ("Cycle Code 01" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 01" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 01", CAST (ROUND(CAST ("Cycle Code 06" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 06" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 06", CAST (ROUND(CAST ("Cycle Code 08" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 08" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 08", CAST (ROUND(CAST ("Cycle Code 10" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 10" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 10", CAST (ROUND(CAST ("Cycle Code 11" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 11" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 11", CAST (ROUND(CAST ("Cycle Code 13" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 13" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 13", CAST (ROUND(CAST ("Cycle Code 16" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 16" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 16", CAST (ROUND(CAST ("Cycle Code 18" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 18" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 18", CAST (ROUND(CAST ("Cycle Code 21" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 21" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 21", CAST (ROUND(CAST ("Cycle Code 24" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 24" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 24", CAST (ROUND(CAST ("Cycle Code 27" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 27" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed charges report')), 2) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data_calculation
--            WHERE LOWER(description) = LOWER('Current Charges')
--        UNION ALL
--        SELECT
--            'Diff in billed adj' AS description, CAST (ROUND(CAST ("Cycle Code 01" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 01" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 01", CAST (ROUND(CAST ("Cycle Code 06" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 06" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 06", CAST (ROUND(CAST ("Cycle Code 08" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 08" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 08", CAST (ROUND(CAST ("Cycle Code 10" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 10" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 10", CAST (ROUND(CAST ("Cycle Code 11" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 11" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 11", CAST (ROUND(CAST ("Cycle Code 13" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 13" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 13", CAST (ROUND(CAST ("Cycle Code 16" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 16" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 16", CAST (ROUND(CAST ("Cycle Code 18" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 18" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 18", CAST (ROUND(CAST ("Cycle Code 21" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 21" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 21", CAST (ROUND(CAST ("Cycle Code 24" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 24" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 24", CAST (ROUND(CAST ("Cycle Code 27" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 27" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('Billed Adj report')), 2) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data_calculation
--            WHERE LOWER(description) = LOWER('Current Adjustments')
--        UNION ALL
--        SELECT
--            'Diff in sapglbilled' AS description, CAST (ROUND(CAST ("Cycle Code 01" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 01" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 01", CAST (ROUND(CAST ("Cycle Code 06" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 06" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 06", CAST (ROUND(CAST ("Cycle Code 08" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 08" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 08", CAST (ROUND(CAST ("Cycle Code 10" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 10" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 10", CAST (ROUND(CAST ("Cycle Code 11" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 11" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 11", CAST (ROUND(CAST ("Cycle Code 13" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 13" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 13", CAST (ROUND(CAST ("Cycle Code 16" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 16" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 16", CAST (ROUND(CAST ("Cycle Code 18" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 18" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 18", CAST (ROUND(CAST ("Cycle Code 21" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 21" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 21", CAST (ROUND(CAST ("Cycle Code 24" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 24" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 24", CAST (ROUND(CAST ("Cycle Code 27" AS NUMERIC(38, 10)) - (SELECT
--                CAST ("Cycle Code 27" AS NUMERIC(38, 10))
--                FROM t$bayaneoc_clubbed_data_calculation
--                WHERE LOWER(description) = LOWER('sapglbilled')), 2) AS VARCHAR(30)) AS "Cycle Code 27"
--            FROM t$bayaneoc_clubbed_data_calculation
--            WHERE LOWER(description) = LOWER('Total Billed')) AS a_innove_eoc_clubbed_data_calculation;

--    /* FINAL SELECT */
--    OPEN p_refcur FOR
--    SELECT
--        description, "Cycle Code 1", "Cycle Code 2", "Cycle Code 3", "Cycle Code 4", "Cycle Code 5", "Cycle Code 6", "Cycle Code 7", "Cycle Code 8", "Cycle Code 9", "Cycle Code 10", "Cycle Code 11", total
--        FROM t$headerdates
--    UNION ALL
--    SELECT
--        CAST (description AS VARCHAR(50)) AS description, CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 01", CAST (CAST ("Cycle Code 06" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 06", CAST (CAST ("Cycle Code 08" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 08", CAST (CAST ("Cycle Code 10" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 10", CAST (CAST ("Cycle Code 11" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 11", CAST (CAST ("Cycle Code 13" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 13", CAST (CAST ("Cycle Code 16" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 16", CAST (CAST ("Cycle Code 18" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 18", CAST (CAST ("Cycle Code 21" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 21", CAST (CAST ("Cycle Code 24" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 24", CAST (CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30)) AS "Cycle Code 27", CAST ('' AS VARCHAR(50)) AS total
--        FROM t$bayaneoc_clubbed_data
--    UNION ALL
--    SELECT
--        description, "Cycle Code 01", "Cycle Code 06", "Cycle Code 08", "Cycle Code 10", "Cycle Code 11", "Cycle Code 13", "Cycle Code 16", "Cycle Code 18", "Cycle Code 21", "Cycle Code 24", "Cycle Code 27",
--        CASE
--            WHEN LOWER(description) = LOWER('Current Charges') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            WHEN LOWER(description) = LOWER('Current Adjustments') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            WHEN LOWER(description) = LOWER('Billed charges report') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            WHEN LOWER(description) = LOWER('Billed Adj report') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            WHEN LOWER(description) = LOWER('sapglbilled') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            WHEN LOWER(description) = LOWER('Total Billed') THEN CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) + CAST ("Cycle Code 06" AS NUMERIC(38, 2)) + CAST ("Cycle Code 08" AS NUMERIC(38, 2)) + CAST ("Cycle Code 10" AS NUMERIC(38, 2)) + CAST ("Cycle Code 11" AS NUMERIC(38, 2)) + CAST ("Cycle Code 13" AS NUMERIC(38, 2)) + CAST ("Cycle Code 16" AS NUMERIC(38, 2)) + CAST ("Cycle Code 18" AS NUMERIC(38, 2)) + CAST ("Cycle Code 21" AS NUMERIC(38, 2)) + CAST ("Cycle Code 24" AS NUMERIC(38, 2)) + CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--            ELSE ''
--        END AS total
--        FROM t$bayaneoc_clubbed_data_calculation
--    UNION ALL
--    SELECT
--        description,
--        CASE
--            WHEN LOWER("Cycle Code 01") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 01" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 01",
--        CASE
--            WHEN LOWER("Cycle Code 06") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 06" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 06",
--        CASE
--            WHEN LOWER("Cycle Code 08") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 08" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 08",
--        CASE
--            WHEN LOWER("Cycle Code 10") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 10" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 10",
--        CASE
--            WHEN LOWER("Cycle Code 11") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 11" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 11",
--        CASE
--            WHEN LOWER("Cycle Code 13") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 13" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 13",
--        CASE
--            WHEN LOWER("Cycle Code 16") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 16" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 16",
--        CASE
--            WHEN LOWER("Cycle Code 18") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 18" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 18",
--        CASE
--            WHEN LOWER("Cycle Code 21") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 21" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 21",
--        CASE
--            WHEN LOWER("Cycle Code 24") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 24" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 24",
--        CASE
--            WHEN LOWER("Cycle Code 27") = LOWER('0.0000000000') THEN '-'
--            ELSE CAST (CAST ("Cycle Code 27" AS NUMERIC(38, 2)) AS VARCHAR(30))
--        END AS "Cycle Code 27", '' AS total
--        FROM t$bayaneoc_clubbed_data_calculation2;
    /*
    
    DROP TABLE IF EXISTS t$headerdates;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$report_description_layout;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$bayaneoc_clubbed_data;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$318_billed_charges_header_item;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$308_billed_adjustments_header_item;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$bayaneoc_clubbed_data_calculation;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$bayaneoc_clubbed_data_calculation2;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
