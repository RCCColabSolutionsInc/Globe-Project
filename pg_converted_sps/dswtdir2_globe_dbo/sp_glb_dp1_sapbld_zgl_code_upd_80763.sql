CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zgl_code_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Shen Joseph S 11/20/2020
Modified by: Shen Joseph S 11/20/2020
Description: GL_Code
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zgl_codeupdsel
    SET zgl_code = zgl_codenew;
END;
$procedure$
