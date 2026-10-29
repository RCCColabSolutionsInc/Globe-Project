CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_bayan_all_php_postload()
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
    var_RawErrorMessage3 VARCHAR(4000);
    var_ErrorMessage3 VARCHAR(1000);
    var_RawErrorMessage4 VARCHAR(4000);
    var_ErrorMessage4 VARCHAR(1000);
    var_RawErrorMessage5 VARCHAR(4000);
    var_ErrorMessage5 VARCHAR(1000);
BEGIN
    /* Suppress the count message */
    /* step 1 EXEC [dbo].[sp_Job_ICCBS_Bayan_PHP_Billed_Postload] */
    /* step 2 EXEC [dbo].[sp_Job_ICCBS_Bayan_PHP_Unbilled_Postload] */
    /* step 3 EXEC [dbo].[sp_Job_ICCBS_Bayan_PHP_Deferred_Postload] */
    /* step 4 EXEC [dbo].[sp_Job_ICCBS_Bayan_PHP_Billed_Data_Postload] */
    /* step 5 EXEC [dbo].[sp_Job_ICCBS_Bayan_PHP_Deferred_Data_Postload] */
    /* Execute the postload jobs sequentially with separate error handling. */
    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_php_billed_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_PHP_Billed_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage1;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage1) > 1000 THEN LEFT(var_RawErrorMessage1, 997) || '...'
                        ELSE var_RawErrorMessage1
                    END
                    INTO var_ErrorMessage1;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan PHP Billed Postload - ICCBS_EOM_Bayan_01_P20_Postload_PHP_Billed_AdHoc'::character varying, par_body := var_ErrorMessage1::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan PHP Billed Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_php_unbilled_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_PHP_Unbilled_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage2;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage2) > 1000 THEN LEFT(var_RawErrorMessage2, 997) || '...'
                        ELSE var_RawErrorMessage2
                    END
                    INTO var_ErrorMessage2;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan PHP Unbilled Postload - ICCBS_EOM_Bayan_02_P20_Postload_PHP_Unbilled_AdHoc'::character varying, par_body := var_ErrorMessage2::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan PHP Unbilled Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_php_deferred_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_PHP_Deferred_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage3;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage3) > 1000 THEN LEFT(var_RawErrorMessage3, 997) || '...'
                        ELSE var_RawErrorMessage3
                    END
                    INTO var_ErrorMessage3;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan PHP Deferred Postload - ICCBS_EOM_Bayan_03_P20_Postload_PHP_Deferred_AdHoc'::character varying, par_body := var_ErrorMessage3::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan PHP Deferred Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_php_billed_data_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_PHP_Billed_Data_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage4;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage4) > 1000 THEN LEFT(var_RawErrorMessage4, 997) || '...'
                        ELSE var_RawErrorMessage4
                    END
                    INTO var_ErrorMessage4;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan PHP Billed Data Postload - ICCBS_EOM_Bayan_04_P20_Postload_PHP_Billed_Data_AdHoc'::character varying, par_body := var_ErrorMessage4::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan PHP Billed Data Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_bayan_php_deferred_data_postload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Bayan_PHP_Deferred_Data_Postload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage5;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage5) > 1000 THEN LEFT(var_RawErrorMessage5, 997) || '...'
                        ELSE var_RawErrorMessage5
                    END
                    INTO var_ErrorMessage5;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Bayan PHP Deferred Data Postload - ICCBS_EOM_Bayan_05_P20_Postload_PHP_Deferred_Data_AdHoc'::character varying, par_body := var_ErrorMessage5::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_BAYAN_ALL_PHP_POSTLOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Bayan PHP Deferred Data Postload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;
END;
$procedure$
