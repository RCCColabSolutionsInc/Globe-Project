CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_send(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cycle_key VARCHAR(10);
    v_pipeline_code VARCHAR(10);
    v_billcycle VARCHAR(5);
    v_keyword_ssrs VARCHAR(20);
    v_file_code VARCHAR(2);
    v_file_codex VARCHAR(2);

    v_preload_count INT := 0;
    v_charge_code_count INT := 0;
    v_subs_type_count INT := 0;
    v_recon_php_count INT := 0;
    v_recon_usd_count INT := 0;

    v_preload_name VARCHAR(300);
    v_charge_code_name VARCHAR(300);
    v_subs_type_name VARCHAR(300);
    v_recon_php_name VARCHAR(300);
    v_recon_usd_name VARCHAR(300);

    v_qs_url TEXT := 'https://us-east-1.quicksight.aws.amazon.com/sn/accounts/979437352248/dashboards/isg-esatp-dv-qs-billed-union';
    
    v_globe_to TEXT := 'harvey.tiong@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;princess.ortilano@globe.com.ph;jpdacquil@globe.com.ph';
    v_globe_cc TEXT := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph';

    r RECORD;
BEGIN
    -- =========================================================================
    -- PARAMETER SAFEGUARD (Bulletproofing)
    -- If orchestration passes a raw number (e.g. '11' or '1'), fix it to 'BC11'
    -- =========================================================================
    IF par_cyclecode ~ '^[0-9]+$' THEN
        par_cyclecode := 'BC' || LPAD(par_cyclecode, 2, '0');
    END IF;

    -- =========================================================================
    -- MASTER DATA SELF-HEALING (billcycles)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_innove_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txInnove_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txInnove_Billed_Cycle2_LoadFileSel', 'txInnove_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txInnove_Billed_Cycle3_LoadFileSel', 'txInnove_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txInnove_Billed_Cycle4_LoadFileSel', 'txInnove_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txInnove_Billed_Cycle5_LoadFileSel', 'txInnove_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txInnove_Billed_Cycle6_LoadFileSel', 'txInnove_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txInnove_Billed_Cycle7_LoadFileSel', 'txInnove_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txInnove_Billed_Cycle8_LoadFileSel', 'txInnove_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txInnove_Billed_Cycle9_LoadFileSel', 'txInnove_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txInnove_Billed_Cycle10_LoadFileSel', 'txInnove_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txInnove_Billed_Cycle11_LoadFileSel', 'txInnove_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_innove_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
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
    FROM dswtdir2_innove_dbo.billcycles
    WHERE cyclecode = v_cycle_key;

    IF v_billcycle IS NULL THEN
        RAISE EXCEPTION 'No billcycles row for cycle % (lookup %)', par_cyclecode, v_cycle_key;
    END IF;

    -- Construct base report names (Matches Innove Legacy Preload)
    v_preload_name := 'Inov_Billed_Preload_DP1' || COALESCE(v_keyword_ssrs, '');
    v_charge_code_name := 'Inov_Billed_Preload_DP1' || COALESCE(v_keyword_ssrs, '') || '_ChargeCodeMissing';
    v_subs_type_name := 'Inov_Billed_Preload_DP1' || COALESCE(v_keyword_ssrs, '') || '_SubsTypeMissing';
    v_recon_php_name := 'Inov_Billed_Recon_Summary_PHP_DP1' || COALESCE(v_keyword_ssrs, '');
    v_recon_usd_name := 'Inov_Billed_Recon_Summary_USD_DP1' || COALESCE(v_keyword_ssrs, '');

    -- Count records from the actual preload cache tables
    SELECT COUNT(1) INTO v_preload_count
    FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    SELECT COUNT(1) INTO v_charge_code_count
    FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_subs_type_count
    FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_recon_php_count
    FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache
    WHERE billcycle = v_billcycle;

    SELECT COUNT(1) INTO v_recon_usd_count
    FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache
    WHERE billcycle = v_billcycle;

    -- Prepare the Outbound Queue Table
    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.etl_email_outbound_queue (
        queue_id SERIAL, cycle_code VARCHAR(10), report_name VARCHAR(300), record_count INT,
        recipients VARCHAR(1000), cc_recipients VARCHAR(2000), email_subject VARCHAR(1000),
        email_body TEXT, status VARCHAR(20) DEFAULT 'PENDING', attachment_name VARCHAR(400),
        stage VARCHAR(20), pipeline_code VARCHAR(10), status_detail TEXT
    );

    -- Clear pending items for this specific cycle/stage (Preload)
    DELETE FROM dswtdir2_innove_dbo.etl_email_outbound_queue
    WHERE stage = 'preload' AND status = 'PENDING' AND pipeline_code = v_pipeline_code;

    -- Enqueue Emails (only if they have records)
    FOR r IN
        SELECT *
        FROM (VALUES
            (v_preload_name, v_preload_count, v_globe_to,
             'Inov_Billed_Preload_DP1_BC' || v_file_codex || '_C' || v_file_code || '.xlsx'),
            (v_charge_code_name, v_charge_code_count, v_globe_to,
             'Inov_Billed_Preload_DP1_BC' || v_file_codex || '_C' || v_file_code || '_ChargeCodeMissing.xlsx'),
            (v_subs_type_name, v_subs_type_count, v_globe_to,
             'Inov_Billed_Preload_DP1_BC' || v_file_codex || '_C' || v_file_code || '_SubsTypeMissing.xlsx'),
            (v_recon_php_name, v_recon_php_count, v_globe_to,
             'Inov_Billed_Recon_Summary_PHP_DP1_BC' || v_file_codex || '_C' || v_file_code || '.xlsx'),
            (v_recon_usd_name, v_recon_usd_count, v_globe_to,
             'Inov_Billed_Recon_Summary_USD_DP1_BC' || v_file_codex || '_C' || v_file_code || '.xlsx')
        ) AS t(report_name, record_count, recipients, attachment_name)
    LOOP
        IF r.record_count > 0 THEN
            INSERT INTO dswtdir2_innove_dbo.etl_email_outbound_queue (
                cycle_code, pipeline_code, stage, report_name, record_count,
                recipients, cc_recipients, email_subject, email_body, attachment_name, status
            ) VALUES (
                v_cycle_key, v_pipeline_code, 'preload', r.report_name, r.record_count,
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

    RAISE NOTICE 'Preload report queue refreshed for Innove % (%).', v_pipeline_code, v_cycle_key;
END;
$procedure$
