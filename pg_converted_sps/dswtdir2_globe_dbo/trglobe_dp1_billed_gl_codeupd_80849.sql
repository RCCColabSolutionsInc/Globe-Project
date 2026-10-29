CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_gl_codeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/06/2020
Modified by: Pradeep Gupta 11/06/2020
Description: Update GL Code
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_gl_codeupdsel
    SET gl_code = gl_codenew;
END;
$procedure$
