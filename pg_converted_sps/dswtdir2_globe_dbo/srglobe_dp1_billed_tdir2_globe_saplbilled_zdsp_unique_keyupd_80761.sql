CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdsp_unique_keyupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 1/29/2021 1:28:46 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:zDSP_Unique_Key
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdsp_unique_keyupdsel
    SET zdsp_unique_key = zdsp_unique_keynew;
END;
$procedure$
