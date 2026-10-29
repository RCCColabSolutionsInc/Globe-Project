CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zrevenue_ite()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/24/2020
Modified by: Sindhuja Beram 09/24/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zrevenue_item_code_zffi_rev_servupdsel
    SET zrevenue_item_code = zrevenue_item_codenew;
END;
$procedure$
