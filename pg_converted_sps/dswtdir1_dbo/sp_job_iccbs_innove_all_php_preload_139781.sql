CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_iccbs_innove_all_php_preload()
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
BEGIN
    /* Suppress the count message */
    /* step 1 EXEC [dbo].[sp_Job_ICCBS_Innove_PHP_Billed_Preload] */
    /* step 2 EXEC [dbo].[sp_Job_ICCBS_Innove_PHP_Unbilled_Preload] */
    /* step 3 EXEC [dbo].[sp_Job_ICCBS_Innove_PHP_Deferred_Preload] */
    /* Execute the preload jobs sequentially with separate error handling. */
    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_innove_php_billed_preload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Innove_PHP_Billed_Preload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage1;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage1) > 1000 THEN LEFT(var_RawErrorMessage1, 997) || '...'
                        ELSE var_RawErrorMessage1
                    END
                    INTO var_ErrorMessage1;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Innove PHP Billed Preload - ICCBS_EOM_Innove_01_P10_Preload_PHP_Billed_AdHoc'::character varying, par_body := var_ErrorMessage1::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Innove PHP Billed Preload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_innove_php_unbilled_preload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Innove_PHP_Unbilled_Preload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage2;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage2) > 1000 THEN LEFT(var_RawErrorMessage2, 997) || '...'
                        ELSE var_RawErrorMessage2
                    END
                    INTO var_ErrorMessage2;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Innove PHP Unbilled Preload - ICCBS_EOM_Innove_02_P10_Preload_PHP_Unbilled_AdHoc'::character varying, par_body := var_ErrorMessage2::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Innove PHP Unbilled Preload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;

    BEGIN
        CALL dswtdir1_dbo.sp_job_iccbs_innove_php_deferred_preload();
        EXCEPTION
            WHEN OTHERS THEN
                error_catch$ERROR_NUMBER := '0';
                error_catch$ERROR_SEVERITY := '0';
                error_catch$ERROR_LINE := '0';
                error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                    error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                SELECT
                    'Procedure: sp_Job_ICCBS_Innove_PHP_Deferred_Preload' || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Number: ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Line: ' || CAST (error_catch$ERROR_LINE AS VARCHAR(20)) || aws_sqlserver_ext.CHAR(13) || aws_sqlserver_ext.CHAR(10) || 'Error Message: ' || error_catch$ERROR_MESSAGE
                    INTO var_RawErrorMessage3;
                SELECT
                    CASE
                        WHEN LENGTH(var_RawErrorMessage3) > 1000 THEN LEFT(var_RawErrorMessage3, 997) || '...'
                        ELSE var_RawErrorMessage3
                    END
                    INTO var_ErrorMessage3;

                BEGIN
                    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_MailProfile::character varying, par_recipients := var_Recipients::text, par_subject := 'Error in Innove PHP Deferred Preload - ICCBS_EOM_Innove_03_P10_Preload_PHP_Deferred_AdHoc'::character varying, par_body := var_ErrorMessage3::text);
                    EXCEPTION
                        WHEN OTHERS THEN
                            error_catch$ERROR_NUMBER := '0';
                            error_catch$ERROR_SEVERITY := '0';
                            error_catch$ERROR_LINE := '0';
                            error_catch$ERROR_PROCEDURE := 'SP_JOB_ICCBS_INNOVE_ALL_PHP_PRELOAD';
                            GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
                                error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
                            RAISE NOTICE '%', 'Failed to send error email for Innove PHP Deferred Preload: ' || error_catch$ERROR_MESSAGE;
                END;
    END;
END;
$procedure$
