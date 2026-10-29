CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_accural_vs_final();
  	CALL dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_currentvsprior_mc();
    CALL dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_preload();
    CALL dswtdir3_aprm_dbo.sp_aprm_content_i_preload_report_prepare_reconcomparison();
END;
$procedure$
