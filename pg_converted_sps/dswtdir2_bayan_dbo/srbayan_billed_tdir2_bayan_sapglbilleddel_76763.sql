CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilleddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/15/2021 11:58:52 PM
Description: Insert TDIR2_Bayan into ttBayan_Billed
*/
BEGIN
    DELETE FROM dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilleddelsel;
END;
$procedure$
