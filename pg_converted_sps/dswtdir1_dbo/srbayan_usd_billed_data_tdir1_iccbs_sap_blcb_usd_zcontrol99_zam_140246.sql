CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zam()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/03/2020
Modified by: Sindhuja Beram 09/19/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zamountupdsel
    SET zcontrol99_zamount = zcontrol99_zamountnew;
END;
$procedure$
