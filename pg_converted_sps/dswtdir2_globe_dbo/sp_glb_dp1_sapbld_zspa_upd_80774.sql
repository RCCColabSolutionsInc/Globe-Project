CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zspa_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Shen Joseph S 11/20/2020
Modified by: Shen Joseph S 11/20/2020
Description: Sub Product A
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zspaupdsel
    SET zspa = zspanew;
END;
$procedure$
