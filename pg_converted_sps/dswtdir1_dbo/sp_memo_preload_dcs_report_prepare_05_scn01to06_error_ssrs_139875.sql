CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_report_prepare_05_scn01to06_error_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM dswtdir1_dbo.memo_preload_dcs_report_prepare_05_scn01to06_error_cache AS x
        ORDER BY CAST (x.pstg_date AS DATE) DESC NULLS LAST, x.counter DESC NULLS LAST;
END;
$procedure$
