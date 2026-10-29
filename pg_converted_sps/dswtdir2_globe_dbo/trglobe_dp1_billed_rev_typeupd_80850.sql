CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_rev_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/20/2020
Modified by: Pradeep Gupta 11/20/2020
Description: Update Revenue Type
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_rev_typeupdsel
    SET rev_type = rev_typenew;
END;
$procedure$
