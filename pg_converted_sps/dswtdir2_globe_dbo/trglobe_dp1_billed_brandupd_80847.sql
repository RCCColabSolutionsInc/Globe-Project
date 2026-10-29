CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_brandupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/20/2020
Modified by: Pradeep Gupta 11/20/2020
Description: Update Brand
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_brandupdsel
    SET brand = brandnew;
END;
$procedure$
