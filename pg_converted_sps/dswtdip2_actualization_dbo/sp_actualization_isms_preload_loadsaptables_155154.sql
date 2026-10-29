CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_tcurr();
    /* PRINT 'TODO' */
END;
$procedure$
