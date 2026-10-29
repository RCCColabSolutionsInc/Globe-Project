CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zgl_zspbupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 11/23/2020
Modified by: Debojit Roy 11/23/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_zgl_zspbupdsel
    SET zgl = zglnew, zspb = zspbnew;
END;
$procedure$
