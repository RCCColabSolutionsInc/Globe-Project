CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_i_column05_batchno_()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 12/14/2020
Modified by: Debojit Roy 12/14/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unearned_msf_tdir2_innove_sap_airc_i_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
