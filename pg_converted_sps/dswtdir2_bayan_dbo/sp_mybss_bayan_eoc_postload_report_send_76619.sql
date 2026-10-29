CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_send(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
    v_keyword_ssrs VARCHAR(20);
    
    -- Variables to hold record counts for each report
    v_valid_count INT := 0;
    v_error_count INT := 0;

    -- Variables to hold the dynamic report names
    v_valid_name VARCHAR(300);
    v_error_name VARCHAR(300);
    
    v_report_server_link VARCHAR(500) := 'http://10.66.6.3/Reports_DACPRD/Pages/Folder.aspx';
BEGIN
    -- =========================================================================
    -- 0. METADATA PREPARATION
    -- Resolving dynamic names exactly as MSSQL did via the BillCycles table
    -- =========================================================================
    SELECT keyword_ssrs, billcycle 
    INTO v_keyword_ssrs, v_billcycle
    FROM dswtdir2_bayan_dbo.billcycles 
    WHERE cyclecode = par_cyclecode;

    v_valid_name := 'Bayn_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Valid';
    v_error_name := 'Bayn_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Error';

    -- =========================================================================
    -- 1. RECORD COUNTING (Concurrent-Safe)
    -- =========================================================================
    
    -- Count 1: Valid Cache
    SELECT COUNT(1) INTO v_valid_count
    FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    -- Count 2: Error Cache
    SELECT COUNT(1) INTO v_error_count
    FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    -- =========================================================================
    -- 2. EMAIL METADATA STAGING (For AWS Lambda / SES)
    -- Ensures the queue table exists, then inserts a row for each report > 0
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.etl_email_outbound_queue (
        queue_id SERIAL,
        cycle_code VARCHAR(5),
        report_name VARCHAR(300),
        record_count INT,
        recipients VARCHAR(1000),
        cc_recipients VARCHAR(1000),
        email_subject VARCHAR(1000),
        email_body TEXT,
        status VARCHAR(20) DEFAULT 'PENDING'
    );

    IF v_valid_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_valid_name, v_valid_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_valid_name || ' - ' || v_valid_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_valid_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_valid_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    IF v_error_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_error_name, v_error_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_error_name || ' - ' || v_error_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_error_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_error_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe''s corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    RAISE NOTICE 'Actual Postload Report Send phase completed for %. Email metadata queued successfully.', par_cyclecode;

END;
$procedure$
