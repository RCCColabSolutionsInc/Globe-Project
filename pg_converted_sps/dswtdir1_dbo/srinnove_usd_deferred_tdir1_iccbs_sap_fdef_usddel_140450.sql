CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usddel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 10/15/2020 12:33:59 PM
Description: Insert sap_fdef_USD into ttInnove_USD_Deferred
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usddelsel;
END;
$procedure$
