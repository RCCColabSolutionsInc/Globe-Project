CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postoad_dcs_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.sp_memo_postoad_dcs_report_prepare_failed();
    CALL dswtdir1_dbo.sp_memo_postoad_dcs_report_prepare_success();
END;
$procedure$
