CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_insert_into_dcmemoapp_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 08/07/2020
Modified by: BOAADMIN SUPPORT 08/07/2020
Description: Inserting into DCMEmoApp
*/
BEGIN
    INSERT INTO dswtdir1_dbo.dcmemoapp (zamount_in_doc_curr, zcocd, zcost_center_code, zcost_ctr, zcounter, zcurr, zdescription, zdoc_date, zdocument_header_text, zdsp_order, zdsp_uniquekey, zerrormessage, zgl_acct, zgl_natural_code, zinput_filename, zinput_vat_amount, zinvoice_number, zlegacyzcost_center_code, zlegacyzdescription, zlegacyzgl_natural_code, zlegacyzinput_vat_amount, zlegacyzinvoice_number, zlegacyzvat_code, zlegacyzvendor_code, zpayment_method, zperiod, zpk, zreference, zrownumber, zsaknr_ska1, zscenario, zsource, ztext, ztxt50_skat, ztype, zvat_code, zvat_tax_code, zvendor_code, zwbs_element, zwithholding_tax_base, zwithholding_tax_type, zwitholding_tax_code, zz_upld_filename)
    SELECT
        zamount_in_doc_curr, zcocd, zcost_center_code, zcost_ctr, zcounter, zcurr, zdescription, zdoc_date, zdocument_header_text, zdsp_order, zdsp_uniquekey, zerrormessage, zgl_acct, zgl_natural_code, zinput_filename, zinput_vat_amount, zinvoice_number, zlegacyzcost_center_code, zlegacyzdescription, zlegacyzgl_natural_code, zlegacyzinput_vat_amount, zlegacyzinvoice_number, zlegacyzvat_code, zlegacyzvendor_code, zpayment_method, zperiod, zpk, zreference, zrownumber, zsaknr_ska1, zscenario, zsource, ztext, ztxt50_skat, ztype, zvat_code, zvat_tax_code, zvendor_code, zwbs_element, zwithholding_tax_base, zwithholding_tax_type, zwitholding_tax_code, zz_upld_filename
        FROM dswtdir1_dbo.trMEMOAPP_Preload_Insert_Into_DcMemoApp_InsSel;
END;
$procedure$
