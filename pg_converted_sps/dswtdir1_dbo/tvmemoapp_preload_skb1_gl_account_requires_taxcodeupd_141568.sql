CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_skb1_gl_account_requires_taxcodeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Uma Guduru 03/25/2021
Description: GL Account Requires Tax Code #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_skb1_gl_account_requires_taxcodeupdsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
