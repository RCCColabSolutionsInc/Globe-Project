CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_job_mybss_innove_eoc_postload(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: Feb 2 2023 */
/* Description: Procedural MybssEOC processing */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_procedureName VARCHAR(300);
    var_cmd VARCHAR(500);
BEGIN
    /* Load SAP tables */
    var_procedureName := '[dswTDIR2_Innove].[dbo].[sp_MyBSS_Innove_EOC_Postload_LoadSapTables]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Innove', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Transform */
    var_procedureName := '[dswTDIR2_Innove].[dbo].[sp_MyBSS_Innove_EOC_Postload_Transform]';
    var_cmd := 'EXEC ' || var_procedureName;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Innove', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Prepare the report */
    var_procedureName := '[dswTDIR2_Innove].[dbo].[sp_MyBSS_Innove_EOC_Postload_Report_Prepare]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Innove', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Export data excel files. to be sent out as an email attachment later */
    var_procedureName := '[dswTDIR2_Innove].[dbo].[sp_MyBSS_Innove_EOC_Postload_Report_Export]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Innove', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
    /* Send the report */
    var_procedureName := '[dswTDIR2_Innove].[dbo].[sp_MyBSS_Innove_EOC_Postload_Report_Send]';
    var_cmd := 'EXEC ' || var_procedureName || ' ' || par_CycleCode;
    CALL etl_db_dbo.sp_executequeryandlog('MyBSS', 'Innove', 'Billed - Postload', par_CycleCode, var_procedureName, var_cmd);
END;
$procedure$
