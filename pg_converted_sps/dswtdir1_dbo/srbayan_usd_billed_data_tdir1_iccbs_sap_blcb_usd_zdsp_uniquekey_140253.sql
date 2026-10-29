CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zdsp_uniquekey()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 09/17/2020
Modified by: Swetha Neha 09/17/2020
Description: Updates zDSP_UniqueKey
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zdsp_uniquekeyupdsel
    SET zdsp_uniquekey = zdsp_uniquekeynew;
END;
$procedure$
