CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_tvinnove_dp1_billed_postload_valid_ssrs_pg(IN par_cyclecode character varying DEFAULT NULL::character varying, INOUT p_refcur refcursor DEFAULT NULL::refcursor)
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    var_BCCode VARCHAR(5);
BEGIN
    SELECT
        billcycle
        INTO var_BCCode
        FROM dswtdir2_innove_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
    /* EXEC [dbo].[sp_MyBSS_Globe_EOC_Postload_Report_DP1_Billed_Valid] @BCCode */
    
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT [Column01]
    		  ,[Column02]
    		  ,[Column03]
    		  ,[Column04]
    		  ,[Column05]
    		  ,[Column06]
    		  ,[Column07]
    		 --  ,[Column08]
    		 --  ,[Column09]
    		 ,FORMAT(TRY_PARSE([Column08] as DECIMAL(18,2)),'0.##') as [Column08]
    		,FORMAT(TRY_PARSE([Column09] as DECIMAL(18,2)),'0.##') as [Column09]
    		  ,[Column10]
    		  ,[Column11]
    		  ,[Column12]
    		  ,[Column13]
    		  ,[Column14]
    		  ,[Column15]
    		  ,[Column16]
    		  ,[Column17]
    		  ,[Column18]
    		  ,[Column19]
    		  ,[zDSP_Order]
    		  ,[zDSP_UniqueKey]
    		  ,[Posting_Log_Message]
    	  FROM [dbo].[rpt_Postload_Report_Prepare_DP1_Billed_Valid_Cache]
    	WHERE BillCycle = COALESCE(@BCCode,BillCycle) ORDER BY BillCycle,[Column01],TRY_CAST([zDSP_Order] as INT)
    */
    /* WHERE BillCycle = @BCCode ORDER BY [Column01],TRY_CAST([zDSP_Order] as INT) */
END;
$procedure$
