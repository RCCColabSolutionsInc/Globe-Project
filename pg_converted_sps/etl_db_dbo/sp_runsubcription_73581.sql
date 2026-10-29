CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_runsubcription(IN par_jobnameid uuid)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
    [7902 - Severity CRITICAL - PostgreSQL doesn't support functionality similar to SQL Server Agent. Revise your code to use AWS Lambda with scheduled events, and try again.]
    EXEC msdb.dbo.sp_start_job @job_name = @JobNameId
    */
    BEGIN
    END;
END;
$procedure$
