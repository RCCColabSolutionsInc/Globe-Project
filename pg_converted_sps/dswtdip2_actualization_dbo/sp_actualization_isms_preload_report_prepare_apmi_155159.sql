CREATE OR REPLACE PROCEDURE dswtdip2_actualization_dbo.sp_actualization_isms_preload_report_prepare_apmi()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_apmi_cache;
    INSERT INTO dswtdip2_actualization_dbo.actualization_isms_preload_report_prepare_apmi_cache ("Transacting Entity", "Invoice Period", "POSTING DATE", "SAP CODE", "Partner Transacting Entity", "Partner Transacting Entity Name", "Partner VAT ID", "Service Type", "Invoice Number", "Untaxed Clearing Currency (CC)", "Tax Amount Clearing Currency (CC)", "Taxed Amount Clearing Currency (CC)", "Message Count", "Settlement Currency (SC)", booking_c_outbound, "(CC) to (SC) Rate", "Untaxed (SC)", "Tax Amount (SC)", "Taxed Amount (SC)", rate, "FINAL INVOICE AMOUNT", "Narrative (Client DCH Diff)", "CC Amount (Client DCH Diff)", "SC Amount (Client DCH Diff)", "Narrative (RP'S Invoice Adj)", "CC Amount (RP'S Invoice Adj)", "SC Amount (RP'S Invoice Adj)", "Narrative (Payable Trans Adj)", "CC Amount (Payable Trans Adj)", "SC Amount (Payable Trans Adj)", agreed, cna, "Require Invoice")
    SELECT
        "Transacting Entity", "Invoice Period", "POSTING DATE", "SAP CODE", "Partner Transacting Entity", "Partner Transacting Entity Name", "Partner VAT ID", "Service Type", "Invoice Number", "Untaxed Clearing Currency (CC)", "Tax Amount Clearing Currency (CC)", "Taxed Amount Clearing Currency (CC)", "Message Count", "Settlement Currency (SC)", booking_c_outbound, "(CC) to (SC) Rate", "Untaxed (SC)", "Tax Amount (SC)", "Taxed Amount (SC)", rate, "FINAL INVOICE AMOUNT", "Narrative (Client DCH Diff)", "CC Amount (Client DCH Diff)", "SC Amount (Client DCH Diff)", "Narrative (RP'S Invoice Adj)", "CC Amount (RP'S Invoice Adj)", "SC Amount (RP'S Invoice Adj)", "Narrative (Payable Trans Adj)", "CC Amount (Payable Trans Adj)", "SC Amount (Payable Trans Adj)", agreed, cna, "Require Invoice"
        FROM dswtdip2_actualization_dbo.tvactualization_isms_apmi_rptsel;
END;
$procedure$
