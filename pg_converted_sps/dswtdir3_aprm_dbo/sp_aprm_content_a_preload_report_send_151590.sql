CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_send()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  cursor_job CURSOR FOR SELECT DISTINCT x.SubscriptionID,x."Description",recordcount
	FROM "ReportServer$DACPRD".dbo.Subscriptions x
	INNER JOIN ds d ON d.subname = x."Description"
	WHERE d.recordcount > 0;
  subsid UUID;
  subsname VARCHAR(300);
  recordcount INT;
  reportserverlink VARCHAR(500);
  subj VARCHAR(1000);
  file VARCHAR(1000);
  bodytext TEXT;
BEGIN
reportserverlink := 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';

	DROP TABLE IF EXISTS ds;
CREATE TEMP TABLE ds (
subname VARCHAR(500),recordcount INT
) ON COMMIT DROP;  

	INSERT INTO ds(subname,recordcount)
	SELECT 'Content A Preload_1st', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_1st_cache
	UNION ALL
	SELECT 'Content A Preload_CurrentVsPrior_Month_Comparison_1st', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_currentvsprior_month_comparison_1st_cache
	UNION ALL
	SELECT 'Content A Preload_Per_Partner_1st', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_per_partner1st_cache
	UNION ALL
	SELECT 'Content A Preload_Recon_1st', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_recon_report_1st_cache;

	
	OPEN cursor_job;
LOOP
  FETCH cursor_job INTO subsid,subsname,recordcount;
  EXIT WHEN NOT FOUND;
subj := 'Report Notif: APRM ' || subsname || ' - ' || CAST(recordcount AS VARCHAR) || ' Record(s) Generated';
		file := 'F:\BOA\Transform\Report\TDIR3-APRM\APRM_CONTENT_SSRS\' || subsname || '.xlsx';
		PERFORM pg_sleep(5);-- wait for 3 seconds for the processing
		RAISE NOTICE '%', (subj)::text;

		RAISE NOTICE '%', (file)::text;

		
		bodytext := CONCAT('Greetings,<br><br>',
								'This automated message serves as a notification that the report "<b>', subsname,
								'</b>" has been successfully generated, with a <b>total of ', CAST(recordcount AS VARCHAR),
								' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
								'This report can also be accessed via our secure report server, available at this link: <a href="', reportserverlink, '">', reportserverlink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>',
								'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>',
								'Thank You');

		-- TODO(migration): sp_send_dbmail is SQL-Server-only; no Postgres equivalent.
-- EXEC msdb.dbo.sp_send_dbmail
-- 			profile_name = 'SSRS'
-- 			-- ,recipients = 'wmadiano@globe.com.ph'
-- 			,recipients = 'nfsalvador@globe.com.ph;jsshernandez@globe.com.ph;lrricohermoso@globe.com.ph'
-- 			,copy_recipients = 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'
-- 			,subject = subj
-- 			,body = bodytext
-- 			,body_format = 'HTML'
-- 			,file_attachments = file

		END LOOP;
CLOSE cursor_job;
END;
$procedure$
