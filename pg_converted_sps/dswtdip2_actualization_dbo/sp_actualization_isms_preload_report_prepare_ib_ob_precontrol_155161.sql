CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_ib_ob_precontrol()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_ib_ob_precontrol_cache;
    INSERT INTO dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_ib_ob_precontrol_cache ("PARTNER CODE", direction, doc_date, "Posting Date", "ACCRUAL (INPUT) AMOUNT", "ACCRUAL (PER SAP) AMOUNT", "ACCRUAL (INPUT VS SAP) AMOUNT")
    SELECT
        "PARTNER CODE", direction, doc_date, "Posting Date", "ACCRUAL (INPUT) AMOUNT", "ACCRUAL (PER SAP) AMOUNT", "ACCRUAL (INPUT VS SAP) AMOUNT"
        FROM dswtdip2_actualization_dbo.tvactualization_isms_ib_ob_precontrolrptsel;
END;
$procedure$
