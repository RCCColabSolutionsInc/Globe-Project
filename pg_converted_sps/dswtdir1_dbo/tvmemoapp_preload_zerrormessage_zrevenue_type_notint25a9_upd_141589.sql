CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zrevenue_type_notint25a9_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/20/2021
Modified by: Uma Guduru 03/29/2021
Description: Revenue Type Not Maintained in T25A9
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_zrevenue_type_notint25a9_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
