CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_send_pg(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$


/* ex: EOC1 to EOC11 */
DECLARE
    var_Keyword_SSRS VARCHAR(20);
    var_BillCycle VARCHAR(20);
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
    SELECT
        x.keyword_ssrs, x.billcycle
        INTO var_Keyword_SSRS, var_BillCycle
        FROM dswtdir2_bayan_dbo.billcycles AS x
        WHERE LOWER(x.cyclecode) = LOWER(par_CycleCode);
    CREATE TEMPORARY TABLE t$ds
    (subname VARCHAR(500),
        recordcount INTEGER);
    INSERT INTO t$ds (subname, recordcount)
    SELECT
        'Bayn_Billed_Preload_DP1' || var_Keyword_SSRS, COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
        WHERE LOWER(billcycle) = LOWER(var_BillCycle) AND LOWER(column01) = LOWER('01')
    UNION ALL
    SELECT
        'Bayn_Billed_Preload_DP1' || var_Keyword_SSRS || '_ChargeCodeMissing', COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    UNION ALL
    SELECT
        'Bayn_Billed_Preload_DP1' || var_Keyword_SSRS || '_SubsTypeMissing', COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_cache
    UNION ALL
    SELECT
        'Bayn_Billed_Recon_Summary_PHP_DP1' || var_Keyword_SSRS, COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache;
    /*
    UNION ALL
    SELECT 'Bayn_Billed_Recon_Summary_USD_DP1'+@Keyword_SSRS, COUNT(1) FROM [rpt_Preload_Report_Prepare_DP1_Billed_ReconSummaryUSD_Cache]
    */
    /* WHERE x.[Description] IN (SELECT d.subname FROM #Ds d WHERE d.recordcount > 0) */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* DECLARE @Subj NVARCHAR(1000) = 'Report Notification: MyBSS - ' + @SubsName + ' as of ' + CONVERT(NVARCHAR,GETDATE(),22); */
        var_Subj := 'Report Notif: MyBSS ' || var_SubsName || ' - ' || CAST (var_RecordCount AS VARCHAR(30)) || ' Record(s) Generated';
        var_File := E'F:\\BOA\\Transform\\Report\\TDIR2-MyBSS\\Bayan\\ttBayan_Billed_SSRS\\' || var_SubsName || '.xlsx';
        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
        /* wait for 3 seconds for the processing */
        RAISE NOTICE '%', var_Subj;
        RAISE NOTICE '%', var_File;
        var_bodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_SubsName, '</b>" has been successfully generated, with a <b>total of ', CAST (var_RecordCount AS VARCHAR(30)), ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_reportServerLink, '">', var_reportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_bodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text)
        /* ,@recipients = 'wmadiano@globe.com.ph' */
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
