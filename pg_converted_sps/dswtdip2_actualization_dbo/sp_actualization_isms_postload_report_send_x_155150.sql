CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_postload_report_send_x()
 LANGUAGE plpgsql
AS $procedure$
--DECLARE
--    var_SubsID UUID;
--    var_SubsName VARCHAR(300);
--    var_RecordCount INTEGER;
--    var_reportServerLink VARCHAR(500) DEFAULT 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
--    cursor_job CURSOR FOR
--    SELECT DISTINCT
--        x.SubscriptionID, x.Description, recordcount
--        FROM reportserver$dacprd_dbo.subscriptions AS x
--        INNER JOIN t$ds AS d
--            ON d.subname = x.Description
--        WHERE d.recordcount > 0;
--    var_Subj VARCHAR(1000);
--    var_File VARCHAR(1000);
--    var_bodyText TEXT;
BEGIN
	RAISE NOTICE 'END PROCESS';
--    CREATE TEMPORARY TABLE t$ds
--    (subname VARCHAR(500),
--        recordcount INTEGER);
--    INSERT INTO t$ds (subname, recordcount)
--    SELECT
--        'Act_ISMS_Postload_IB_OB_PostControl', COUNT(1)
--        FROM dswtdip2_actualization_dbo.actualization_isms_postload_report_prepare_ib_ob_postcontrol_cache
--    UNION ALL
--    SELECT
--        'Act_ISMS_Postload_Sum_IB_OB_PostControl', COUNT(1)
--        FROM dswtdip2_actualization_dbo.actualization_isms_postload_report_prepare_summary_ib_ob_postcontrol_cache
--    UNION ALL
--    SELECT
--        'Act_ISMS_Postload_OpenBal', COUNT(1)
--        FROM dswtdip2_actualization_dbo.actualization_isms_postload_report_prepare_openbal_cache;
--    /* WHERE x.[Description] IN (SELECT d.subname FROM #Ds d WHERE d.recordcount > 0) */
--    OPEN cursor_job;
--    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;
--
--    WHILE (CASE FOUND::INT
--        WHEN 0 THEN - 1
--        ELSE 0
--    END) = 0 LOOP
--        var_Subj := 'Report Notif: ISMS Actualization ' || var_SubsName || ' - ' || CAST (var_RecordCount AS VARCHAR(30)) || ' Record(s) Generated';
--        var_File := E'F:\\BOA\\Transform\\Report\\TDIP2-Actualization\\ISMS\\' || var_SubsName || '.xlsx';
--        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
--        /* wait for 3 seconds for the processing */
--        RAISE NOTICE '%', var_Subj;
--        RAISE NOTICE '%', var_File;
--        var_bodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_SubsName, '</b>" has been successfully generated, with a <b>total of ', CAST (var_RecordCount AS VARCHAR(30)), ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_reportServerLink, '">', var_reportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
--        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'rnvillar@globe.com.ph;jenerose.dominguez@globe.com.ph;jan.candelaria@globe.com.ph'::text, par_copy_recipients := 'rosoldevilla@globe.com.ph;wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_bodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text)
--        /* ,@recipients = 'wmadiano@globe.com.ph' */
--        /* ,@recipients = 'rnvillar@globe.com.ph' */
--        /* ,@copy_recipients = 'wmadiano@globe.com.ph' */
--        /* ,@copy_recipients = 'zmbhamlag@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph' */
--        ;
--        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;
--    END LOOP;
--    CLOSE cursor_job;
--    /*
--    
--    DROP TABLE IF EXISTS t$ds;
--    */
--    /*
--    
--    Temporary table must be removed before end of the function.
--    */
END;
$procedure$
