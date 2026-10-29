CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_i_column05_ba()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 01/27/2021
Modified by: Debojit Roy 01/27/2021
Description:
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_i_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
