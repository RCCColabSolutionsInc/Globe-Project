CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
CALL dswtdir3_aprm_dbo.sp_aprm_content_a_postload_report_prepare_1st();
END;
$procedure$
