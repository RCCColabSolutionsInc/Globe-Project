CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unconfirmed_adv_tdir2_innove_unconfirmed_advanced_msf_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 12/17/2020 3:48:22 AM
Description: Insert TDIR2_Innove into ttInnove_Unconfirmed_Adv
*/
BEGIN
    INSERT INTO dswtdir2_innove_dbo.ttinnove_unconfirmed_adv (zlegacydsp_order, posting_date, gl, cfu, access_type, plan_type, charge_code, posting_key, amount, zdsp_order, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, posting_date, gl, cfu, access_type, plan_type, charge_code, posting_key, amount, zdsp_order, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_innove_dbo.srinnove_unconfirmed_adv_tdir2_innove_unconfirmed_advanced_msf_charges_iinssel;
END;
$procedure$
