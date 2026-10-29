CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_send_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cycle_key VARCHAR(10);
    v_pipeline_code VARCHAR(10);
    v_billcycle VARCHAR(5);
    v_keyword_ssrs VARCHAR(20);
    v_file_code VARCHAR(2);
    v_file_codex VARCHAR(2);

    v_valid_count INT := 0;
    v_error_count INT := 0;
    v_valid_name VARCHAR(300);
    v_error_name VARCHAR(300);

    v_qs_url TEXT := 'https://us-east-1.quicksight.aws.amazon.com/sn/accounts/979437352248/dashboards/isg-esatp-dv-qs-billed-union';
    v_globe_cc TEXT := 'princess.ortilano@globe.com.ph;mkguillermo@globe.com.ph;ma.lai@globe.com.ph;jpdacquil@globe.com.ph;wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph';

    r RECORD;
BEGIN
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
    FROM dswtdir2_bayan_dbo.billcycles
    WHERE cyclecode = v_cycle_key;

    IF v_billcycle IS NULL THEN
        RAISE EXCEPTION 'No billcycles row for cycle % (lookup %)', par_cyclecode, v_cycle_key;
    END IF;

    v_valid_name := 'Bayn_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Valid';
    v_error_name := 'Bayn_Billed_Postload_DP1' || COALESCE(v_keyword_ssrs, '') || '_Error';

    SELECT COUNT(1) INTO v_valid_count
    FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    SELECT COUNT(1) INTO v_error_count
    FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache
    WHERE billcycle = v_billcycle AND column01 = '01';

    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.etl_email_outbound_queue (
        queue_id SERIAL,
        cycle_code VARCHAR(10),
        report_name VARCHAR(300),
        record_count INT,
        recipients VARCHAR(1000),
        cc_recipients VARCHAR(2000),
        email_subject VARCHAR(1000),
        email_body TEXT,
        status VARCHAR(20) DEFAULT 'PENDING'
    );

    ALTER TABLE dswtdir2_bayan_dbo.etl_email_outbound_queue ADD COLUMN IF NOT EXISTS attachment_name VARCHAR(400);
    ALTER TABLE dswtdir2_bayan_dbo.etl_email_outbound_queue ADD COLUMN IF NOT EXISTS stage VARCHAR(20);
    ALTER TABLE dswtdir2_bayan_dbo.etl_email_outbound_queue ADD COLUMN IF NOT EXISTS pipeline_code VARCHAR(10);
    ALTER TABLE dswtdir2_bayan_dbo.etl_email_outbound_queue ADD COLUMN IF NOT EXISTS status_detail TEXT;

    DELETE FROM dswtdir2_bayan_dbo.etl_email_outbound_queue
    WHERE stage = 'postload'
      AND status = 'PENDING'
      AND pipeline_code = v_pipeline_code;

    FOR r IN
        SELECT *
        FROM (VALUES
            (v_valid_name, v_valid_count, 'mhel.pineda@rcccolabsolutions.com',
             'Bayn_Billed_Postload_DP1_BC' || v_file_codex || '_C' || v_file_code || '_Valid.xlsx'),
            (v_error_name, v_error_count, 'handrianmhel@gmail.com',
             'Bayn_Billed_Postload_DP1_BC' || v_file_codex || '_' || v_file_code || '_Error.xlsx')
        ) AS t(report_name, record_count, recipients, attachment_name)
    LOOP
        IF r.record_count > 0 THEN
            INSERT INTO dswtdir2_bayan_dbo.etl_email_outbound_queue (
                cycle_code, pipeline_code, stage, report_name, record_count,
                recipients, cc_recipients, email_subject, email_body, attachment_name, status
            ) VALUES (
                v_cycle_key,
                v_pipeline_code,
                'postload',
                r.report_name,
                r.record_count,
                r.recipients,
                v_globe_cc,
                'Report Notif: MyBSS ' || r.report_name || ' - ' || r.record_count || ' Record(s) Generated',
                CONCAT(
                    'Greetings,<br><br>This automated message serves as a notification that the report "<b>', r.report_name,
                    '</b>" has been successfully generated, with a <b>total of ', r.record_count,
                    ' record(s)</b>. You will find this report attached to this email for your convenience.<br><br>',
                    'This report can also be accessed via QuickSight: <a href="', v_qs_url, '">', v_qs_url, '</a>.<br><br>',
                    'Please review the attached report and should you have any questions or require further assistance, please feel free to contact our support team.<br><br>Thank You'
                ),
                r.attachment_name,
                'PENDING'
            );
        END IF;
    END LOOP;

    RAISE NOTICE 'Postload report queue refreshed for % (%).', v_pipeline_code, v_cycle_key;
END;
$procedure$
