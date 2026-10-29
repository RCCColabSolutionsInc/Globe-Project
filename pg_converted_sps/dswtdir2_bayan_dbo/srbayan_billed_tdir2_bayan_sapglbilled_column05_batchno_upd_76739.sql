CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 02/08/2021
Modified by: Debojit Roy 02/08/2021
Description:
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_billed_tdir2_bayan_sapglbilled_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;

END;
$procedure$
