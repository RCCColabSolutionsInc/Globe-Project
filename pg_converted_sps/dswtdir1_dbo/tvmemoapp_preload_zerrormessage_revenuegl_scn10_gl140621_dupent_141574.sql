CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn10_gl140621_dupent()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/25/2021
Modified by: Pradeep Gupta 03/25/2021
Description: GL 14621 Dup Entry #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn10_gl140621_dupentry_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
