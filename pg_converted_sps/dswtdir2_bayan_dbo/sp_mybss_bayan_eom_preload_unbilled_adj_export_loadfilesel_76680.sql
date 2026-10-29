CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_export_loadfilesel(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the TRY_PARSE function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT [etl_db].[dbo].[fn_CleanTxt]([Column01])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column02])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column03])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column04])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column05])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column06])
    		  ,[etl_db].[dbo].[fn_CleanTxt](CASE WHEN [Column01] = '00' THEN CAST(TRY_PARSE([Column07] AS DECIMAL(18,0)) as NVARCHAR(200)) ELSE CAST(TRY_PARSE([Column07] AS DECIMAL(18,2)) as NVARCHAR(200))  END) AS [Column07]
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column08])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column09])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column10])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column11])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column12])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([Column13])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([zDSP_Order])
    		  ,[etl_db].[dbo].[fn_CleanTxt]([zDSP_UniqueKey])
    	  FROM [dbo].[txBayan_Unbilled_Adj_LoadFileSel]
    	  ORDER BY [Column01],CAST(zDSP_Order as INT)
    */
    BEGIN
    END;
END;
$procedure$
