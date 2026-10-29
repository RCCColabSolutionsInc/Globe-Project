CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_fieldsmissing_up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/25/2021
Modified by: Pradeep Gupta 03/25/2021
Description: Revenue GL Fields Missing #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_revenuegl_scn8_fieldsmissing_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
