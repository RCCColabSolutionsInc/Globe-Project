CREATE OR REPLACE PROCEDURE public.sp_mybss_bayan_eoc_recon_summary_php_ssrs_pg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
  -- 1) HeaderDates
  DROP TABLE IF EXISTS headerdates;

  CREATE TEMP TABLE headerdates AS
  SELECT
    ''::text AS sort,
    ''::text AS description,
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC01' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 1",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC06' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 2",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC08' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 3",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC10' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 4",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC11' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 5",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC13' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 6",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC16' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 7",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC18' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 8",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC21' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 9",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC24' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 10",
    (SELECT column2 FROM (SELECT DISTINCT column2 FROM sdbtdir2_bayan_dbo.sap_glbilled_ssis WHERE billcycle = 'BC27' AND column2 LIKE '%/%') s LIMIT 1) AS "Cycle Code 11",
    ''::text AS total;

  -- 2) Report_Description_Layout
  DROP TABLE IF EXISTS Report_Description_Layout;
  CREATE TEMP TABLE Report_Description_Layout AS
  SELECT * FROM (
    SELECT 1 AS "Sort",'Total Previous Balance' AS "DESCRIPTION"
    UNION ALL SELECT 2, 'Total Payments Billed'
    UNION ALL SELECT 3, 'Total Fin Act'
    UNION ALL SELECT 4,  'Total Brought Forward Balance'
    UNION ALL SELECT 5,  'Total Rental'
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

  -- -- 3) BayanEOC_Clubbed_Data
  -- DROP TABLE IF EXISTS BayanEOC_Clubbed_Data;
  -- CREATE TEMP TABLE BayanEOC_Clubbed_Data AS
  -- SELECT
  --   x."DESCRIPTION"::varchar(200) AS "DESCRIPTION",
  --   MAX(CASE WHEN y."BillCycle" = 'BC01' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 01",
  --   MAX(CASE WHEN y."BillCycle" = 'BC06' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 06",
  --   MAX(CASE WHEN y."BillCycle" = 'BC08' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 08",
  --   MAX(CASE WHEN y."BillCycle" = 'BC10' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 10",
  --   MAX(CASE WHEN y."BillCycle" = 'BC11' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 11",
  --   MAX(CASE WHEN y."BillCycle" = 'BC13' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 13",
  --   MAX(CASE WHEN y."BillCycle" = 'BC16' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 16",
  --   MAX(CASE WHEN y."BillCycle" = 'BC18' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 18",
  --   MAX(CASE WHEN y."BillCycle" = 'BC21' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 21",
  --   MAX(CASE WHEN y."BillCycle" = 'BC24' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 24",
  --   MAX(CASE WHEN y."BillCycle" = 'BC27' THEN ROUND(y."column3"::numeric, 2) END) AS "Cycle Code 27",
  --   MAX(x."Sort") AS "sort"
  -- FROM Report_Description_Layout x
  -- LEFT JOIN sdbtdir2_bayan_dbo."411_Bill_Control_PHP_ssis" y
  --   ON x."DESCRIPTION" = y."Column1"
  -- GROUP BY x."DESCRIPTION";

  -- CREATE INDEX IF NOT EXISTS idx_bayan_eoc_clubbed_data_sort ON "BayanEOC_Clubbed_Data" ("sort");

 --  -- 4) 318_Billed_Charges_Header_Item
 --  DROP TABLE IF EXISTS "318_Billed_Charges_Header_Item";
 --  CREATE TEMP TABLE "318_Billed_Charges_Header_Item" AS
 --  SELECT *
 --  FROM (
 --    SELECT
 --      "BillCycle" AS "BillCycle_H",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Code%' THEN "COLUMN2" END) AS "Cycle_Code",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Year%' THEN "COLUMN2" END) AS "Cycle_Year",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Instance%' THEN "COLUMN2" END) AS "Cycle_Instance"
 --    FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis
 --    WHERE "Column1" LIKE '%Cycle%'
 --    GROUP BY "BillCycle"
 --  ) AS "Header"
 --  JOIN (
 --    SELECT
 --      "BillCycle",
 --      "Column1"  AS "Customer Type",
 --      "Column2"  AS "Customer Sub Type",
 --      "Column3"  AS "Subscriber Type",
 --      "Column4"  AS "Revenue Type",
 --      "Column5"  AS "Charge Code/Tax Code",
 --      "Column6"  AS "Charge Type/Tax Type",
 --      "Column7"  AS "Discount Plan Code",
 --      "Column8"  AS "Total Amount",
 --      "Column9"  AS "Document Demand Type",
 --      "Column10" AS "Legal Entity",
 --      "Column11" AS "Currency",
 --      "SequencialID"
 --    FROM 
	-- DROP TABLE IF EXISTS 318_Billed_Charges_Header_Item;
 --  CREATE TEMP TABLE 318_Billed_Charges_Header_Item AS
 --  SELECT *
 --  FROM (
 --    SELECT
 --      "BillCycle" AS "BillCycle_H",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Code%' THEN "COLUMN2" END) AS "Cycle_Code",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Year%' THEN "COLUMN2" END) AS "Cycle_Year",
 --      MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Instance%' THEN "COLUMN2" END) AS "Cycle_Instance"
 --    FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis
 --    WHERE "Column1" LIKE '%Cycle%'
 --    GROUP BY "BillCycle"
 --  ) AS "Header"
 --  JOIN (
 --  SELECT
 --      BillCycle,
 --      Column1  AS "Customer Type",
 --      Column2  AS "Customer Sub Type",
 --      Column3  AS "Subscriber Type",
 --      Column4  AS "Revenue Type",
 --      Column5  AS "Charge Code/Tax Code",
 --      Column6  AS "Charge Type/Tax Type",
 --      Column7  AS "Discount Plan Code",
 --      Column8  AS "Total Amount",
 --      Column9  AS "Document Demand Type",
 --      Column10 AS "Legal Entity",
 --      Column11 AS "Currency",
 --      SequencialID
 --    FROM sdbtdir2_bayan_dbo."318_Billed_Charges_ssis"
 --    WHERE length(Column1) = 1;
 --  ) AS "Item"
 --    ON "Item"."BillCycle" = "Header"."BillCycle_H"
 --  ORDER BY "SequencialID";

 --    WHERE length("Column1") = 1
 --  ) AS "Item"
 --    ON "Item"."BillCycle" = "Header"."BillCycle_H"
 --  ORDER BY "SequencialID";

  -- -- 5) 308_Billed_Adjustments_Header_Item
  -- DROP TABLE IF EXISTS "308_Billed_Adjustments_Header_Item";
  -- CREATE TEMP TABLE "308_Billed_Adjustments_Header_Item" AS
  -- SELECT *
  -- FROM (
  --   SELECT
  --     "BillCycle" AS "BillCycle_H",
  --     MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Code%' THEN "COLUMN2" END) AS "Cycle_Code",
  --     MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Year%' THEN "COLUMN2" END) AS "Cycle_Year",
  --     MAX(CASE WHEN "COLUMN1" LIKE '%Cycle Instance%' THEN "COLUMN2" END) AS "Cycle_Instance"
  --   FROM sdbtdir2_bayan."308_Billed_Adjustments_ssis"
  --   WHERE "Column1" LIKE '%Cycle%'
  --   GROUP BY "BillCycle"
  -- ) AS "Header"
  -- JOIN (
  --   SELECT
  --     "BillCycle",
  --     "Column1"  AS "Customer Type",
  --     "Column2"  AS "Customer Sub Type",
  --     "Column3"  AS "Subscriber Type",
  --     "Column4"  AS "Adjustment Type",
  --     "Column5"  AS "Adjustment Code",
  --     "Column6"  AS "Adjustment Reason",
  --     "Column7"  AS "Legal Entity",
  --     "Column8"  AS "Currency",
  --     "Column9"  AS "Amount",
  --     "Column10" AS "Write-Off Activity Indicator",
  --     "SequencialID"
  --   FROM sdbtdir2_bayan."308_Billed_Adjustments_ssis"
  --   WHERE length("Column1") = 1
  -- ) AS "Item"
  --   ON "Header"."BillCycle_H" = "Item"."BillCycle"
  -- ORDER BY "SequencialID";

  -- -- 6) BayanEOC_Clubbed_Data_Calculation
  -- DROP TABLE IF EXISTS "BayanEOC_Clubbed_Data_Calculation";
  -- CREATE TEMP TABLE "BayanEOC_Clubbed_Data_Calculation" AS
  -- SELECT * FROM (
  --   SELECT
  --     ''::text AS "DESCRIPTION",
  --     ''::text AS "Cycle Code 01",
  --     ''::text AS "Cycle Code 06",
  --     ''::text AS "Cycle Code 08",
  --     ''::text AS "Cycle Code 10",
  --     ''::text AS "Cycle Code 11",
  --     ''::text AS "Cycle Code 13",
  --     ''::text AS "Cycle Code 16",
  --     ''::text AS "Cycle Code 18",
  --     ''::text AS "Cycle Code 21",
  --     ''::text AS "Cycle Code 24",
  --     ''::text AS "Cycle Code 27"

  --   UNION ALL
  --   SELECT
  --     '' AS "DESCRIPTION",
  --     (ROUND(SUM(COALESCE("Cycle Code 01",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 01",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 06",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 06",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 08",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 08",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 10",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 10",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 11",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 11",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 13",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 13",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 16",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 16",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 18",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 18",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 21",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 21",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 24",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 24",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 27",0)::numeric(38,10)) - (SELECT COALESCE("Cycle Code 27",0)::numeric(38,10) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION"='Total Current Charges'),2)::numeric(38,2))::text
  --   FROM "BayanEOC_Clubbed_Data"
  --   WHERE "DESCRIPTION" IN
  --     ('Total Rental','Total Promotion/Discount','Total Traffic Processed','Total VAS Charge',
  --      'Total Onetime Charges','Total Overseas Communication Tax','Total Overseas Tax (ECONOCALL)',
  --      'Total Surcharge','Total VAT')

  --   UNION ALL
  --   SELECT
  --     'Current Charges' AS "DESCRIPTION",
  --     (ROUND(SUM(COALESCE("Cycle Code 01",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 06",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 08",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 10",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 11",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 13",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 16",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 18",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 21",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 24",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 27",0)::numeric(38,10)),2)::numeric(38,2))::text
  --   FROM "BayanEOC_Clubbed_Data"
  --   WHERE "DESCRIPTION" IN
  --     ('Total Rental','Total Promotion/Discount','Total Traffic Processed','Total VAS Charge',
  --      'Total Onetime Charges','Total Overseas Communication Tax','Total Overseas Tax (ECONOCALL)',
  --      'Total Surcharge','Total VAT')

  --   UNION ALL
  --   SELECT
  --     'Current Adjustments' AS "DESCRIPTION",
  --     (ROUND(SUM(COALESCE("Cycle Code 01",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 06",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 08",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 10",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 11",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 13",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 16",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 18",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 21",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 24",0)::numeric(38,10)),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 27",0)::numeric(38,10)),2)::numeric(38,2))::text
  --   FROM "BayanEOC_Clubbed_Data"
  --   WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')

  --   UNION ALL
  --   SELECT
  --     'Total Billed' AS "DESCRIPTION",
  --     (ROUND(SUM(COALESCE("Cycle Code 01",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 01",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 06",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 06",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 08",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 08",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 10",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 10",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 11",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 11",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 13",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 13",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 16",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 16",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 18",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 18",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 21",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 21",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 24",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 24",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text,
  --     (ROUND(SUM(COALESCE("Cycle Code 27",0)::numeric(38,10)) + (SELECT SUM(COALESCE("Cycle Code 27",0)::numeric(38,10)) FROM "BayanEOC_Clubbed_Data" WHERE "DESCRIPTION" IN ('Total Adjustments','Total Adjustment VAT')),2)::numeric(38,2))::text
  --   FROM "BayanEOC_Clubbed_Data"
  --   WHERE "DESCRIPTION" IN
  --     ('Total Rental','Total Promotion/Discount','Total Traffic Processed','Total VAS Charge',
  --      'Total Onetime Charges','Total Overseas Communication Tax','Total Overseas Tax (ECONOCALL)',
  --      'Total Surcharge','Total VAT')

  --   UNION ALL
  --   SELECT '' AS "DESCRIPTION", '' AS "Cycle Code 01", '' AS "Cycle Code 06", '' AS "Cycle Code 08", '' AS "Cycle Code 10", '' AS "Cycle Code 11",
  --          '' AS "Cycle Code 13", '' AS "Cycle Code 16", '' AS "Cycle Code 18", '' AS "Cycle Code 21", '' AS "Cycle Code 24", '' AS "Cycle Code 27"

  --   UNION ALL
  --   SELECT '' AS "DESCRIPTION",
  --          '1','6','8','10','11','13','16','18','21','24','27'

  --   UNION ALL
  --   SELECT
  --     'Billed charges report' AS "DESCRIPTION",
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC01' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC06' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC08' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC10' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC11' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC13' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC16' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC18' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC21' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC24' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC27' THEN ("Total Amount")::numeric(38,10) END),2)::numeric(38,2))::text
  --   FROM "318_Billed_Charges_Header_Item"
  --   WHERE "Currency"='PHP'

  --   UNION ALL
  --   SELECT
  --     'Billed Adj report' AS "DESCRIPTION",
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC01' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC06' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC08' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC10' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC11' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC13' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC16' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC18' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC21' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC24' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC27' THEN ("Amount")::numeric(38,10) END),2)::numeric(38,2))::text
  --   FROM "308_Billed_Adjustments_Header_Item"
  --   WHERE "Currency"='PHP'

  --   UNION ALL
  --   SELECT
  --     'sapglbilled' AS "DESCRIPTION",
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC01' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC06' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC08' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC10' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC11' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC13' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC16' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC18' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC21' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC24' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text,
  --     (ROUND(SUM(CASE WHEN "BillCycle"='BC27' THEN ("Column8")::numeric(38,10) END),2)::numeric(38,2))::text
  --   FROM sdbtdir2_bayan.sap_glbilled_ssis
  --   WHERE "Column12"='PHP'
  -- ) AS a;

  -- -- 7) BayanEOC_Clubbed_Data_Calculation2
  -- DROP TABLE IF EXISTS "BayanEOC_Clubbed_Data_Calculation2";
  -- CREATE TEMP TABLE "BayanEOC_Clubbed_Data_Calculation2" AS
  -- SELECT * FROM (
  --   SELECT
  --     '' AS "DESCRIPTION",
  --     ROUND(SUM(("Cycle Code 01")::numeric(38,10)) - (SELECT ("Cycle Code 01")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 01",
  --     ROUND(SUM(("Cycle Code 06")::numeric(38,10)) - (SELECT ("Cycle Code 06")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 06",
  --     ROUND(SUM(("Cycle Code 08")::numeric(38,10)) - (SELECT ("Cycle Code 08")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 08",
  --     ROUND(SUM(("Cycle Code 10")::numeric(38,10)) - (SELECT ("Cycle Code 10")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 10",
  --     ROUND(SUM(("Cycle Code 11")::numeric(38,10)) - (SELECT ("Cycle Code 11")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 11",
  --     ROUND(SUM(("Cycle Code 13")::numeric(38,10)) - (SELECT ("Cycle Code 13")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 13",
  --     ROUND(SUM(("Cycle Code 16")::numeric(38,10)) - (SELECT ("Cycle Code 16")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 16",
  --     ROUND(SUM(("Cycle Code 18")::numeric(38,10)) - (SELECT ("Cycle Code 18")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 18",
  --     ROUND(SUM(("Cycle Code 21")::numeric(38,10)) - (SELECT ("Cycle Code 21")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 21",
  --     ROUND(SUM(("Cycle Code 24")::numeric(38,10)) - (SELECT ("Cycle Code 24")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 24",
  --     ROUND(SUM(("Cycle Code 27")::numeric(38,10)) - (SELECT ("Cycle Code 27")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text AS "Cycle Code 27"
  --   FROM "BayanEOC_Clubbed_Data_Calculation"
  --   WHERE "DESCRIPTION" IN ('Billed charges report','Billed Adj report')

  --   UNION ALL
  --   SELECT
  --     'Diff in billed charges' AS "DESCRIPTION",
  --     ROUND(("Cycle Code 01")::numeric(38,10) - (SELECT ("Cycle Code 01")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 06")::numeric(38,10) - (SELECT ("Cycle Code 06")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 08")::numeric(38,10) - (SELECT ("Cycle Code 08")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 10")::numeric(38,10) - (SELECT ("Cycle Code 10")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 11")::numeric(38,10) - (SELECT ("Cycle Code 11")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 13")::numeric(38,10) - (SELECT ("Cycle Code 13")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 16")::numeric(38,10) - (SELECT ("Cycle Code 16")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 18")::numeric(38,10) - (SELECT ("Cycle Code 18")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 21")::numeric(38,10) - (SELECT ("Cycle Code 21")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 24")::numeric(38,10) - (SELECT ("Cycle Code 24")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text,
  --     ROUND(("Cycle Code 27")::numeric(38,10) - (SELECT ("Cycle Code 27")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed charges report'),2)::text
  --   FROM "BayanEOC_Clubbed_Data_Calculation"
  --   WHERE "DESCRIPTION" = 'Current Charges'

  --   UNION ALL
  --   SELECT
  --     'Diff in billed adj' AS "DESCRIPTION",
  --     ROUND(("Cycle Code 01")::numeric(38,10) - (SELECT ("Cycle Code 01")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 06")::numeric(38,10) - (SELECT ("Cycle Code 06")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 08")::numeric(38,10) - (SELECT ("Cycle Code 08")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 10")::numeric(38,10) - (SELECT ("Cycle Code 10")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 11")::numeric(38,10) - (SELECT ("Cycle Code 11")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 13")::numeric(38,10) - (SELECT ("Cycle Code 13")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 16")::numeric(38,10) - (SELECT ("Cycle Code 16")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 18")::numeric(38,10) - (SELECT ("Cycle Code 18")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 21")::numeric(38,10) - (SELECT ("Cycle Code 21")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 24")::numeric(38,10) - (SELECT ("Cycle Code 24")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text,
  --     ROUND(("Cycle Code 27")::numeric(38,10) - (SELECT ("Cycle Code 27")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='Billed Adj report'),2)::text
  --   FROM "BayanEOC_Clubbed_Data_Calculation"
  --   WHERE "DESCRIPTION" = 'Current Adjustments'

  --   UNION ALL
  --   SELECT
  --     'Diff in sapglbilled' AS "DESCRIPTION",
  --     ROUND(("Cycle Code 01")::numeric(38,10) - (SELECT ("Cycle Code 01")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 06")::numeric(38,10) - (SELECT ("Cycle Code 06")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 08")::numeric(38,10) - (SELECT ("Cycle Code 08")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 10")::numeric(38,10) - (SELECT ("Cycle Code 10")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 11")::numeric(38,10) - (SELECT ("Cycle Code 11")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 13")::numeric(38,10) - (SELECT ("Cycle Code 13")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 16")::numeric(38,10) - (SELECT ("Cycle Code 16")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 18")::numeric(38,10) - (SELECT ("Cycle Code 18")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 21")::numeric(38,10) - (SELECT ("Cycle Code 21")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 24")::numeric(38,10) - (SELECT ("Cycle Code 24")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text,
  --     ROUND(("Cycle Code 27")::numeric(38,10) - (SELECT ("Cycle Code 27")::numeric(38,10) FROM "BayanEOC_Clubbed_Data_Calculation" WHERE "DESCRIPTION"='sapglbilled'),2)::text
  --   FROM "BayanEOC_Clubbed_Data_Calculation"
  --   WHERE "DESCRIPTION" = 'Total Billed'
  -- ) AS a2;

  -- Final resultset: in Postgres, procedures don't return rows directly; emit with a cursor-like SELECT.
  -- If you need a callable returning rows, convert to a FUNCTION returning TABLE instead.
  -- DROP TABLE IF EXISTS "Final_Result";
  -- CREATE TEMP TABLE "Final_Result" AS
  -- SELECT
  --   "DESCRIPTION",
  --   "Cycle Code 1","Cycle Code 2","Cycle Code 3","Cycle Code 4","Cycle Code 5",
  --   "Cycle Code 6","Cycle Code 7","Cycle Code 8","Cycle Code 9","Cycle Code 10","Cycle Code 11",
  --   "TOTAL"
  -- FROM HeaderDates
SELECT * FROM Final_Result;
  -- UNION ALL
  -- SELECT
  --   ("DESCRIPTION")::varchar(50) AS "DESCRIPTION",
  --   (("Cycle Code 01")::numeric(38,2))::text AS "Cycle Code 1",
  --   (("Cycle Code 06")::numeric(38,2))::text AS "Cycle Code 2",
  --   (("Cycle Code 08")::numeric(38,2))::text AS "Cycle Code 3",
  --   (("Cycle Code 10")::numeric(38,2))::text AS "Cycle Code 4",
  --   (("Cycle Code 11")::numeric(38,2))::text AS "Cycle Code 5",
  --   (("Cycle Code 13")::numeric(38,2))::text AS "Cycle Code 6",
  --   (("Cycle Code 16")::numeric(38,2))::text AS "Cycle Code 7",
  --   (("Cycle Code 18")::numeric(38,2))::text AS "Cycle Code 8",
  --   (("Cycle Code 21")::numeric(38,2))::text AS "Cycle Code 9",
  --   (("Cycle Code 24")::numeric(38,2))::text AS "Cycle Code 10",
  --   (("Cycle Code 27")::numeric(38,2))::text AS "Cycle Code 11",
  --   ''::varchar(50) AS "TOTAL"
  -- FROM "BayanEOC_Clubbed_Data"

  -- UNION ALL
  -- SELECT
  --   "DESCRIPTION",
  --   "Cycle Code 01" AS "Cycle Code 1",
  --   "Cycle Code 06" AS "Cycle Code 2",
  --   "Cycle Code 08" AS "Cycle Code 3",
  --   "Cycle Code 10" AS "Cycle Code 4",
  --   "Cycle Code 11" AS "Cycle Code 5",
  --   "Cycle Code 13" AS "Cycle Code 6",
  --   "Cycle Code 16" AS "Cycle Code 7",
  --   "Cycle Code 18" AS "Cycle Code 8",
  --   "Cycle Code 21" AS "Cycle Code 9",
  --   "Cycle Code 24" AS "Cycle Code 10",
  --   "Cycle Code 27" AS "Cycle Code 11",
  --   CASE
  --     WHEN "DESCRIPTION" IN ('Current Charges','Current Adjustments','Billed charges report','Billed Adj report','sapglbilled','Total Billed')
  --       THEN (
  --         COALESCE(("Cycle Code 01")::numeric(38,2),0) + COALESCE(("Cycle Code 06")::numeric(38,2),0) + COALESCE(("Cycle Code 08")::numeric(38,2),0) +
  --         COALESCE(("Cycle Code 10")::numeric(38,2),0) + COALESCE(("Cycle Code 11")::numeric(38,2),0) + COALESCE(("Cycle Code 13")::numeric(38,2),0) +
  --         COALESCE(("Cycle Code 16")::numeric(38,2),0) + COALESCE(("Cycle Code 18")::numeric(38,2),0) + COALESCE(("Cycle Code 21")::numeric(38,2),0) +
  --         COALESCE(("Cycle Code 24")::numeric(38,2),0) + COALESCE(("Cycle Code 27")::numeric(38,2),0)
  --       )::text
  --     ELSE ''
  --   END AS "TOTAL"
  -- FROM "BayanEOC_Clubbed_Data_Calculation"

  -- UNION ALL
  -- SELECT
  --   "DESCRIPTION",
  --   CASE WHEN "Cycle Code 01" = '0.0000000000' THEN '-' ELSE (("Cycle Code 01")::numeric(38,2))::text END AS "Cycle Code 1",
  --   CASE WHEN "Cycle Code 06" = '0.0000000000' THEN '-' ELSE (("Cycle Code 06")::numeric(38,2))::text END AS "Cycle Code 2",
  --   CASE WHEN "Cycle Code 08" = '0.0000000000' THEN '-' ELSE (("Cycle Code 08")::numeric(38,2))::text END AS "Cycle Code 3",
  --   CASE WHEN "Cycle Code 10" = '0.0000000000' THEN '-' ELSE (("Cycle Code 10")::numeric(38,2))::text END AS "Cycle Code 4",
  --   CASE WHEN "Cycle Code 11" = '0.0000000000' THEN '-' ELSE (("Cycle Code 11")::numeric(38,2))::text END AS "Cycle Code 5",
  --   CASE WHEN "Cycle Code 13" = '0.0000000000' THEN '-' ELSE (("Cycle Code 13")::numeric(38,2))::text END AS "Cycle Code 6",
  --   CASE WHEN "Cycle Code 16" = '0.0000000000' THEN '-' ELSE (("Cycle Code 16")::numeric(38,2))::text END AS "Cycle Code 7",
  --   CASE WHEN "Cycle Code 18" = '0.0000000000' THEN '-' ELSE (("Cycle Code 18")::numeric(38,2))::text END AS "Cycle Code 8",
  --   CASE WHEN "Cycle Code 21" = '0.0000000000' THEN '-' ELSE (("Cycle Code 21")::numeric(38,2))::text END AS "Cycle Code 9",
  --   CASE WHEN "Cycle Code 24" = '0.0000000000' THEN '-' ELSE (("Cycle Code 24")::numeric(38,2))::text END AS "Cycle Code 10",
  --   CASE WHEN "Cycle Code 27" = '0.0000000000' THEN '-' ELSE (("Cycle Code 27")::numeric(38,2))::text END AS "Cycle Code 11",
  --   ''::text AS "TOTAL"
  -- FROM "BayanEOC_Clubbed_Data_Calculation2;

   -- Emit rows (client will receive this result set)
   -- SELECT * FROM Final_Result;
END;
$procedure$
