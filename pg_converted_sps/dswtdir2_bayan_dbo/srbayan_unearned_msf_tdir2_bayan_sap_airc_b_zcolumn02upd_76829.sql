CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn02upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:50 AM
Specification: cMap:TDIR2_Bayan:stBayan_Unearned_MSF_TDIR2_Bayan_sap_airc_B:sap_airc_B:Column02
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn02updsel
    SET zcolumn02 = zcolumn02new;
END;
$procedure$
