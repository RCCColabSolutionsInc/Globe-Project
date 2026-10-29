CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_glb_dp1_sapbld_zrev_type_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Shen Joseph S 11/20/2020
Modified by: Shen Joseph S 11/20/2020
Description: Revenue Type
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zrev_typeupdsel
    SET zrev_type = zrev_typenew;
END;
$procedure$
