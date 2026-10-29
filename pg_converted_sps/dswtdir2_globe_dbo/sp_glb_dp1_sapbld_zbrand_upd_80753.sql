CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zbrand_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/20/2020
Modified by: Pradeep Gupta 11/20/2020
Description: Update Brand
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zbrandupdsel
    SET zbrand = zbrandnew;
END;
$procedure$
