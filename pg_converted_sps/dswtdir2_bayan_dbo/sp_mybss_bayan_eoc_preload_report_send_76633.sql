CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_send(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_billcycle VARCHAR(5);
    v_keyword_ssrs VARCHAR(20);
    
    -- Variables to hold record counts for each report
    v_preload_count INT := 0;
    v_charge_code_count INT := 0;
    v_subs_type_count INT := 0;
    v_recon_php_count INT := 0;

    -- Variables to hold the dynamic report names
    v_preload_name VARCHAR(300);
    v_charge_code_name VARCHAR(300);
    v_subs_type_name VARCHAR(300);
    v_recon_php_name VARCHAR(300);
    
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

    v_preload_name := 'Bayn_Billed_Preload_DP1' || v_keyword_ssrs;
    v_charge_code_name := 'Bayn_Billed_Preload_DP1' || v_keyword_ssrs || '_ChargeCodeMissing';
    v_subs_type_name := 'Bayn_Billed_Preload_DP1' || v_keyword_ssrs || '_SubsTypeMissing';
    v_recon_php_name := 'Bayn_Billed_Recon_Summary_PHP_DP1' || v_keyword_ssrs;

    -- =========================================================================
    -- 1. RECORD COUNTING (Concurrent-Safe)
    -- Added billcycle filters to all counts to support concurrent AWS Glue runs
    -- =========================================================================
    
    -- Count 1: Preload Cache (Filtered by column01 = '01')
    SELECT COUNT(1) INTO v_preload_count
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    -- Count 2: Charge Code Missing
    SELECT COUNT(1) INTO v_charge_code_count
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    WHERE billcycle = v_billcycle;

    -- Count 3: Subscriber Type Missing
    SELECT COUNT(1) INTO v_subs_type_count
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_cache
    WHERE billcycle = v_billcycle;

    -- Count 4: Recon Summary PHP
    SELECT COUNT(1) INTO v_recon_php_count
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache
    WHERE billcycle = v_billcycle;

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

    IF v_preload_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_preload_name, v_preload_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_preload_name || ' - ' || v_preload_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_preload_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_preload_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    IF v_charge_code_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_charge_code_name, v_charge_code_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_charge_code_name || ' - ' || v_charge_code_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_charge_code_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_charge_code_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    IF v_subs_type_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_subs_type_name, v_subs_type_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_subs_type_name || ' - ' || v_subs_type_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_subs_type_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_subs_type_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    IF v_recon_php_count > 0 THEN
        INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
            cycle_code, report_name, record_count, recipients, cc_recipients, email_subject, email_body
        ) VALUES (
            par_cyclecode, v_recon_php_name, v_recon_php_count,
            'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph',
            'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph',
            'Report Notif: MyBSS ' || v_recon_php_name || ' - ' || v_recon_php_count || ' Record(s) Generated',
            CONCAT('Greetings,<br><br>This automated message serves as a notification that the report "<b>', v_recon_php_name,
                   '</b>" has been successfully generated, with a <b>total of ', v_recon_php_count,
                   ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                   'This report can also be accessed via our secure report server, available at this link: <a href="', v_report_server_link, '">', v_report_server_link, '</a>. Please note, this link is accessible when connected to the Globe corporate network, using your network ID and password for login.<br><br>',
                   'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You')
        );
    END IF;

    RAISE NOTICE 'Actual Preload Report Send phase completed for %. Email metadata queued successfully.', par_cyclecode;

END;
$procedure$
