CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_job_mybss_globe_eom_postload_dp3()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: March 8, 2023 */
/* Description: Procedural MybssEOC processing */
/* ============================================= */
DECLARE
    var_Proccess VARCHAR(300) DEFAULT 'MyBSS';
    var_ProcessGroup VARCHAR(300) DEFAULT 'Globe';
    var_Step VARCHAR(300) DEFAULT 'DP3_Unbilled_Char - Postload';
    var_Others VARCHAR(200) DEFAULT 'EOM';
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Update ODBC */
    CALL dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_000_loadsaptables();
    /* DSP Migrate */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Postload_DP3_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* EXPORT Interface files */
    /* NA */
    
    /* Prepare the report */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Postload_DP3_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Export to excel file */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Postload_DP3_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
    /* Send report */
    var_procedureName := '[dswTDIR2_Globe].[dbo].[sp_MyBSS_Globe_EOM_Postload_DP3_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog(var_Proccess, var_ProcessGroup, var_Step, var_Others, var_procedureName, var_cmd);
END;
$procedure$
