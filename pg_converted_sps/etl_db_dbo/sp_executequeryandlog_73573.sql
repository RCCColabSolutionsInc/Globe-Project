CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_executequeryandlog(IN par_process character varying, IN par_processgroup character varying, IN par_actionname character varying, IN par_type character varying, IN par_sqlprocedurename character varying, IN par_commandtext text)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		<Author,,Name> */
/* Create date: <Create Date,,> */
/* Description:	<Description,,> */
/* ============================================= */
DECLARE
    var_sp_name VARCHAR(500);
    var_start_time TIMESTAMP WITHOUT TIME ZONE;
    var_end_time TIMESTAMP WITHOUT TIME ZONE;
    var_Outputs TEXT;
    var_duration_ms INTEGER;
    var_duration_sec DOUBLE PRECISION;
    var_error_message TEXT;
    var_records_affected INTEGER;
    error_catch$ERROR_NUMBER TEXT;
    error_catch$ERROR_SEVERITY TEXT;
    error_catch$ERROR_STATE TEXT;
    error_catch$ERROR_LINE TEXT;
    error_catch$ERROR_PROCEDURE TEXT;
    error_catch$ERROR_MESSAGE TEXT;
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    CREATE TEMPORARY TABLE temp$sp_executequeryandlog
    (message TEXT,
        id BIGINT GENERATED ALWAYS AS IDENTITY);
    var_start_time := clock_timestamp();

    BEGIN
        /*
        [9996 - Severity CRITICAL - Transformer error occurred in executeStatement. Please submit report to developers.]
        EXEC @records_affected = sp_executesql @CommandText;
        */
        /*
        -- INSERT INTO @temp([Message]) EXEC sp_executesql @CommandText;
        
        SELECT @Outputs = COALESCE(@Outputs + 'output:', '') + CAST([Message] AS VARCHAR(MAX))
        FROM @temp x WHERE [Message] IS NOT NULL ORDER BY x.ID
        */
        BEGIN
        END;
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_EXECUTEQUERYANDLOG';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                var_error_message := error_catch$ERROR_MESSAGE;
                DROP TABLE IF EXISTS temp$sp_executequeryandlog;
    END;
    var_end_time := clock_timestamp();
    var_duration_ms := aws_sqlserver_ext.datediff('millisecond', var_start_time::TIMESTAMP, var_end_time::TIMESTAMP);
    var_duration_sec := var_duration_ms / 1000.0;
    INSERT INTO etl_db_dbo.processlogs (process, processgroup, actionname, type, sqlprocedurename, commandtext, startedon, endedon, duration, outputs, errormessage)
    VALUES (par_Process, par_ProcessGroup, par_ActionName, par_Type, par_SqlProcedureName, par_CommandText, var_start_time, var_end_time, var_duration_sec, CAST (var_records_affected AS VARCHAR(500)), var_error_message);

    IF var_error_message IS NOT NULL THEN
        RAISE 'Error %, severity %, state % was raised. Message: %.', '50000', 16,
        /* Severity. */
        1, var_error_message USING ERRCODE = '50000'
        /* Message text. */
        /* State. */
        ;
    END IF;
END;
$procedure$
