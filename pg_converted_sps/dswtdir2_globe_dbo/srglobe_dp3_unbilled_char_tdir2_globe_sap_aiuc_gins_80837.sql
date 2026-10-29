CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_gins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:54 AM
Description: Insert DP3_Unbilled_Char into ttGlobe_DP3_Unbilled_Char
*/
BEGIN
    INSERT INTO dswtdir2_globe_dbo.ttglobe_dp3_unbilled_char (zlegacydsp_order, posting_date, ct, st, charge_code, sum_of_amount, unbilled_charges, diff, tax_rate, tax, net_of_tax, spa, rev_type, gl, spb, remark, column01, zdsp_order, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, posting_date, ct, st, charge_code, sum_of_amount, unbilled_charges, diff, tax_rate, tax, net_of_tax, spa, rev_type, gl, spb, remark, column01, zdsp_order, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, zdsp_uniquekey, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_ginssel;
END;
$procedure$
