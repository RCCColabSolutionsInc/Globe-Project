CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_prevoiusmonth_notused()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'APRM Voice';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Bayan';
    var_Step VARCHAR(300) DEFAULT 'PrevoiusMonth';
    var_Others VARCHAR(200) DEFAULT 'Every 1st day of the month';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Transform */
    /* Bayan */
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Bayan_PrevoiusMonth_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Innove */
    var_ProcessGroup := 'Innove';
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Innove_PrevoiusMonth_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    /* Globe */
    var_ProcessGroup := 'Globe';
    var_procedureName := '[dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Globe_PrevoiusMonth_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
END;
$procedure$
