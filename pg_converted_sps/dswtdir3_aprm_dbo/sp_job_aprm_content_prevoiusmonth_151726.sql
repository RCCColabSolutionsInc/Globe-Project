CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_content_prevoiusmonth()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'APRM Content';
    var_ProcessGroup VARCHAR(300) DEFAULT 'APRM Content';
    var_Step VARCHAR(300) DEFAULT 'PreviousMonth';
    var_Others VARCHAR(200) DEFAULT 'Every 1st day of the month';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    /* TRANSFORM */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Content_PrevoiusMonth_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
END;
$procedure$
