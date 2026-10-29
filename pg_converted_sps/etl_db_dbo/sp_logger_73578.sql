CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_logger(IN par_process character varying, IN par_log_message character varying, IN par_description text, IN par_error_line integer, IN par_error_message text)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    INSERT INTO etl_db_dbo.processing_logs (process, message, description, error_line, error_message)
    VALUES (par_process, par_log_message, par_description, par_error_line, par_error_message);
END;
$procedure$
