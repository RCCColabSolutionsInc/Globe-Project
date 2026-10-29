CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postoad_dcs_report_prepare_success_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM dswtdir1_dbo.memo_postoad_dcs_report_prepare_success_cache;
END;
$procedure$
