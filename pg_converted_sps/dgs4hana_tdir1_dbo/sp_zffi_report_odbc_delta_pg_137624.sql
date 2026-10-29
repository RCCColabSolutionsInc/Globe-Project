CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta_pg()
 LANGUAGE plpgsql
AS $procedure$

DECLARE
    error_catch$ERROR_NUMBER TEXT;
    error_catch$ERROR_SEVERITY TEXT;
    error_catch$ERROR_STATE TEXT;
    error_catch$ERROR_LINE TEXT;
    error_catch$ERROR_PROCEDURE TEXT;
    error_catch$ERROR_MESSAGE TEXT;
    var_ErrMsg VARCHAR(4000);
    var_ErrSeverity INTEGER;
BEGIN
   
    DELETE FROM dgs4hana_tdir1_dbo.zffi_report_odbc AS x
        WHERE EXISTS (SELECT
            1
            FROM t$temp AS y
            WHERE LOWER(y.zdsp_uniquekey) = LOWER(x.zdsp_uniquekey) AND y.zdsp_order = x.zdsp_order::VARCHAR AND y.z_prog_name = x.z_prog_name::VARCHAR);
   
   -- INSERT INTO dgs4hana_tdir1_dbo.zffi_report_odbc (mandt, z_source_name, zdsp_order, zdsp_uniquekey, z_upld_filename, z_line_item, z_prog_name, z_message, z_date, z_time, z_user_id)
   --  SELECT
   --      mandt, z_source_name, zdsp_order, zdsp_uniquekey, z_upld_filename, z_line_item, z_prog_name, z_message, z_date, z_time, z_user_id
   --      FROM t$temp;
 
   --  EXCEPTION
   --      WHEN OTHERS THEN
   --          error_catch$ERROR_NUMBER := '0';
   --          error_catch$ERROR_SEVERITY := '0';
   --          error_catch$ERROR_LINE := '0';
   --          error_catch$ERROR_PROCEDURE := 'SP_ZFFI_REPORT_ODBC_DELTA';
   --          GET STACKED DIAGNOSTICS error_catch$ERROR_STATE = RETURNED_SQLSTATE,
   --              error_catch$ERROR_MESSAGE = MESSAGE_TEXT;
   --          ROLLBACK;
   --          SELECT
   --              error_catch$ERROR_MESSAGE, error_catch$ERROR_SEVERITY
   --              INTO var_ErrMsg, var_ErrSeverity;
   --          RAISE 'Error %, severity %, state % was raised. Message: %.', '50000', var_ErrSeverity, 1, var_ErrMsg USING ERRCODE = '50000';
           
END;
$procedure$
