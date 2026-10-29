CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_tvinnove_dp1_billed_preload_ssrs_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$

BEGIN
	RAISE NOTICE 'HELLO';
    -- SELECT
    --     billcycle
    --     FROM dswtdir2_innove_dbo.billcycles
    --     WHERE LOWER(cyclecode) = LOWER(par_cyclecode);

	-- SELECT 
	-- 	Column01,
	-- 	Column02,
	-- 	Column03,
	-- 	Column04,
	-- 	Column05,
	-- 	Column06,	
	-- 	Column07,
	-- 	Column08,
	-- 	Column09,	
	-- 	Column10,
	-- 	Column11,
	-- 	Column11,
	-- 	Column12,
	-- 	Column13,
	-- 	Column14,
	-- 	Column15,
	-- 	zDSP_Order,
	--     zDSP_UniqueKey
	-- FROM dswtdir2_innove_dbo.rpt_preload_report_unearned_msf_preload_cache;

    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT [Column01]
          ,[Column02]
          ,[Column03]
          ,[Column04]
          ,[Column05]
          ,[Column06]
          ,[Column07]
    	  -- ,TRY_PARSE([Column08] as FLOAT) as [Column08]
          -- ,TRY_PARSE([Column09] as FLOAT) as [Column09]
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
          ,[BillCycle]
      FROM [dbo].[rpt_Preload_Report_Prepare_DP1_Billed_Preload_Cache]
    	WHERE BillCycle = @BCCode ORDER BY [Column01],TRY_CAST([zDSP_Order] as INT);
    */
    /* EXEC [dbo].[sp_MyBSS_Globe_EOC_Preload_Report_DP1_Billed_Preload] @BCCode */
END;
$procedure$
