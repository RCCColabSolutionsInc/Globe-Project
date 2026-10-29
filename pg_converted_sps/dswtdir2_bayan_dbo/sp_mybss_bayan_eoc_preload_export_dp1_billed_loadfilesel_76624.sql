CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_export_dp1_billed_loadfilesel(IN par_billcycle character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE t$temp_tvbayan_billed_preload_cyclerptsel
    AS
    WITH qu
    AS (SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19,
        CASE
            WHEN LOWER(column01) <> LOWER('01') THEN NULL
            ELSE zdsp_order
        END AS zdsp_order, zdsp_uniquekey
        FROM dswtdir2_bayan_dbo.ttbayan_billed
        WHERE LOWER(zlegacycycle_code) = LOWER(par_BillCycle)
        ORDER BY column01 NULLS FIRST)
    SELECT
        *
        FROM qu
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);

    IF LOWER(par_BillCycle) = LOWER('BC01') THEN
        /*
        [9996 - Severity CRITICAL - Transformer error occurred in parenthesizedExpression. Please submit report to developers.]
        Select TOP (100) PERCENT LF.*
        	FROM   (Select TOP (100) PERCENT Column01,
        									CASE
        										WHEN Column02 like '%/%' then CONVERT(NVARCHAR, ( Dateadd(d, 1, Column02) ), 101)
        										else Column02
        									END AS Column02,
        									Column03,
        									Column04,
        									Column05,
        									Column06,
        									Column07,
        									Column08,
        									Column09,
        									-- FORMAT(TRY_PARSE([Column08] as DECIMAL(18,2)),'0.##') as [Column08],
        									-- FORMAT(TRY_PARSE([Column09] as DECIMAL(18,2)),'0.##') as [Column09],
        									Column10,
        									Column11,
        									Column12,
        									Column13,
        									Column14,
        									Column15,
        							Column16,
        							Column17,
        							Column18,
        							Column19,
        									zDSP_Order,
        									zDSP_UniqueKey
        			FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        			Where  Column01 <> '99'
        			UNION ALL
        			Select TOP (100) PERCENT Column01,
        									(select Cast(Count(Column01) AS NVARCHAR)
        									FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        									where  Column01 = '01')                      AS Column02,
        									(select Cast(Sum(Cast(Column08 AS numeric(20, 2))) AS NVARCHAR)
        									FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel) AS Column03,
        									Column04,
        									Column05,
        									Column06,
        									Column07,
        									Column08,
        									Column09,
        									Column10,
        									Column11,
        									Column12,
        									Column13,
        									Column14,
        									Column15,
        							Column16,
        							Column17,
        							Column18,
        							Column19,
        									zDSP_Order,
        									zDSP_UniqueKey
        			FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        			Where  Column01 = '99') LF
        	Order  by LF.Column01
        */
        BEGIN
        END;
    ELSE
        /*
        [9996 - Severity CRITICAL - Transformer error occurred in parenthesizedExpression. Please submit report to developers.]
        Select TOP (100) PERCENT LF.*
        	FROM   (Select TOP (100) PERCENT Column01,
        									Column02,
        									Column03,
        									Column04,
        									Column05,
        									Column06,
        									Column07,
        									Column08,
        									Column09,
        									-- FORMAT(TRY_PARSE([Column08] as DECIMAL(18,2)),'0.##') as [Column08],
        									-- FORMAT(TRY_PARSE([Column09] as DECIMAL(18,2)),'0.##') as [Column09],
        									Column10,
        									Column11,
        									Column12,
        									Column13,
        									Column14,
        									Column15,
        							Column16,
        							Column17,
        							Column18,
        							Column19,
        									zDSP_Order,
        									zDSP_UniqueKey
        			FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        			Where  Column01 <> '99'
        			UNION ALL
        			Select TOP (100) PERCENT Column01,
        									(select Cast(Count(Column01) AS NVARCHAR)
        									FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        									where  Column01 = '01')                      AS Column02,
        									(select Cast(Sum(Cast(Column08 AS numeric(20, 2))) AS NVARCHAR)
        									FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel) AS Column03,
        									Column04,
        									Column05,
        									Column06,
        									Column07,
        									Column08,
        									Column09,
        									Column10,
        									Column11,
        									Column12,
        									Column13,
        									Column14,
        									Column15,
        							Column16,
        							Column17,
        							Column18,
        							Column19,
        									zDSP_Order,
        									zDSP_UniqueKey
        			FROM   #Temp_tvBayan_Billed_Preload_CycleRptSel
        			Where  Column01 = '99') LF
        	Order  by LF.Column01,LF.zDSP_Order
        */
        BEGIN
        END;
    END IF;
    /*
    
    DROP TABLE IF EXISTS t$temp_tvbayan_billed_preload_cyclerptsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
