CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_spbupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/06/2020
Modified by: Pradeep Gupta 11/06/2020
Description: Update Sub Product B
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_spbupdsel
    SET spb = spbnew;
END;
$procedure$
