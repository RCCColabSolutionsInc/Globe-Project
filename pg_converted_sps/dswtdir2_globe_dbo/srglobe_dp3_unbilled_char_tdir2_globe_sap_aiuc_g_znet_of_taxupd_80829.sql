CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_znet_of_taxupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 12/01/2020
Modified by: Debojit Roy 12/01/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_znet_of_taxupdsel
    SET znet_of_tax = znet_of_taxnew;
END;
$procedure$
