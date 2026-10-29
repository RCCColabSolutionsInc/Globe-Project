CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zcycle_codeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/27/2020 2:35:43 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:Cycle_Code
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zcycle_codeupdsel
    SET zcycle_code = zcycle_codenew;
END;
$procedure$
