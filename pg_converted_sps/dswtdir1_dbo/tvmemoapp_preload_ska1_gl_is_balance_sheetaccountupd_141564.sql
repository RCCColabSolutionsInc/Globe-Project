CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_is_balance_sheetaccountupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Elakki K 03/25/2021
Description: GL Is a Balance Sheet Account #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_ska1_gl_is_balance_sheetaccountupdsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
