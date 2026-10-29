CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_report_send_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    rec_job RECORD;
    v_keyword_ssrs VARCHAR(20);
    v_billcycle VARCHAR(20);
    v_subsid UUID;
    v_subsname VARCHAR(300);
    v_recordcount INT;
    v_reportserverlink VARCHAR(500);
    v_subj VARCHAR(1000);
    v_file VARCHAR(1000);
    v_bodytext TEXT;
BEGIN
v_reportserverlink := 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';


	SELECT x.Keyword_SSRS, x.BillCycle INTO v_keyword_ssrs, v_billcycle FROM BillCycles x WHERE x.CycleCode = p_cyclecode;


	CREATE TABLE tmp_ds(subname VARCHAR(500),recordcount INT);

	INSERT INTO tmp_ds(subname,recordcount)
	SELECT 'Glob_Billed_Preload_DP1' || v_keyword_ssrs, COUNT(1) FROM rpt_Preload_Report_DP1_Billed_Preload_Cache WHERE BillCycle = v_billcycle AND Data ='01'
	UNION ALL
	SELECT 'Glob_Billed_ManualReport_DP1' || v_keyword_ssrs, COUNT(1) FROM rpt_Preload_Report_DP1_Billed_ManualReport_Cache WHERE BillCycle = v_billcycle
	UNION ALL
	SELECT 'Glob_Billed_Control_Recon_DP1' || v_keyword_ssrs, COUNT(1) FROM rpt_Preload_Report_DP1_Billed_Control_Recon_Cache WHERE BillCycle = v_billcycle;





	FOR rec_job IN (
-- *** MANUAL REVIEW NEEDED: SSRS ReportServer catalog DB has no PostgreSQL equivalent - needs external reporting re-architecture ***
SELECT DISTINCT x.SubscriptionID AS subsid, x.Description AS subsname, recordcount AS recordcount FROM ReportServer$DACPRD.Subscriptions x
	INNER JOIN tmp_ds d ON d.subname = x.Description
	WHERE d.recordcount > 0
) LOOP


		-- DECLARE @Subj NVARCHAR(1000) = 'Report Notification: MyBSS - ' + @SubsName + ' as of ' + CONVERT(NVARCHAR,GETDATE(),22);
		v_subj := 'Report Notif: MyBSS ' || rec_job.subsname || ' - ' || CAST(rec_job.recordcount AS TEXT) || ' Record(s) Generated';
		v_file := 'F:\BOA\Transform\Report\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_SSRS\' || rec_job.subsname || '.xlsx';
		PERFORM pg_sleep(5);-- wait for 3 seconds for the processing
		RAISE NOTICE '%', (v_subj)::text;

		RAISE NOTICE '%', (v_file)::text;

		
		v_bodytext := CONCAT('Greetings,<br><br>',
								'This automated message serves as a notification that the report "<b>', rec_job.subsname,
								'</b>" has been successfully generated, with a <b>total of ', CAST(rec_job.recordcount AS TEXT),
								' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
								'This report can also be accessed via our secure report server, available at this link: <a href="', v_reportserverlink, '">', v_reportserverlink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>',
								'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>',
								'Thank You');


		-- *** MANUAL REVIEW NEEDED: msdb (SQL Server Agent) has no PostgreSQL equivalent - use pg_cron / external scheduler ***
		CALL msdb.sp_send_dbmail(profile_name => 'SSRS' ,recipients => 'rosoldevilla@globe.com.ph;rnvillar@globe.com.ph' ,copy_recipients => 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph' ,subject => v_subj ,body => v_bodytext ,body_format => 'HTML' ,file_attachments => v_file);

		
END LOOP;
END;
$procedure$
