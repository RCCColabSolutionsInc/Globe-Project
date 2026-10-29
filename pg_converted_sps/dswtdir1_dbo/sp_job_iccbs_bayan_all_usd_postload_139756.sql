CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_bayan_all_usd_postload()
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
    /* Suppress the count message */
    /* step 1 EXEC [dbo].[sp_Job_ICCBS_Bayan_USD_Billed_Data_Postload] */
    /* step 2 EXEC [dbo].[sp_Job_ICCBS_Bayan_USD_Deferred_Data_Postload] */
    /* Execute the postload jobs sequentially with separate error handling. */
    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_usd_billed_data_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_USD_Billed_Data_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage1;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage1) > 1000 THEN LEFT(var_RawErrorMessage1, 997) || '...'
                        ELSE var_RawErrorMessage1
                    END
                    INTO var_ErrorMessage1;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan USD Billed Data Postload - ICCBS_EOM_Bayan_06_P20_Postload_USD_Billed_Data_AdHoc'::character varying, par_body := var_ErrorMessage1::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan USD Billed Data Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_usd_deferred_data_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_USD_Deferred_Data_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage2;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage2) > 1000 THEN LEFT(var_RawErrorMessage2, 997) || '...'
                        ELSE var_RawErrorMessage2
                    END
                    INTO var_ErrorMessage2;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan USD Deferred Data Postload - ICCBS_EOM_Bayan_07_P20_Postload_USD_Deferred_Data_AdHoc'::character varying, par_body := var_ErrorMessage2::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_USD_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan USD Deferred Data Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;
END;
$procedure$
