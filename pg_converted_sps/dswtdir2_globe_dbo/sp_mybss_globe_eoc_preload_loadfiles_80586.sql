CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_loadfiles()
 LANGUAGE plpgsql
AS $procedure$
/* Author:		Winston Madiano */
/* Create date: January 18, 2023 */
/* Description: This will execute job and wait for it to complete. This will ensure syncronouse processing */
/* It will check the status every after 3 seconds. */
/* It will stop after 25 attemps and is still not completed */
/* ============================================= */
DECLARE
    var_JobID UUID;
    var_JobName VARCHAR(300);
    cursor_job CURSOR FOR
    SELECT
        x.job_id, x.name
        FROM etl_db_dbo.vw_sqljobs AS x
        WHERE x.name IN ('SSIS_MyBss_Globe_EOC_318_Billed_Charges', 'SSIS_MyBss_Globe_EOC_411_Bill_Control_PHP', 'SSIS_MyBss_Globe_EOC_sapglbilled', 'SSIS_MyBss_Globe_EOC_308_Billed_Adjustments');
    var_Completed NUMERIC(1, 0);
    var_Iteration INTEGER;
BEGIN
    /* PRELOAD REPORTS */
    /* Loop from the table and process based on conditions */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_JobID, var_JobName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /*
        [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
        EXEC [msdb].[dbo].[sp_start_job] @job_id = @JobID
        */
        var_Iteration := 1;
        var_Completed := 0;
        RAISE NOTICE '%', 'Executed ' || var_JobName;

        WHILE var_Completed = 0 LOOP
            IF var_Iteration = 25 THEN
                RAISE NOTICE 'Breaking - reached maximum iteration.';
                EXIT;
            END IF;
            PERFORM aws_sqlserver_ext.waitfor_delay('00:00:03');
            /* wait for 3 seconds for the processing */
            SELECT
                etl_db_dbo.fn_isjobcompleted(var_JobName)
                INTO var_Completed;
            /* check if job is completed */
            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20)) || ' Status: ' || CAST (var_Completed AS VARCHAR(10));
            var_Iteration := (var_Iteration + 1)::INT;
        END LOOP;
        FETCH NEXT FROM cursor_job INTO var_JobID, var_JobName;
    END LOOP;
    CLOSE cursor_job;
END;
$procedure$
