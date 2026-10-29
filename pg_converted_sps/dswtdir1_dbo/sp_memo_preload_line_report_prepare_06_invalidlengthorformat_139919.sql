CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_report_prepare_06_invalidlengthorformat()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dswtdir1_dbo.memo_preload_line_report_prepare_06_invalidlengthorformat_cache;
    INSERT INTO dswtdir1_dbo.memo_preload_line_report_prepare_06_invalidlengthorformat_cache (zproponent, zcounter, zcounterlineitem, zscenario, errormessage, zerror_counter, zerror_lineitem, zlegacyzvendor_code, zlegacyzinvoice_number, zlegacyzvat_code, zlegacyzdescription, zlegacyzgl_natural_code, zlegacyzcost_center_code, zlegacyzinput_vat_amount, zpk, zvendor_code, zinvoice_number, zvat_code, zdescription, zgl_natural_code, zcost_center_code, zinput_vat_amount, zdoc_date, ztype, zcocd, zcurr, zperiod, zreference, zdocument_header_text, zvendor_gl_acct, zamount_in_doc_curr, zwbs_element, zcost_ctr, ztext, zvat_tax_code, zwithholding_tax_base, zwithholding_tax_type, zwitholding_tax_code, zpayment_method, zdsp_uniquekey, zdsp_order, zsaknr_ska1, ztxt50_skat, zscenario_counts, zinputfileprocessed_date, zroutedforload_date, zsource, zlegacyzinputfilename, zlegacyrownumber, zerrormessage, zerrormessage_new, zerror_sourcevalues, zcounter_scninitial)
    SELECT
        zproponent, zcounter, zcounterlineitem, zscenario, errormessage, zerror_counter, zerror_lineitem, zlegacyzvendor_code, zlegacyzinvoice_number, zlegacyzvat_code, zlegacyzdescription, zlegacyzgl_natural_code, zlegacyzcost_center_code, zlegacyzinput_vat_amount, zpk, zvendor_code, zinvoice_number, zvat_code, zdescription, zgl_natural_code, zcost_center_code, zinput_vat_amount, zdoc_date, ztype, zcocd, zcurr, zperiod, zreference, zdocument_header_text, zvendor_gl_acct, zamount_in_doc_curr, zwbs_element, zcost_ctr, ztext, zvat_tax_code, zwithholding_tax_base, zwithholding_tax_type, zwitholding_tax_code, zpayment_method, zdsp_uniquekey, zdsp_order, zsaknr_ska1, ztxt50_skat, zscenario_counts, zinputfileprocessed_date, zroutedforload_date, zsource, zlegacyzinputfilename, zlegacyrownumber, zerrormessage, zerrormessage_new, zerror_sourcevalues, zcounter_scninitial
        FROM dswtdir1_dbo.tvmemoapp_preload_zerror_sourcevalues_r2_rptsel AS x
        ORDER BY CAST (x.zdsp_order AS INTEGER) NULLS FIRST;
END;
$procedure$
