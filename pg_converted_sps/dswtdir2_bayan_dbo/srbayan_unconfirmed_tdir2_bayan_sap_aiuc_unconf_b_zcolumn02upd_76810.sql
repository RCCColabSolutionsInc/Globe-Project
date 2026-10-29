CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_b_zcolumn02upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:57 AM
Specification: cMap:TDIR2_Bayan:stBayan_Unconfirmed_TDIR2_Bayan_sap_aiuc_unconf_B:sap_aiuc_unconf_B:Column02
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unconfirmed_tdir2_bayan_sap_aiuc_unconf_b_zcolumn02updsel
    SET zcolumn02 = zcolumn02new;
END;
$procedure$
