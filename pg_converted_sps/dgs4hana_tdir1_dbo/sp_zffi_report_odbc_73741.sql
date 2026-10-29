CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_report_odbc()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_report_odbc;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    INSERT INTO [dbo].[ZFFI_REPORT_ODBC]
               ([MANDT]
               ,[Z_SOURCE_NAME]
               ,[ZDSP_ORDER]
               ,[ZDSP_UNIQUEKEY]
               ,[Z_UPLD_FILENAME]
               ,[Z_LINE_ITEM]
               ,[Z_PROG_NAME]
               ,[Z_MESSAGE]
               ,[Z_DATE]
               ,[Z_TIME]
               ,[Z_USER_ID])
    
    
    
    	SELECT
    	[MANDT]
    	,[Z_SOURCE_NAME]
    	,[ZDSP_ORDER]
    	,[ZDSP_UNIQUEKEY]
    	,[Z_UPLD_FILENAME]
    	,[Z_LINE_ITEM]
    	,[Z_PROG_NAME]
    	,[Z_MESSAGE]
    	,[Z_DATE]
    	,[Z_TIME]
    	,[Z_USER_ID]
    	FROM
    	(
    		SELECT
    				x.[MANDT]
    			   ,x.[Z_SOURCE_NAME]
    			   ,x.[ZDSP_ORDER]
    			   -- ,x.[ZDSP_UNIQUEKEY]
    			   ,rtrim(ltrim(replace(replace(replace(x.[ZDSP_UNIQUEKEY],char(9),' '),char(10),' '),char(13),' '))) as [ZDSP_UNIQUEKEY]
    			   ,x.[Z_UPLD_FILENAME]
    			   ,x.[Z_LINE_ITEM]
    			   ,x.[Z_PROG_NAME]
    			   ,x.[Z_MESSAGE]
    			   ,x.[Z_DATE]
    			   ,x.[Z_TIME]
    			   ,x.[Z_USER_ID]
    			   ,ROW_NUMBER() OVER(PARTITION BY rtrim(ltrim(replace(replace(replace(x.[ZDSP_UNIQUEKEY],char(9),' '),char(10),' '),char(13),' '))),[Z_PROG_NAME],[Z_LINE_ITEM] ORDER BY CONCAT(Z_DATE,Z_TIME) DESC) as Rn
    		FROM OPENQUERY([SAP_S4],'Select "MANDT", "Z_SOURCE_NAME", "ZDSP_ORDER", "ZDSP_UNIQUEKEY", "Z_UPLD_FILENAME", "Z_LINE_ITEM", "Z_PROG_NAME", "Z_MESSAGE", "Z_DATE", "Z_TIME", "Z_USER_ID" From "SAPPRD"."ZFFI_REPORT_ODBC" WHERE CAST("Z_DATE" AS DATE) >= ADD_DAYS(CURRENT_DATE, -90)') x
    	) as xx
    	WHERE xx.Rn = 1
    */
    /*
    SELECT
    			x.[MANDT]
               ,x.[Z_SOURCE_NAME]
               ,x.[ZDSP_ORDER]
               -- ,x.[ZDSP_UNIQUEKEY]
    		   ,rtrim(ltrim(replace(replace(replace(x.[ZDSP_UNIQUEKEY],char(9),' '),char(10),' '),char(13),' ')))
               ,x.[Z_UPLD_FILENAME]
               ,x.[Z_LINE_ITEM]
               ,x.[Z_PROG_NAME]
               ,x.[Z_MESSAGE]
               ,x.[Z_DATE]
               ,x.[Z_TIME]
               ,x.[Z_USER_ID]
    	FROM OPENQUERY([SAP_S4],'Select "MANDT", "Z_SOURCE_NAME", "ZDSP_ORDER", "ZDSP_UNIQUEKEY", "Z_UPLD_FILENAME", "Z_LINE_ITEM", "Z_PROG_NAME", "Z_MESSAGE", "Z_DATE", "Z_TIME", "Z_USER_ID" From "SAPPRD"."ZFFI_REPORT_ODBC" WHERE CAST("Z_DATE" AS DATE) >= ADD_DAYS(CURRENT_DATE, -120)') x;
    */
END;
$procedure$
