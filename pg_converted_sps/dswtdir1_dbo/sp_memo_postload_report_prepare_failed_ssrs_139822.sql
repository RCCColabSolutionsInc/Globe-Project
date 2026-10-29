CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postload_report_prepare_failed_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM dswtdir1_dbo.memo_postload_line_report_prepare_failed_cache;
END;
$procedure$
