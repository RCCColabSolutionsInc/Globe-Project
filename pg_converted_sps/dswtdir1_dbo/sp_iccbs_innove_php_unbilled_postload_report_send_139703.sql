CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_innove_php_unbilled_postload_report_send()
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
    cursor_job CURSOR FOR
    SELECT DISTINCT
        x.SubscriptionID, x.Description, recordcount, d.dynamicsubscriptionpattern
        FROM reportserver$dacprd_dbo.subscriptions AS x
        INNER JOIN t$temptable AS d
            ON d.subscriptionpattern = x.Description
        WHERE d.recordcount > 0;
    var_Subj VARCHAR(1000);
    var_File VARCHAR(1000);
    var_BodyText TEXT;
BEGIN
    /* Declarations */
    /* Declare all the variables used in the script */
    /* Initial Setups */
    /* Set up server link and file directory */
    var_ReportServerLink := 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
    var_FileDirectory := E'F:\\BOA\\Transform\\Report\\TDIR1-ICCBS\\Innove_SSRS';
    /* Set up MonthYearKeyword to previous month in format 'MMyy' */
    
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT @MonthYearKeyword = FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy');
    */
    /* Create and Fill Temp Table */
    /* Create a temporary table for holding data about reports */
    CREATE TEMPORARY TABLE t$temptable
    (subscriptionpattern VARCHAR(500),
        dynamicsubscriptionpattern VARCHAR(500) NULL,
        recordcount INTEGER NULL);
    /* Populate the temporary table with data about reports from different tables */
    INSERT INTO t$temptable (subscriptionpattern, recordcount)
    SELECT
        'Innove_PHP_Unbilled_Postload_Error_MMYY', COUNT(1)
        FROM dswtdir1_dbo.rpt_innove_php_unbilled_postload_report_prepare_postload_error_cache AS x
        WHERE LOWER(x.column01) = LOWER('01')
    UNION ALL
    SELECT
        'Innove_PHP_Unbilled_Postload_Valid_MMYY', COUNT(1)
        FROM dswtdir1_dbo.rpt_innove_php_unbilled_postload_report_prepare_postload_valid_cache AS x
        WHERE LOWER(x.column01) = LOWER('01');
    /* Update Temp Table */
    /* Update the temp table to replace '_MMYY' with actual MonthYearKeyword in subscription patterns */
    UPDATE t$temptable
    SET dynamicsubscriptionpattern = regexp_replace(subscriptionpattern, '_MMYY', '_' || var_MonthYearKeyword, 'gi')
        WHERE LOWER(subscriptionpattern) LIKE LOWER('%_MMYY%');
    /* Create Cursor */
    /* Declare cursor to loop over all reports that have record count more than zero */
    /* Loop through cursor records */
    OPEN cursor_job;
    /* Fetch the first record from the cursor into variables */
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount, var_DynamicSubscriptionName;
    /* Loop until there are records in the cursor */

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Setup email subject and file path variables */
        var_Subj := CONCAT('Report Notif: ICCBS ', var_DynamicSubscriptionName, ' - ', var_RecordCount, ' Record(s) Generated');
        var_BodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_DynamicSubscriptionName, '</b>" has been successfully generated, with a <b>total of ', var_RecordCount, ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_ReportServerLink, '">', var_ReportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
        var_File := CONCAT(var_FileDirectory, E'\\', var_DynamicSubscriptionName, '.xlsx');
        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
        /* Setup email body text */
        /* Send email using msdb.dbo.sp_send_dbmail stored procedure */
        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'harvey.tiong@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;princess.ortilano@globe.com.ph;jpdacquil@globe.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_BodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text)
        /* @recipients = 'wmadiano@globe.com.ph', */
        /* @recipients = 'princess.ortilano@globe.com.ph;harvey.tiong@globe.com.ph', */
        /* @copy_recipients = 'wmadiano@globe.com.ph;', */
        ;
        /* Fetch the next record from the cursor */
        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount, var_DynamicSubscriptionName;
    END LOOP;
    /* Close and deallocate cursor */
    CLOSE cursor_job;
    /*
    
    DROP TABLE IF EXISTS t$temptable;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
