CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp1_billed_gl_code1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/06/2020
Modified by: Pradeep Gupta 11/06/2020
Description: gl
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp1_billed_gl_code1updsel
    SET gl_code = gl_codenew;
END;
$procedure$
