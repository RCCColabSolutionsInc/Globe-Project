CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_rpt_voice_delta_bayan_preload_report_positiveamount_preload_(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23
        FROM dswtdir3_aprm_dbo.rpt_voice_delta_bayan_preload_report_positiveamount_preload_cache;
END;
$procedure$
