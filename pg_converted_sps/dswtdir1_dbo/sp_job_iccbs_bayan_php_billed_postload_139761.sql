CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_bayan_php_billed_postload()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: July 10, 2023 */
/* ============================================= */
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'ICCBS';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Bayan';
    var_Step VARCHAR(300) DEFAULT 'PHP_Billed - Postload';
    var_Others VARCHAR(200) DEFAULT 'EOM';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Update ODBC */
    
    /* Reload SAP lookup data */
    var_procedureName := '[dswTDIR1].[dbo].[sp_ICCBS_Bayan_PHP_Billed_Postload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* DSP Migrate */
    var_procedureName := '[dswTDIR1].[dbo].[sp_ICCBS_Bayan_PHP_Billed_Postload_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Prepare the report */
    var_procedureName := '[dswTDIR1].[dbo].[sp_ICCBS_Bayan_PHP_Billed_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR1].[dbo].[sp_ICCBS_Bayan_PHP_Billed_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send report */
    var_procedureName := '[dswTDIR1].[dbo].[sp_ICCBS_Bayan_PHP_Billed_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
END;
$procedure$
