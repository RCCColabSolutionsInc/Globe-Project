CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_report_prepare_05_overlap_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM dswtdir1_dbo.memo_preload_line_report_prepare_05_overlap_cache;
END;
$procedure$
