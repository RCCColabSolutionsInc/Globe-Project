CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zbrand_notint25a1_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/20/2021
Modified by: Uma Guduru 03/29/2021
Description: Brand Not Maintained in T25A1 table in SAP
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zbrand_notint25a1_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
