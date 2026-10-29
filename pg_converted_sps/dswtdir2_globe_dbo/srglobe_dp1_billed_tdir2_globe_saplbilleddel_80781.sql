CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilleddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 2/1/2021 10:45:31 AM
Description: Insert TDIR2_Globe into ttGlobe_DP1_Billed
*/
BEGIN
    DELETE FROM dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilleddelsel;
END;
$procedure$
