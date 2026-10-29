CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_innove_postload_report_prepare_comparison()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_delta_innove_postload_report_comparison_cache;
    INSERT INTO dswtdir3_aprm_dbo.rpt_voice_delta_innove_postload_report_comparison_cache (direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Final DURATION", "Final SETTABLE AMT", "Accrual DURATION", "Accrual SETTABLE AMT", "Delta DURATION", "Delta SETTABLE AMT", "Difference FvA Duration", "Difference FvA SETTABLE AMT", "Difference F-AvD Duration", "Difference F-AvD SETTABLE AMT", "Output Duration", "Output Amount", "Difference in Duration", "Difference in SETTABLE AMT")
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "Final DURATION", "Final SETTABLE AMT", "Accrual DURATION", "Accrual SETTABLE AMT", "Delta DURATION", "Delta SETTABLE AMT", "Difference FvA Duration", "Difference FvA SETTABLE AMT", "Difference F-AvD Duration", "Difference F-AvD SETTABLE AMT", "Output Duration", "Output Amount", "Difference in Duration", "Difference in SETTABLE AMT"
        FROM dswtdir3_aprm_dbo.tvaprm_voice_innove_delta_comparison_rptsel;
END;
$procedure$
