CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_preload_report_prepare_negativeamoun()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_delta_innove_preload_report_negativeamount_preload_cache;
    INSERT INTO dswtdir3_aprm_dbo.rpt_voice_delta_innove_preload_report_negativeamount_preload_cache (column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23)
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23
        FROM dswtdir3_aprm_dbo.tvaprm_voice_innove_delta_negativeamount_preloadrptsel;
END;
$procedure$
