CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scn8r_nonrevenuegl_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/25/2021
Modified by: Uma Guduru 03/25/2021
Description: tvMEMOAPP_Preload_zErrorMessage_Scn8R_NonRevenueGL_UpdSel
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_scn8r_nonrevenuegl_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
