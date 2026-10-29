CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_job_mybss_bayan_eom_postload_all()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_JobID UUID;
    var_JobName VARCHAR(300);
    var_MaxIteration INTEGER DEFAULT 60;
    cursor_job CURSOR FOR
    SELECT
        x.job_id, x.name
        FROM etl_db_dbo.vw_sqljobs AS x
        INNER JOIN jobs$sp_job_mybss_bayan_eom_postload_all AS j
            ON x.name = j.jobname::VARCHAR
        ORDER BY name NULLS FIRST;
    var_IsCompleted NUMERIC(1, 0);
    var_Iteration INTEGER;
BEGIN
    /* Suppress the count message */
    /* Declare variables */
    /* DECLARE @MaxIteration INT = 24; -- equals 120 seconds or 2 mins */
    /* equals 240 seconds or 5 mins */
    /* Job names we're interested in */
    CREATE TEMPORARY TABLE jobs$sp_job_mybss_bayan_eom_postload_all
    (jobname VARCHAR(100));
    INSERT INTO jobs$sp_job_mybss_bayan_eom_postload_all (jobname)
    VALUES ('MyBSS_Bayan_EOM_DP2_P20_Postload_UMSF_AdHoc'),
    ('MyBSS_Bayan_EOM_DP3_P20_Postload_UC_AdHoc'),
    ('MyBSS_Bayan_EOM_DP4_P20_Postload_UA_AdHoc');
    /* Define the cursor */
    /* Open cursor and process each job */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_JobID, var_JobName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Start the job */
        
        /*
        [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
        EXEC [msdb].[dbo].[sp_start_job] @job_id = @JobID;
        */
        var_Iteration := 1;
        var_IsCompleted := 0;
        RAISE NOTICE '%', 'Executed ' || var_JobName;
        /* Check if job is completed */

        WHILE var_IsCompleted = 0 LOOP
            IF var_Iteration = var_MaxIteration THEN
                RAISE NOTICE 'Breaking - reached maximum iteration.';
                EXIT;
            END IF;
            /* Wait for 5 seconds for processing */
            PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
            /* Check if job is completed */
            SELECT
                etl_db_dbo.fn_isjobcompleted(var_JobName)
                INTO var_IsCompleted;
            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20)) || ' Status: ' || CAST (var_IsCompleted AS VARCHAR(10));
            var_Iteration := (var_Iteration + 1)::INT;
        END LOOP;
        /* Fetch next job */
        FETCH NEXT FROM cursor_job INTO var_JobID, var_JobName;
    END LOOP;
    /* Close and deallocate cursor */
    CLOSE cursor_job;
    DROP TABLE IF EXISTS jobs$sp_job_mybss_bayan_eom_postload_all;
END;
$procedure$
