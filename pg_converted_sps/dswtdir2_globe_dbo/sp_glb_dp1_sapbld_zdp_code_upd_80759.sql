CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zdp_code_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:23 AM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:DP_Code
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zdp_codeupdsel
    SET zdp_code = zdp_codenew;
END;
$procedure$
