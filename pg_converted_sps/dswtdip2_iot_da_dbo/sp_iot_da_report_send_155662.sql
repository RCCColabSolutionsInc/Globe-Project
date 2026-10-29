CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_report_send()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_SubsID UUID;
    var_SubsName VARCHAR(300);
    var_RecordCount INTEGER;
    var_reportServerLink VARCHAR(500) DEFAULT 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
    cursor_job CURSOR FOR
    SELECT DISTINCT
        x.subsid, x.subname, x.recordcount
        FROM t$ds AS x;
    var_Subj VARCHAR(1000);
    var_File VARCHAR(1000);
    var_bodyText TEXT;
BEGIN
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in columnConstraint. Please submit report to developers.]
    CREATE TABLE #DS(subsid uniqueidentifier default newsequentialid(),subname NVARCHAR(500) COLLATE Latin1_General_CI_AS_KS_WS,recordcount INT)
    */
    INSERT INTO t$ds (subname, recordcount)
    SELECT
        x."File name", 1
        FROM dswtdip2_iot_da_dbo.vw_rpt_preload_params AS x;
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_RecordCount;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        var_Subj := 'Report Notif: ' || var_SubsName || ' - ' || CAST (var_RecordCount AS VARCHAR(30)) || ' Record(s) Generated';
        var_File := E'F:\\BOA\\Transform\\Report\\TDIP2-IOT_DA_SSRS\\' || var_SubsName || '.xlsx';
        PERFORM aws_sqlserver_ext.waitfor_delay('00:00:05');
        /* wait for 3 seconds for the processing */
        RAISE NOTICE '%', var_Subj;
        RAISE NOTICE '%', var_File;
        var_bodyText := CONCAT('Greetings,<br><br>', 'This automated message serves as a notification that the report "<b>', var_SubsName, '</b>" has been successfully generated, with a <b>total of ', CAST (var_RecordCount AS VARCHAR(30)), ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>', 'This report can also be accessed via our secure report server, available at this link: <a href="', var_reportServerLink, '">', var_reportServerLink, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>', 'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>', 'Thank You');
        PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := 'SSRS'::character varying, par_recipients := 'lcdotimas@globe.com.ph;jenerose.dominguez@globe.com.ph;rosoldevilla@globe.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph'::text, par_subject := var_Subj::character varying, par_body := var_bodyText::text, par_body_format := 'HTML'::character varying, par_file_attachments := var_File::text);
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
