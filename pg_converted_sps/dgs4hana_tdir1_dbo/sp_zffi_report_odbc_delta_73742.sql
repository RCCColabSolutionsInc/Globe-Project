CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    error_catch$ERROR_NUMBER TEXT;
    error_catch$ERROR_SEVERITY TEXT;
    error_catch$ERROR_STATE TEXT;
    error_catch$ERROR_LINE TEXT;
    error_catch$ERROR_PROCEDURE TEXT;
    error_catch$ERROR_MESSAGE TEXT;
    var_ErrMsg VARCHAR(4000);
    var_ErrSeverity INTEGER;
BEGIN
    /*
    [7807 - Severity CRITICAL - PostgreSQL does not support explicit transaction management commands such as BEGIN TRAN, SAVE TRAN in functions. Convert your source code manually.]
    BEGIN TRANSACTION;
    */
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in fromClause. Please submit report to developers.]
    SELECT
      XX.* INTO #Temp
     FROM
     (
      SELECT x.*
      FROM (
       SELECT
        [MANDT]
        ,[Z_SOURCE_NAME]
        ,[ZDSP_ORDER]
        ,rtrim(ltrim(replace(replace(replace(i.[ZDSP_UNIQUEKEY],char(9),' '),char(10),' '),char(13),' '))) AS [ZDSP_UNIQUEKEY]
        ,[Z_UPLD_FILENAME]
        ,[Z_LINE_ITEM]
        ,[Z_PROG_NAME]
        ,[Z_MESSAGE]
        ,[Z_DATE]
        ,[Z_TIME]
        ,[Z_USER_ID]
        ,ROW_NUMBER() OVER(PARTITION BY ZDSP_UNIQUEKEY,[Z_PROG_NAME],[Z_LINE_ITEM] ORDER BY CONCAT(Z_DATE,Z_TIME) DESC) as Rn FROM OPENQUERY([SAP_S4],'Select "MANDT", "Z_SOURCE_NAME", "ZDSP_ORDER", "ZDSP_UNIQUEKEY", "Z_UPLD_FILENAME", "Z_LINE_ITEM", "Z_PROG_NAME", "Z_MESSAGE", "Z_DATE", "Z_TIME", "Z_USER_ID" From "SAPPRD"."ZFFI_REPORT_ODBC" WHERE CAST("Z_DATE" AS DATE) >= ADD_DAYS(CURRENT_DATE, -1)') i
    
       -- current day
       -- ,ROW_NUMBER() OVER(PARTITION BY ZDSP_UNIQUEKEY,[Z_PROG_NAME],[Z_LINE_ITEM] ORDER BY CONCAT(Z_DATE,Z_TIME) DESC) as Rn FROM OPENQUERY([SAP_S4],'Select "MANDT", "Z_SOURCE_NAME", "ZDSP_ORDER", "ZDSP_UNIQUEKEY", "Z_UPLD_FILENAME", "Z_LINE_ITEM", "Z_PROG_NAME", "Z_MESSAGE", "Z_DATE", "Z_TIME", "Z_USER_ID" From "SAPPRD"."ZFFI_REPORT_ODBC" WHERE CAST("Z_DATE" AS DATE) = CURRENT_DATE') i
      ) as x
     ) as xx WHERE Rn=1;
    */
    /*
    AND NOT EXISTS(
     SELECT 1 FROM [ZFFI_REPORT_ODBC] logs
     WHERE
     XX.ZDSP_UNIQUEKEY = logs.ZDSP_UNIQUEKEY
     AND XX.[ZDSP_ORDER] = logs.[ZDSP_ORDER]
    );
    */
    DELETE FROM dgs4hana_tdir1_dbo.zffi_report_odbc AS x
        WHERE EXISTS (SELECT
            1
            FROM t$temp AS y
            WHERE LOWER(y.zdsp_uniquekey) = LOWER(x.zdsp_uniquekey) AND y.zdsp_order = x.zdsp_order::VARCHAR AND y.z_prog_name = x.z_prog_name::VARCHAR);
    INSERT INTO dgs4hana_tdir1_dbo.zffi_report_odbc (mandt, z_source_name, zdsp_order, zdsp_uniquekey, z_upld_filename, z_line_item, z_prog_name, z_message, z_date, z_time, z_user_id)
    SELECT
        mandt, z_source_name, zdsp_order, zdsp_uniquekey, z_upld_filename, z_line_item, z_prog_name, z_message, z_date, z_time, z_user_id
        FROM t$temp;
    /*
    [7615 - Severity CRITICAL - Your code ends a transaction inside a block with exception handlers. Revise your code to move transaction control to the application side and try again.]
    COMMIT TRANSACTION;
    */
    EXCEPTION
        WHEN OTHERS THEN
            error_catch$ERROR_NUMBER := '0';
            error_catch$ERROR_SEVERITY := '0';
            error_catch$ERROR_LINE := '0';
            error_catch$ERROR_PROCEDURE := 'SP_ZFFI_REPORT_ODBC_DELTA';
            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
            ROLLBACK;
            SELECT
                error_catch$ERROR_MESSAGE, error_catch$ERROR_SEVERITY
                INTO var_ErrMsg, var_ErrSeverity;
            RAISE 'Error %, severity %, state % was raised. Message: %.', '50000', var_ErrSeverity, 1, var_ErrMsg USING ERRCODE = '50000';
            /*
            
            DROP TABLE IF EXISTS t$temp;
            */
            /*
            
            Temporary table must be removed before end of the function.
            */
END;
$procedure$
