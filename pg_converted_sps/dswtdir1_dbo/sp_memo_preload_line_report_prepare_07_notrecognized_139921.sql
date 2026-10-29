CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_report_prepare_07_notrecognized()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.memo_preload_line_report_prepare_07_notrecognized_cache;
    INSERT INTO dswtdir1_dbo.memo_preload_line_report_prepare_07_notrecognized_cache (zinputfilename, zrownumber, zcounter_scninitial, zcounterlineitem_scninitial, zscenario_scninitial, zscenario_counts_scninitial, number_of_scenarios_overlap, invoice_number, vendor_code, vat_code, accrual_doc_number, input_vat_amount, company_code, gl_natural_code, cost_center_code, description, assignment, gross_invoice_amount, memoapp_ref_no_or_proponents_name, invoice_date, vendor_name, zlegacyzscenariotable_internalkey, zscenario_counter_orderby_scninitial, zscenario_zrownumber_min_scninitial, zscenario_zrownumber_max_scninitial, zscenario1, zscenario2, zscenario3, zscenario4, zscenario5, zscenario2_inscn6, zscenario3_inscn6, zscenario4_inscn6, zscenario5_inscn6, zscenario8r, zscenario8m, zscenario9, zscenario10, zerrormessage)
    SELECT
        zinputfilename, zrownumber, zcounter_scninitial, zcounterlineitem_scninitial, zscenario_scninitial, zscenario_counts_scninitial, number_of_scenarios_overlap, invoice_number, vendor_code, vat_code, accrual_doc_number, input_vat_amount, company_code, gl_natural_code, cost_center_code, description, assignment, gross_invoice_amount, memoapp_ref_no_or_proponents_name, invoice_date, vendor_name, zlegacyzscenariotable_internalkey, zscenario_counter_orderby_scninitial, zscenario_zrownumber_min_scninitial, zscenario_zrownumber_max_scninitial, zscenario1, zscenario2, zscenario3, zscenario4, zscenario5, zscenario2_inscn6, zscenario3_inscn6, zscenario4_inscn6, zscenario5_inscn6, zscenario8r, zscenario8m, zscenario9, zscenario10, zerrormessage
        FROM dswtdir1_dbo.tvmemoapp_scenario_not_identified_error_rptsel AS x;
END;
$procedure$
