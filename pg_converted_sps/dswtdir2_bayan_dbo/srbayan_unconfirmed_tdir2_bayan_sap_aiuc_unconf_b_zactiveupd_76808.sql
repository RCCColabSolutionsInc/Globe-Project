CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_b_zactiveupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 01/27/2021
Modified by: Debojit Roy 01/27/2021
Description:
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_b_zactiveupdsel
    SET zactive = zactivenew;
END;
$procedure$
