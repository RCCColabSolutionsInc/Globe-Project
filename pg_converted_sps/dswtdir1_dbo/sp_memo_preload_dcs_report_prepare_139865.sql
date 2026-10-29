CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_dcs_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* EXEC sp_Memo_Preload_DCS_Report_Prepare_01_Scn01To06_Loaded; */
    CALL dswtdir1_dbo.sp_memo_preload_dcs_report_prepare_02_scn01to06_approved();
    /*
    EXEC sp_Memo_Preload_DCS_Report_Prepare_03_Scn01To06_Submitted;
    EXEC sp_Memo_Preload_DCS_Report_Prepare_04_Scn01To06_DistinctError;
    EXEC sp_Memo_Preload_DCS_Report_Prepare_05_Scn01To06_Error;
    EXEC sp_Memo_Preload_DCS_Report_Prepare_06_Scn01To06_Disabled;
    EXEC sp_Memo_Preload_DCS_Report_Prepare_07_AllRecords_ErrorPage;
    */
END;
$procedure$
