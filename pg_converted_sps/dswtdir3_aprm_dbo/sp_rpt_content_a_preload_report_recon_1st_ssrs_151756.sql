CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_content_a_preload_report_recon_1st_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20
        FROM dswtdir3_aprm_dbo.rpt_content_a_preload_report_recon_report_1st_cache;
END;
$procedure$
