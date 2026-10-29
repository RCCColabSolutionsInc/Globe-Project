CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_is_not_revenueaccountupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/20/2021
Modified by: Elakki K 03/25/2021
Description: GL Account is Not a Revenue Account
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_is_not_revenueaccountupdsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
