CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zamount_upd()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zamountupdsel
    SET zamount = CAST(NULLIF(zamountnew, '') AS double precision);
END;
$procedure$
