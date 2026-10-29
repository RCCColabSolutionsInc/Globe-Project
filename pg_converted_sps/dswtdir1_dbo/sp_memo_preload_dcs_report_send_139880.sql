CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_report_send()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_SubsID UUID;
    var_SubsName VARCHAR(300);
    var_RecordCount INTEGER;
    var_reportServerLink VARCHAR(500) DEFAULT 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
    cursor_job CURSOR FOR
    SELECT DISTINCT
        x.SubscriptionID, x.Description, recordcount
        FROM reportserver$dacprd_dbo.subscriptions AS x
        INNER JOIN t$ds AS d
            ON d.subname = x.Description
        WHERE d.recordcount > 0;
    var_Subj VARCHAR(1000);
    var_File VARCHAR(1000);
    var_bodyText TEXT;
BEGIN
    CREATE TEMPORARY TABLE t$ds
    (subname VARCHAR(500),
        recordcount INTEGER);
    INSERT INTO t$ds (subname, recordcount)
    SELECT
        'Preload_DCS_Scenario_1To6_Approved', COUNT(1)
        FROM dswtdir1_dbo.memo_preload_dcs_report_prepare_02_scn01to06_approved_cache;
    /*
    UNION ALL
    SELECT 'Preload_DCS_Scenario_1To6_Submitted', COUNT(1) FROM [Memo_Preload_DCS_Report_Prepare_03_Scn01To06_Submitted_Cache]
    */
    /* WHERE x.[Description] IN (SELECT d.subname FROM #Ds d WHERE d.recordcount > 0) */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        var_Subj := 'Report Notif: Memo RFP ' || var_SubsName || ' - ' || CAST (var_RecordCount AS VARCHAR(30)) || ' Record(s) Generated';
        var_File := E'F:\\BOA\\Transform\\Report\\TDIR1-MEMEOAPP_V2\\MEMOAPP_V2_SSRS\\' || var_SubsName || '.xlsx';
        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
        /* wait for 3 seconds for the processing */
        RAISE NOTICE '%', var_Subj;
        RAISE NOTICE '%', var_File;
        var_bodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_SubsName, '</b>" has been successfully generated, with a <b>total of ', CAST (var_RecordCount AS VARCHAR(30)), ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_reportServerLink, '">', var_reportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph;jsshernandez@globe.com.ph;emmerioles@globe.com.ph;michelle.oliveras@gsupport.com.ph;paula.villafranca@gsupport.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_bodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text)
        /* ,@recipients = 'wmadiano@globe.com.ph' */
        /* ,@copy_recipients = 'zmbhamlag@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph' */
        /* ,@recipients = 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph' */
        /* ,@copy_recipients = 'wmadiano@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph;zmbhamlag@globe.com.ph' */
        ;
        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;
    END LOOP;
    CLOSE cursor_job;
    /*
    
    DROP TABLE IF EXISTS t$ds;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
