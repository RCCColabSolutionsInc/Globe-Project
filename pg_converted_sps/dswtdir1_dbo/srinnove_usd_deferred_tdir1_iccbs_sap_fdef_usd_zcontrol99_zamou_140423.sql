CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zamou()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 07/30/2020
Modified by: Sindhuja Beram 09/18/2020
Description: Updates Footer zAmount as column4 from flat file sap_fdef_USD
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zcontrol99_zamountupdsel
    SET zcontrol99_zamount = zcontrol99_zamountnew;
END;
$procedure$
