CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_job_mybss_bayan_eom_postload_unbilled_adj()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 28, 2023 */
/* Description: Procedural Mybss EOM */
/* ============================================= */
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'MyBSS';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Bayan';
    var_Step VARCHAR(300) DEFAULT 'Unbilled_Adj - Postload';
    var_Others VARCHAR(200) DEFAULT 'EOM';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support SET NOCOUNT OFF statements. Revise your code to use another way to send message back to the application and try again.]
    SET NOCOUNT OFF;
    */
    /* Load SAP loolup tables */
    CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eom_postload_000_loadsaptables();
    /* TRANSFORM */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Prepate the reports - cache */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send the reports */
    var_procedureName := '[dswTDIR2_Bayan].[dbo].[sp_MyBSS_Bayan_EOM_Postload_Unbilled_Adj_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
END;
$procedure$
