CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_bayan_preload_unbilled_adj_preload_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, zdsp_order, zdsp_uniquekey
        FROM dswtdir2_bayan_dbo.rpt_preload_report_unbilled_adj_preload_cache
        ORDER BY column01 NULLS FIRST,
        CASE
            WHEN aws_sqlserver_ext.ISNUMERIC(zdsp_order) THEN CAST (zdsp_order AS INTEGER)
            ELSE NULL
        END NULLS FIRST;
END;
$procedure$
