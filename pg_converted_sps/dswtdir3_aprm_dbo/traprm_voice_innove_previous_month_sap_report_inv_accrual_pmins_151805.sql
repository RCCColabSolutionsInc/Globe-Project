CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pmins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 03/17/2021
Modified by: Debojit Roy 03/17/2021
Description: Insert Current Month Data into Previous Month Table
*/
BEGIN
    INSERT INTO dswtdir3_aprm_dbo.sap_report_inv_accrual_pm ("ACTUAL DURATION", "BP END DATE", brand, "CHARGE DIRECTION", currency, "CUSTOMER SUBTYPE", "CUSTOMER TYPE", direction, "INBOUND ROAMER INDICATOR", "INTERCONNECT PARTNER CODE", "INTERCONNECT PARTNER NAME", "NET SETTABLE AMT", "NO OF CALLS", "NO OF SUBSCRIPTIONS", "ORIG BP DATE", "RATING TYPE", "SAP VENDOR CODE", service, "SETTABLE DURATION", "SUB SERVICE TYPE", "TAX AMOUNT", "TRAFFIC STREAM")
    SELECT
        "ACTUAL DURATION", "BP END DATE", brand, "CHARGE DIRECTION", currency, "CUSTOMER SUBTYPE", "CUSTOMER TYPE", direction, "INBOUND ROAMER INDICATOR", "INTERCONNECT PARTNER CODE", "INTERCONNECT PARTNER NAME", "NET SETTABLE AMT", "NO OF CALLS", "NO OF SUBSCRIPTIONS", "ORIG BP DATE", "RATING TYPE", "SAP VENDOR CODE", service, "SETTABLE DURATION", "SUB SERVICE TYPE", "TAX AMOUNT", "TRAFFIC STREAM"
        FROM dswtdir3_aprm_dbo.traprm_voice_innove_previous_month_sap_report_inv_accrual_pminssel;
END;
$procedure$
