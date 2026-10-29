CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_bayan_all_usd_preload()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_MailProfile VARCHAR(128) DEFAULT 'SSIS Alert';
    var_Recipients VARCHAR(500) DEFAULT 'isg-eso-support@globe.com.ph;wmadiano@globe.com.ph';
    error_catch$ERROR_NUMBER TEXT;
    error_catch$ERROR_SEVERITY TEXT;
    error_catch$ERROR_STATE TEXT;
    error_catch$ERROR_LINE TEXT;
    error_catch$ERROR_PROCEDURE TEXT;
    error_catch$ERROR_MESSAGE TEXT;
    var_RawErrorMessage1 VARCHAR(4000);
    var_ErrorMessage1 VARCHAR(1000);
    var_RawErrorMessage2 VARCHAR(4000);
    var_ErrorMessage2 VARCHAR(1000);
BEGIN
    /* this stored procedure is being called by the sql job: ICCBS_EOM_Bayan_00_P10_Preload_All_USD_02Mth */
    /* Suppress the count message */
    
    /*
    It seems the issue is related to concurrency.
    TODO: for tommorow April 7, 2026
    make sure the Bayan USD Billed and Deferred executes in different time, make it sequencial
    instead of calling the the sql job, just consolidate them into 1 stored procedure.
    remove the duplicte execution of SAP lookup data
    investigate why the job does not run sequencally
    execute the bayan usd with serparate try catch and send an email to support team in case of failure.
    Ensure that the first processing does not block the next process
    */
    /* step 1 EXEC [dbo].[sp_Job_ICCBS_Bayan_USD_Billed_Data_Preload] */
    /* step 2 EXEC [dbo].[sp_Job_ICCBS_Bayan_USD_Deferred_Data_Preload] */
    /* execute the job sequentially with separate try catch */
    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_usd_billed_data_preload();
        EXCEPTION
            WHEN OTHERS THEN
                /* Handle error and send email notification */
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_PRELOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_USD_Billed_Data_Preload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage1;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage1) > 1000 THEN LEFT(var_RawErrorMessage1, 997) || '...'
                        ELSE var_RawErrorMessage1
                    END
                    INTO var_ErrorMessage1;

                BEGIN
                    /* Send email to support team (assuming Database Mail is configured) */
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan USD Billed Data Preload - ICCBS_EOM_Bayan_06_P10_Preload_USD_Billed_Data_AdHoc'::character varying, par_body := var_ErrorMessage1::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            /* Keep going even if email notification fails */
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_PRELOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan USD Billed Data Preload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_usd_deferred_data_preload();
        EXCEPTION
            WHEN OTHERS THEN
                /* Handle error and send email notification */
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_PRELOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_USD_Deferred_Data_Preload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage2;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage2) > 1000 THEN LEFT(var_RawErrorMessage2, 997) || '...'
                        ELSE var_RawErrorMessage2
                    END
                    INTO var_ErrorMessage2;

                BEGIN
                    /* Send email to support team */
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan USD Deferred Data Preload - ICCBS_EOM_Bayan_07_P10_Preload_USD_Deferred_Data_AdHoc'::character varying, par_body := var_ErrorMessage2::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            /* Keep going even if email notification fails */
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_PRELOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan USD Deferred Data Preload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;
END;
$procedure$
