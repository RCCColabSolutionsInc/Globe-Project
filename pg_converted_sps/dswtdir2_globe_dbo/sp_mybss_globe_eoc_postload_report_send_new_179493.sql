CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_report_send_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cycle_key VARCHAR(10);
    v_pipeline_code VARCHAR(10);
    v_billcycle VARCHAR(5);
    v_keyword_ssrs VARCHAR(20);
    v_file_code VARCHAR(2);
    v_file_codex VARCHAR(2);

    v_error_count INT := 0;
    v_valid_count INT := 0;

    v_error_name VARCHAR(300);
    v_valid_name VARCHAR(300);

    v_qs_url TEXT := 'https://us-east-1.quicksight.aws.amazon.com/sn/accounts/979437352248/dashboards/isg-esatp-dv-qs-billed-union';
    
    -- Extracted directly from legacy Globe MSSQL script
    v_globe_to TEXT := 'rosoldevilla@globe.com.ph;rnvillar@globe.com.ph';
    v_globe_cc TEXT := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph';

    r RECORD;
BEGIN
    -- =========================================================================
    -- PARAMETER SAFEGUARD (Bulletproofing)
    -- =========================================================================
    IF par_cyclecode ~ '^[0-9]+$' THEN
        par_cyclecode := 'BC' || LPAD(par_cyclecode, 2, '0');
    END IF;

    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_globe_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txGlobe_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txGlobe_Billed_Cycle2_LoadFileSel', 'txGlobe_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txGlobe_Billed_Cycle3_LoadFileSel', 'txGlobe_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txGlobe_Billed_Cycle4_LoadFileSel', 'txGlobe_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txGlobe_Billed_Cycle5_LoadFileSel', 'txGlobe_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txGlobe_Billed_Cycle6_LoadFileSel', 'txGlobe_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txGlobe_Billed_Cycle7_LoadFileSel', 'txGlobe_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txGlobe_Billed_Cycle8_LoadFileSel', 'txGlobe_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txGlobe_Billed_Cycle9_LoadFileSel', 'txGlobe_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txGlobe_Billed_Cycle10_LoadFileSel', 'txGlobe_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txGlobe_Billed_Cycle11_LoadFileSel', 'txGlobe_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_globe_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    -- =========================================================================
    -- MAIN QUEUE BUILDER LOGIC
    -- =========================================================================
    v_pipeline_code := CASE upper(par_cyclecode)
        WHEN 'EOC1' THEN 'BC01' WHEN 'BC01' THEN 'BC01'
        WHEN 'EOC2' THEN 'BC06' WHEN 'BC06' THEN 'BC06'
        WHEN 'EOC3' THEN 'BC08' WHEN 'BC08' THEN 'BC08'
        WHEN 'EOC4' THEN 'BC10' WHEN 'BC10' THEN 'BC10'
        WHEN 'EOC5' THEN 'BC11' WHEN 'BC11' THEN 'BC11'
        WHEN 'EOC6' THEN 'BC13' WHEN 'BC13' THEN 'BC13'
        WHEN 'EOC7' THEN 'BC16' WHEN 'BC16' THEN 'BC16'
        WHEN 'EOC8' THEN 'BC18' WHEN 'BC18' THEN 'BC18'
        WHEN 'EOC9' THEN 'BC21' WHEN 'BC21' THEN 'BC21'
        WHEN 'EOC10' THEN 'BC24' WHEN 'BC24' THEN 'BC24'
        WHEN 'EOC11' THEN 'BC27' WHEN 'BC27' THEN 'BC27'
        ELSE upper(par_cyclecode)
    END;

    v_cycle_key := CASE v_pipeline_code
        WHEN 'BC01' THEN 'EOC1' WHEN 'BC06' THEN 'EOC2' WHEN 'BC08' THEN 'EOC3'
        WHEN 'BC10' THEN 'EOC4' WHEN 'BC11' THEN 'EOC5' WHEN 'BC13' THEN 'EOC6'
        WHEN 'BC16' THEN 'EOC7' WHEN 'BC18' THEN 'EOC8' WHEN 'BC21' THEN 'EOC9'
        WHEN 'BC24' THEN 'EOC10' WHEN 'BC27' THEN 'EOC11'
        ELSE par_cyclecode
    END;

    v_file_code := CASE v_pipeline_code
        WHEN 'BC01' THEN '1' WHEN 'BC06' THEN '2' WHEN 'BC08' THEN '3'
        WHEN 'BC10' THEN '4' WHEN 'BC11' THEN '5' WHEN 'BC13' THEN '6'
        WHEN 'BC16' THEN '7' WHEN 'BC18' THEN '8' WHEN 'BC21' THEN '9'
        WHEN 'BC24' THEN '10' WHEN 'BC27' THEN '11' ELSE '1'
    END;

    v_file_codex := CASE v_pipeline_code
        WHEN 'BC01' THEN '1' WHEN 'BC06' THEN '6' WHEN 'BC08' THEN '8'
        WHEN 'BC10' THEN '10' WHEN 'BC11' THEN '11' WHEN 'BC13' THEN '13'
        WHEN 'BC16' THEN '16' WHEN 'BC18' THEN '18' WHEN 'BC21' THEN '21'
        WHEN 'BC24' THEN '24' WHEN 'BC27' THEN '27' ELSE '1'
    END;

    SELECT keyword_ssrs, billcycle
    INTO v_keyword_ssrs, v_billcycle
    FROM dswtdir2_globe_dbo.billcycles
    WHERE cyclecode = v_cycle_key;

    IF v_billcycle IS NULL THEN
        RAISE EXCEPTION 'No billcycles row for cycle % (lookup %)', par_cyclecode, v_cycle_key;
    END IF;

    -- Construct base report names (Matches Globe Legacy Postload)
    v_error_name := 'Glob_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Error';
    v_valid_name := 'Glob_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Valid';

    -- Check Error Records First
    SELECT COUNT(1) INTO v_error_count
    FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_error_cache
    WHERE billcycle = v_billcycle AND data = '01';

    -- Implement SAP "All or Nothing" Rule
    -- Do not send the valid report by keeping the count at 0 if there is at least 1 error found.
    IF v_error_count = 0 THEN
        SELECT COUNT(1) INTO v_valid_count
        FROM dswtdir2_globe_dbo.rpt_postload_report_dp1_billed_valid_cache
        WHERE billcycle = v_billcycle AND data = '01';
    END IF;

    -- Prepare the Outbound Queue Table
    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.etl_email_outbound_queue (
        queue_id SERIAL, cycle_code VARCHAR(10), report_name VARCHAR(300), record_count INT,
        recipients VARCHAR(1000), cc_recipients VARCHAR(2000), email_subject VARCHAR(1000),
        email_body TEXT, status VARCHAR(20) DEFAULT 'PENDING', attachment_name VARCHAR(400),
        stage VARCHAR(20), pipeline_code VARCHAR(10), status_detail TEXT
    );

    -- Clear pending items for this specific cycle/stage (Postload)
    DELETE FROM dswtdir2_globe_dbo.etl_email_outbound_queue
    WHERE stage = 'postload' AND status = 'PENDING' AND pipeline_code = v_pipeline_code;

    -- Enqueue Emails (only if they have records)
    FOR r IN
        SELECT *
        FROM (VALUES
            (v_error_name, v_error_count, v_globe_to,
             'Glob_Billed_Postload_DP1_BC' || v_file_codex || '_C' || v_file_code || '_Error.xlsx'),
            (v_valid_name, v_valid_count, v_globe_to,
             'Glob_Billed_Postload_DP1_BC' || v_file_codex || '_C' || v_file_code || '_Valid.xlsx')
        ) AS t(report_name, record_count, recipients, attachment_name)
    LOOP
        IF r.record_count > 0 THEN
            INSERT INTO dswtdir2_globe_dbo.etl_email_outbound_queue (
                cycle_code, pipeline_code, stage, report_name, record_count,
                recipients, cc_recipients, email_subject, email_body, attachment_name, status
            ) VALUES (
                v_cycle_key, v_pipeline_code, 'postload', r.report_name, r.record_count,
                r.recipients, v_globe_cc, 'Report Notif: MyBSS ' || r.report_name || ' - ' || r.record_count || ' Record(s) Generated',
                CONCAT(
                    'Greetings,<br><br>This automated message serves as a notification that the report "<b>', r.report_name,
                    '</b>" has been successfully generated, with a <b>total of ', r.record_count,
                    ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                    'This report can also be accessed via QuickSight: <a href="', v_qs_url, '">', v_qs_url, '</a>.<br><br>',
                    'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You'
                ), r.attachment_name, 'PENDING'
            );
        END IF;
    END LOOP;

    RAISE NOTICE 'Postload report queue refreshed for Globe % (%). Errors: %, Valids Queued: %', 
                 v_pipeline_code, v_cycle_key, v_error_count, v_valid_count;
END;
$procedure$
