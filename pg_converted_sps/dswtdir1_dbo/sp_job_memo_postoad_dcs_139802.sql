CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_postoad_dcs()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'Memo';
    var_ProcessGroup VARCHAR(300) DEFAULT 'All';
    var_Step VARCHAR(300) DEFAULT 'Postload - DCS';
    var_Others VARCHAR(200) DEFAULT 'Daily';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postload_DCS_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postoad_DCS_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postoad_DCS_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postoad_DCS_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    var_procedureName := '[dswTDIR1].[dbo].[sp_Memo_Postoad_DCS_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
END;
$procedure$
