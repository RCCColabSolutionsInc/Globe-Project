CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_bins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:48 AM
Description: Insert TDIR2_Bayan into ttBayan_Unearned_MSF
*/
BEGIN
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_unearned_msf (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_binssel;
END;
$procedure$
