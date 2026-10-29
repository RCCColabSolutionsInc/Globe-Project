CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_1st_preload();
    CALL dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_currentvsprior_mc1st();
    CALL dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_per_partner1st();
    CALL dswtdir3_aprm_dbo.sp_aprm_content_a_preload_report_prepare_recon_1st();
END;
$procedure$
