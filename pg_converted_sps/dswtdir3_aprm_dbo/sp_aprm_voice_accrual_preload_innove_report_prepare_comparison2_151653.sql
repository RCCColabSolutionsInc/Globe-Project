CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_preload_innove_report_prepare_comparison2()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir3_aprm_dbo.rpt_voice_accrual_innove_preload_report_comparison2_cache;
    INSERT INTO dswtdir3_aprm_dbo.rpt_voice_accrual_innove_preload_report_comparison2_cache (direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "CM DURATION", "PM DURATION", "CM SETTABLE AMT", "PM SETTABLE AMT", "AUR Duration", "AUR SETTABLE AMT", "I/D Duration", "I/D SETTABLE AMT", "CM vs AUR Duration", "CM vs AUR SETTABLE AMT", "CM_RATE/MIN", "PM_RATE/MIN", "Output Sum of Quantity (Settable duration)", "Output Sum of Amount", "Difference Duration", "Difference Amount", currency)
    SELECT
        direction, "SAP VENDOR CODE", "INTERCONNECT PARTNER CODE", "CM DURATION", "PM DURATION", "CM SETTABLE AMT", "PM SETTABLE AMT", "AUR Duration", "AUR SETTABLE AMT", "I/D Duration", "I/D SETTABLE AMT", "CM vs AUR Duration", "CM vs AUR SETTABLE AMT", "CM_RATE/MIN", "PM_RATE/MIN", "Output Sum of Quantity (Settable duration)", "Output Sum of Amount", "Difference Duration", "Difference Amount", currency
        FROM dswtdir3_aprm_dbo.tvaprm_voice_innove_comparison2rptsel;
END;
$procedure$
