CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zprofit_ctr_forrevgl_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/25/2021
Modified by: Pradeep Gupta 03/25/2021
Description: Profit Center #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zprofit_ctr_forrevgl_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
