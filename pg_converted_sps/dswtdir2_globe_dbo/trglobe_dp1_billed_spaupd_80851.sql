CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_spaupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/20/2020
Modified by: Pradeep Gupta 11/20/2020
Description: Update SubProduct A
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_spaupdsel
    SET spa = spanew;
END;
$procedure$
