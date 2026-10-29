CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_postload_unbilled_char_report_send_pg()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Keyword_SSRS VARCHAR(20);
    var_SubsID UUID;
    var_SubsName VARCHAR(300);
    var_DynamicSubscriptionName VARCHAR(200);
    var_RecordCount INTEGER;
    var_ReportServerLink VARCHAR(500);
    var_FileDirectory VARCHAR(1000);
    var_MonthYearKeyword VARCHAR(20);
    var_Subj VARCHAR(1000);
    var_File VARCHAR(1000);
    var_BodyText TEXT;

    cursor_job CURSOR FOR
        SELECT DISTINCT
            x.SubscriptionID, x.Description, recordcount, d.dynamicsubscriptionpattern
        FROM reportserver$dacprd_dbo.subscriptions AS x
        INNER JOIN t$temptable AS d
            ON d.subscriptionpattern = x.Description
        WHERE d.recordcount > 0;
BEGIN
    /* Declarations */
    var_ReportServerLink := 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
    var_FileDirectory := E'F:\\BOA\\Transform\\Report\\TDIR2-MyBSS\\Innove\\ttInnove_Unbilled_Char_SSRS';

    /* Set up MonthYearKeyword to previous month in format 'MMyy' */
    SELECT TO_CHAR((CURRENT_DATE - INTERVAL '1 month'), 'MMYY') INTO var_MonthYearKeyword;

    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT @MonthYearKeyword = FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy');
    */

    /* Create and Fill Temp Table */
    CREATE TEMPORARY TABLE t$temptable
    (subscriptionpattern VARCHAR(500),
        dynamicsubscriptionpattern VARCHAR(500) NULL,
        recordcount INTEGER NULL);

    INSERT INTO t$temptable (subscriptionpattern, recordcount)
    SELECT 'Inov_UC_Postload_DP3_MMYY_Error', COUNT(*) 
      FROM dswtdir2_innove_dbo.rpt_postload_report_unbilled_char_error_cache
    UNION ALL
    SELECT 'Inov_UC_Postload_DP3_MMYY_Valid', COUNT(*) 
      FROM dswtdir2_innove_dbo.rpt_postload_report_unbilled_char_valid_cache;

    UPDATE t$temptable
    SET dynamicsubscriptionpattern = regexp_replace(subscriptionpattern, '_MMYY', '_' || var_MonthYearKeyword, 'gi')
    WHERE subscriptionpattern ILIKE '%_MMYY%';

    /* Cursor loop */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount, var_DynamicSubscriptionName;

    WHILE FOUND LOOP
        var_Subj := CONCAT('Report Notif: MyBSS ', var_DynamicSubscriptionName, ' - ', var_RecordCount, ' Record(s) Generated');
        var_BodyText := CONCAT(
            'Greetings,<br><br>',
            'This automated message serves as a notification that the report "<b>', var_DynamicSubscriptionName, '</b>" has been successfully generated, with a <b>total of ', var_RecordCount, ' record(s)</b>. ',
            'You will find this report attached to this email for your convenience.<br><br>',
            'This report can also be accessed via our secure report server, available at this link: <a href="', var_ReportServerLink, '">', var_ReportServerLink, '</a>. ',
            'Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>',
            'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>',
            'Thank You'
        );
        var_File := CONCAT(var_FileDirectory, E'\\', var_DynamicSubscriptionName, '.xlsx');

        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');

        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(
            par_profile_name := 'SSRS',
            par_recipients := 'harvey.tiong@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;princess.ortilano@globe.com.ph;jpdacquil@globe.com.ph',
            par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            par_subject := var_Subj,
            par_body := var_BodyText,
            par_body_format := 'HTML',
            par_file_attachments := var_File
        );

        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount, var_DynamicSubscriptionName;
    END LOOP;

    CLOSE cursor_job;

    /*
    DROP TABLE IF EXISTS t$temptable;
    */
    /*
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
