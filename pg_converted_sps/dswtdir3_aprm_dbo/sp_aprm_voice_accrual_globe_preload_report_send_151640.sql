CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_report_send()
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
	SELECT 'Accrual_Globe_Preload', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_preload_cache
	UNION ALL
	SELECT 'Accrual_Globe_Preload_Analysis_Per_Partner_Detailed', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_detailed_cache
	UNION ALL
	SELECT 'Accrual_Globe_Preload_Analysis_Per_Partner_SAPvsAUR', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_report_analysis_per_partner_sapvsaur_cache
		UNION ALL
	SELECT 'Accrual_Globe_Preload_Analysis_Per_Partner', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_pregload_report_analysis_per_partner_cache
		UNION ALL
	SELECT 'Accrual_Globe_Preload_Tending_1_SAPvsAUR', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_tending_1_sapvsaur_cache
		UNION ALL
	SELECT 'Accrual_Globe_Preload_VarianceReportvsExtract', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_variancereportvsextract_cache
		UNION ALL
	SELECT 'Accrual_Preload_AmdocsVsBilling', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_voice_accrual_globe_preload_report_amdocsvsbilling_cache;

	
	OPEN cursor_job;
LOOP
  FETCH cursor_job INTO subsid,subsname,recordcount;
  EXIT WHEN NOT FOUND;
subj := 'Report Notif: APRM Voice A ' || subsname || ' - ' || CAST(recordcount AS VARCHAR) || ' Record(s) Generated';
		file := 'F:\BOA\Transform\Report\TDIR3-APRM\APRM_VOICE_SSRS\' || subsname || '.xlsx';
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
-- 			,recipients = 'jsshernandez@globe.com.ph;nfsalvador@globe.com.ph;lrricohermoso@globe.com.ph'
-- 			,copy_recipients = 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'
-- 			,subject = subj
-- 			,body = bodytext
-- 			,body_format = 'HTML'
-- 			,file_attachments = file

		END LOOP;
CLOSE cursor_job;
END;
$procedure$
