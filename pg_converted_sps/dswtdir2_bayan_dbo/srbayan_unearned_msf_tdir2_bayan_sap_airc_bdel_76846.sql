CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_bdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:21:48 AM
Description: Insert TDIR2_Bayan into ttBayan_Unearned_MSF
*/
BEGIN
    DELETE FROM dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_bdelsel;
END;
$procedure$
