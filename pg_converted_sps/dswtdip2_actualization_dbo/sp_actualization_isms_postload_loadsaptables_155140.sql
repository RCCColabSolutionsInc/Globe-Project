CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_postload_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta();
    /* PRINT 'TODO' */
END;
$procedure$
