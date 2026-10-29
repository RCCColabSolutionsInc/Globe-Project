CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn04upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:50 AM
Specification: cMap:TDIR2_Bayan:stBayan_Unearned_MSF_TDIR2_Bayan_sap_airc_B:sap_airc_B:Column04
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b_zcolumn04updsel
    SET zcolumn04 = zcolumn04new;
END;
$procedure$
