CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  cursor_job CURSOR FOR SELECT x.SubscriptionID,x."Description"
	FROM "ReportServer$DACPRD".dbo.Subscriptions x
	WHERE x."Description" IN(SELECT d.subname FROM ds d);
  keyword_ssrs VARCHAR(20);
  subsid UUID;
  subsname VARCHAR(300);
  housekeepcmd VARCHAR(1000);
  cnt INT;
  iteration INT;
BEGIN
DROP TABLE IF EXISTS ds;
CREATE TEMP TABLE ds (
subname VARCHAR(500)
) ON COMMIT DROP;  
	INSERT INTO ds(subname)
	SELECT 'Content A Preload_1st'
	UNION ALL
	SELECT 'Content A Preload_CurrentVsPrior_Month_Comparison_1st'
	UNION ALL
	SELECT 'Content A Preload_Per_Partner_1st'
	UNION ALL
	SELECT 'Content A Preload_Recon_1st';

	
	OPEN cursor_job;
LOOP
  FETCH cursor_job INTO subsid,subsname;
  EXIT WHEN NOT FOUND;
housekeepcmd := 'del /Q F:\BOA\Transform\Report\TDIR3-APRM\APRM_CONTENT_SSRS\'||subsname||'.xlsx';
		-- TODO(migration): xp_cmdshell is SQL-Server-only; no Postgres equivalent.
-- EXEC xp_cmdshell housekeepcmd;

		-- Trigger SSRS export to excel
		-- TODO(migration): SSRS ReportServer call; no Postgres equivalent.
-- EXEC "ReportServer$DACPRD".dbo.AddEvent eventtype = 'TimedSubscription',eventdata = subsid

		cnt := 0;

		SELECT COUNT(1) INTO cnt FROM "ReportServer$DACPRD"."dbo"."Event" x WHERE x."EventData" = subsid;

		iteration := 1;

		-- Continous checking if the export process is completed. 3 seconds waiting time per iteration.
		-- If it reached 25 iteration and not yet finished then end the process.
		WHILE cnt > 0 LOOP

			IF iteration = 25 THEN

				RAISE NOTICE '%', ('Breaking - reached maximum iteration.')::text;

				EXIT;
			END IF;

			PERFORM pg_sleep(3);-- wait for 3 seconds for the processing

			SELECT COUNT(1) INTO cnt FROM "ReportServer$DACPRD"."dbo"."Event" x WHERE x."EventData" = subsid;

			RAISE NOTICE '%', ('Iteration No : ' || CAST(iteration AS VARCHAR(20)))::text;

			iteration := iteration + 1;
		END LOOP;

		END LOOP;
CLOSE cursor_job;
END;
$procedure$
