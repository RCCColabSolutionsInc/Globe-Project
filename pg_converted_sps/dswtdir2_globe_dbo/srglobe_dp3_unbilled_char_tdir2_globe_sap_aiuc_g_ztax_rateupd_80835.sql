CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_ztax_rateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 12/01/2020
Modified by: Debojit Roy 12/01/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_ztax_rateupdsel
    SET ztax_rate = ztax_ratenew;
END;
$procedure$
