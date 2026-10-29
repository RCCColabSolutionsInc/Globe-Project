CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_delta_globe_postload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  proccess VARCHAR(300);
  processgroup VARCHAR(300);
  step VARCHAR(300);
  others VARCHAR(200);
  procedurename VARCHAR(300);
  cmd VARCHAR(500);
BEGIN
proccess := 'APRM Voice';
		processgroup := 'Globe';
		step := 'Delta - Postload';
		others := 'Second Cycle';
		
		
		procedurename := '[dbo].[sp_APRM_Voice_Delta_Globe_Postload_Report_Prepare]';
		cmd := 'EXEC ' || procedurename;
		CALL "etl_db"."dbo"."sp_ExecuteQueryAndLog"(proccess, processgroup, step, others, procedurename, cmd);

		/*Export to excel file*/
		procedurename := '[dbo].[sp_APRM_Voice_Delta_Globe_Postload_Report_Export]';
		cmd := 'EXEC ' || procedurename;
		CALL "etl_db"."dbo"."sp_ExecuteQueryAndLog"(proccess, processgroup, step, others, procedurename, cmd);

		/*Send the reports*/
		procedurename := '[dbo].[sp_APRM_Voice_Delta_Globe_Postload_Report_Send]';
		cmd := 'EXEC ' || procedurename;
		CALL "etl_db"."dbo"."sp_ExecuteQueryAndLog"(proccess, processgroup, step, others, procedurename, cmd

		/*TODO: Send to SAP - c/o boss Norman*/);
END;
$procedure$
