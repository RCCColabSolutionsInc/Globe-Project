CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_rpt_innove_preload_unbilled_char_preload_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT [Column01]
          ,[Column02]
          ,[Column03]
          ,[Column04]
          ,[Column05]
          ,[Column06]
          -- ,FORMAT([Column07],'0.##')   as [Column07]
    	  ,FORMAT(TRY_PARSE([Column07] as DECIMAL(18,2)),'0.##') as [Column07]
    	  ,FORMAT(TRY_PARSE([Column08] as DECIMAL(18,2)),'0.##') as [Column08]
          -- ,[Column08]
          ,[Column09]
          ,[Column10]
          ,[Column11]
          ,[Column12]
          ,[Column13]
          ,[Column14]
          ,[Column15]
          ,[Column16]
          ,[Column17]
          ,[zDSP_Order]
          ,[zDSP_UniqueKey]
      FROM [dbo].[rpt_Preload_Report_Unbilled_Char_Preload_Cache]
      ORDER BY [Column01],TRY_CAST([zDSP_Order] as INT)
    */
    BEGIN
    END;
END;
$procedure$
