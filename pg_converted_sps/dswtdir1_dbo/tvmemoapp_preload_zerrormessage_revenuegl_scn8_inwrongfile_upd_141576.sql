CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_inwrongfile_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/25/2021
Modified by: Elakki K 03/30/2021
Description: Revenue GL in Wrong File #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_inwrongfile_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
