CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zfranchise_areaupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/14/2020 3:17:51 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Billed_TDIR1_ICCBS_sap_falcon_billed_volvo_072020_for:sap_falcon_billed_volvo_072020_for:zFranchise_Area
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zfranchise_areaupdsel
    SET zfranchise_area = zfranchise_areanew;
END;
$procedure$
