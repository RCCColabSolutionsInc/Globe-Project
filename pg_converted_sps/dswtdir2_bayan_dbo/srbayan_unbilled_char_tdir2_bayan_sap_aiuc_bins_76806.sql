CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_bins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:14 AM
Description: Insert TDIR2_Bayan into ttBayan_Unbilled_Char
*/
BEGIN
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_unbilled_char (zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_binssel;
END;
$procedure$
