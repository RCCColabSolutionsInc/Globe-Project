CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_job_sourcefilescount()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
-- Converted or applied with error!
-- ERROR: duplicate declaration at or near "cursor_job"
--  Position: 792
-- DECLARE
--    var_Keyword_SSRS VARCHAR(20);
--    var_SubsID UUID;
--    var_SubsName VARCHAR(300);
--    cursor_job CURSOR FOR
--    SELECT
--        x.SubscriptionID, x.Description
--        FROM reportserver$dacprd_dbo.subscriptions AS x
--        WHERE x.Description IN (SELECT
--            d.subname
--            FROM t$ds AS d);
--    var_HousekeepCmd VARCHAR(1000);
--    var_Cnt INTEGER;
--    var_Iteration INTEGER;
--    var_SubscriptionID UUID;
--    var_SubscriptionName VARCHAR(300);
--    var_RecordCount INTEGER;
--    var_reportServerLink VARCHAR(500) DEFAULT 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
--    var_PassedCnt INTEGER DEFAULT 0;
--    var_ErrorCnt INTEGER DEFAULT 0;
--    cursor_job CURSOR FOR
--    SELECT DISTINCT
--        x.SubscriptionID, x.Description, recordcount
--        FROM reportserver$dacprd_dbo.subscriptions AS x
--        INNER JOIN t$ds2 AS d
--            ON d.subname = x.Description
--        WHERE d.recordcount > 0;
--    var_Subj VARCHAR(1000);
--    var_File VARCHAR(1000);
--    var_bodyText TEXT;
-- BEGIN
--    /* Export */
--    CREATE TEMPORARY TABLE t$ds
--    (subname VARCHAR(500));
--    INSERT INTO t$ds (subname)
--    SELECT
--        'MemoSourceFiles';
--    OPEN cursor_job;
--    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName;
--
--    WHILE (CASE FOUND::INT
--        WHEN 0 THEN - 1
--        ELSE 0
--    END) = 0 LOOP
--        /* Delete previous file */
--        var_HousekeepCmd := E'del /Q F:\\BOA\\Transform\\Report\\TDIR1-MEMEOAPP_V2\\MEMOAPP_V2_SSRS\\' || var_SubsName || '.xlsx';
--        var_Iteration := 1;
--        var_Cnt := 0;
--        CALL xp_cmdshell(var_HousekeepCmd);
--        /* Trigger SSRS export to excel */
--        CALL reportserver$dacprd_dbo.addevent(par_EventType := 'TimedSubscription', par_EventData := var_SubsID);
--        SELECT
--            COUNT(1)
--            INTO var_Cnt
--            FROM reportserver$dacprd_dbo.event AS x
--            WHERE x.eventdata = var_SubsID;
--        /* Continous checking if the export process is completed. 3 seconds waiting time per iteration. */
--        /* If it reached 100 iteration and not yet finished then end the process. */
--
--        WHILE var_Cnt > 0 LOOP
--            IF var_Iteration = 100 THEN
--                /* 100 = 5 minutes */
--                RAISE NOTICE 'Breaking - reached maximum iteration.';
--                EXIT;
--            END IF;
--            PERFORM aws_sqlserver_ext.waitfor_delay('00:00:03');
--            /* wait for 3 seconds for the processing */
--            SELECT
--                COUNT(1)
--                INTO var_Cnt
--                FROM reportserver$dacprd_dbo.event AS x
--                WHERE x.eventdata = var_SubsID;
--            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20));
--            var_Iteration := (var_Iteration + 1)::INT;
--        END LOOP;
--        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName;
--    END LOOP;
--    CLOSE cursor_job;
--    /* -- End export */
--    /* - Send */
--    CREATE TEMPORARY TABLE t$ds2
--    (subname VARCHAR(500),
--        recordcount INTEGER);
--    INSERT INTO t$ds2 (subname, recordcount)
--    SELECT
--        'MemoSourceFiles', COUNT(1)
--        FROM sdbtdir1_memoapp_dbo.memoapp_source_allproponents;
--    /* WHERE x.[Description] IN (SELECT d.subname FROM #DS2 d WHERE d.recordcount > 0) */
--    OPEN cursor_job;
--    FETCH NEXT FROM cursor_job INTO var_SubscriptionID, var_SubscriptionName, var_RecordCount;
--
--    WHILE (CASE FOUND::INT
--        WHEN 0 THEN - 1
--        ELSE 0
--    END) = 0 LOOP
--        var_Subj := '[SQL Parallel] Report Notif: Memo ' || var_SubscriptionName || ' - ' || CAST (var_RecordCount AS VARCHAR(30)) || ' Record(s) Generated';
--        var_File := E'F:\\BOA\\Transform\\Report\\TDIR1-MEMEOAPP_V2\\MEMOAPP_V2_SSRS\\' || var_SubscriptionName || '.xlsx';
--        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
--        /* wait for 3 seconds for the processing */
--        RAISE NOTICE '%', var_Subj;
--        RAISE NOTICE '%', var_File;
--        var_bodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_SubscriptionName, '</b>" has been successfully generated, with a <b>total of ', CAST (var_RecordCount AS VARCHAR(30)), ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_reportServerLink, '">', var_reportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
--        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'wmadiano@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_bodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text)
--        /* ,@copy_recipients = 'zmbhamlag@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph' */
--        /* ,@recipients = 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph' */
--        /* ,@copy_recipients = 'wmadiano@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph;zmbhamlag@globe.com.ph' */
--        ;
--        FETCH NEXT FROM cursor_job INTO var_SubscriptionID, var_SubscriptionName, var_RecordCount;
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
--    /*
--    
--    DROP TABLE IF EXISTS t$ds2;
--    */
--    /*
--    
--    Temporary table must be removed before end of the function.
--    */
-- END;
END;
$procedure$
