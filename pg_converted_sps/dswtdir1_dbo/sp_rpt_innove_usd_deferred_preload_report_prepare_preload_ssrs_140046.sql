CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_rpt_innove_usd_deferred_preload_report_prepare_preload_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, sortorder, uniquekey, error
        FROM dswtdir1_dbo.rpt_innove_usd_deferred_preload_report_prepare_preload_cache
        ORDER BY column01 NULLS FIRST,
        CASE
            WHEN aws_sqlserver_ext.ISNUMERIC(sortorder) THEN CAST (sortorder AS INTEGER)
            ELSE NULL
        END NULLS FIRST;
END;
$procedure$
