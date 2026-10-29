CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zdsp_orderupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/14/2020 3:17:50 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Billed_TDIR1_ICCBS_sap_falcon_billed_volvo_072020_for:sap_falcon_billed_volvo_072020_for:zDSP_Order
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
