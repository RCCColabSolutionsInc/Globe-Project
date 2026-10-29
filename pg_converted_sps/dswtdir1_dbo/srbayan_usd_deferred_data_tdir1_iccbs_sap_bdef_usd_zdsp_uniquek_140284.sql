CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zdsp_uniquek()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 09/17/2020
Modified by: Swetha Neha 09/17/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zdsp_uniquekeyupdsel
    SET zdsp_uniquekey = zdsp_uniquekeynew;
END;
$procedure$
