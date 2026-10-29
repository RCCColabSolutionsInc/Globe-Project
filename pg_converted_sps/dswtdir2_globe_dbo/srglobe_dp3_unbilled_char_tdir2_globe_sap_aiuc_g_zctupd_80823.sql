CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zctupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 11/23/2020
Modified by: Debojit Roy 11/23/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zctupdsel
    SET zcharge_code = zcharge_codenew, zct = zctnew, zst = zstnew, zunbilled_charges = zunbilled_chargesnew;
END;
$procedure$
