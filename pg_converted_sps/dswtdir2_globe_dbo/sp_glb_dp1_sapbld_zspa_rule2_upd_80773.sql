CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zspa_rule2_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/26/2020
Modified by: Pradeep Gupta 11/26/2020
Description: SPA for blank
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zspa_rule2updsel
    SET zspa = zspanew;
END;
$procedure$
