CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_b_column05_batchno_u()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 01/12/2021
Modified by: Elakki K 01/15/2021
Description: updates batch number
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unbilled_char_tdir2_bayan_sap_aiuc_b_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
