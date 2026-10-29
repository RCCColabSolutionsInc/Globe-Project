CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilledins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/15/2021 11:58:52 PM
Description: Insert TDIR2_Bayan into ttBayan_Billed
*/
BEGIN
    INSERT INTO dswtdir2_bayan_dbo.ttbayan_billed (zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message)
    SELECT
        zlegacydsp_order, zlegacycycle_code, column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, zactive, zsource, zduplicate, zloaded, zload_message
        FROM dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilledinssel;
END;
$procedure$
