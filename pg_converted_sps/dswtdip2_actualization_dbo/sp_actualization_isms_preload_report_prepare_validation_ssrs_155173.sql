CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_validation_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_validation_cache;
END;
$procedure$
