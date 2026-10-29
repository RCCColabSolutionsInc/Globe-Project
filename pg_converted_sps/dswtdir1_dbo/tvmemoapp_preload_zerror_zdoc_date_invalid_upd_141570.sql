CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerror_zdoc_date_invalid_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/23/2021
Modified by: Elakki K 03/23/2021
Description: Invalid Doc Date
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerror_zdoc_date_invalid_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
