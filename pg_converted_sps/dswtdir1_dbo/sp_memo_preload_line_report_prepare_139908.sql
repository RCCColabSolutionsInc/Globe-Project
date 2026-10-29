CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_01_scn01to06_alldata();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_02_scn01to06_error();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_03_scn01to06_passed();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_04_invalidlength();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_05_overlap();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_06_invalidlengthorformat();
    CALL dswtdir1_dbo.sp_memo_preload_line_report_prepare_07_notrecognized();
END;
$procedure$
