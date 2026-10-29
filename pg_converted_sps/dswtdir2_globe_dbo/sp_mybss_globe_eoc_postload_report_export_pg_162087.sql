CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_report_export_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    rec_job RECORD;
    v_keyword_ssrs VARCHAR(20);
    v_subsid UUID;
    v_subsname VARCHAR(300);
    v_housekeepcmd VARCHAR(1000);
    v_cnt INT;
    v_iteration INT;
BEGIN
-- delete previous
	-- EXEC xp_cmdshell 'del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\*.xlsx'



	SELECT x.Keyword_SSRS INTO v_keyword_ssrs FROM BillCycles x WHERE x.CycleCode = p_cyclecode;

	CREATE TABLE tmp_ds(subname VARCHAR(500));
	INSERT INTO tmp_ds(subname)
	SELECT 'Glob_Billed_Postload_DP1' || v_keyword_ssrs || '_Error'
	UNION ALL
	SELECT 'Glob_Billed_Postload_DP1' || v_keyword_ssrs || '_Valid';
	--e.q. Glob_Billed_Postload_DP1_BC1_C1_Valid


	FOR rec_job IN (
-- *** MANUAL REVIEW NEEDED: SSRS ReportServer catalog DB has no PostgreSQL equivalent - needs external reporting re-architecture ***
SELECT x.SubscriptionID AS subsid, x.Description AS subsname FROM ReportServer$DACPRD.Subscriptions x
	WHERE x.Description IN(SELECT d.subname FROM tmp_ds d)
) LOOP


		-- Delete previous file
		
		v_housekeepcmd := 'del /Q F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\' || rec_job.subsname || '.xlsx';
		-- *** MANUAL REVIEW NEEDED: xp_cmdshell (OS shell exec) has no PostgreSQL equivalent ***
		CALL xp_cmdshell(v_housekeepcmd);

		-- Trigger SSRS export to excel
		-- *** MANUAL REVIEW NEEDED: SSRS ReportServer catalog DB has no PostgreSQL equivalent - needs external reporting re-architecture ***
		CALL ReportServer$DACPRD.AddEvent(EventType => 'TimedSubscription',EventData => rec_job.subsid);

		v_cnt := 0;

		-- *** MANUAL REVIEW NEEDED: SSRS ReportServer catalog DB has no PostgreSQL equivalent - needs external reporting re-architecture ***
		SELECT COUNT(1) INTO v_cnt FROM ReportServer$DACPRD.Event x WHERE x.EventData = rec_job.subsid;

		v_iteration := 1;

		-- Continous checking if the export process is completed. 3 seconds waiting time per iteration.
		-- If it reached 25 iteration and not yet finished then end the process.
		WHILE v_cnt > 0 LOOP
			IF v_iteration = 25 THEN
				RAISE NOTICE '%', ('Breaking - reached maximum iteration.')::text;

				EXIT;
			END IF;

			PERFORM pg_sleep(3);-- wait for 3 seconds for the processing

			-- *** MANUAL REVIEW NEEDED: SSRS ReportServer catalog DB has no PostgreSQL equivalent - needs external reporting re-architecture ***
			SELECT COUNT(1) INTO v_cnt FROM ReportServer$DACPRD.Event x WHERE x.EventData = rec_job.subsid;

			RAISE NOTICE '%', ('Iteration No : ' || CAST(v_iteration AS VARCHAR(20)))::text;

			v_iteration := v_iteration + 1;
		END LOOP;


		
END LOOP;
END;
$procedure$
