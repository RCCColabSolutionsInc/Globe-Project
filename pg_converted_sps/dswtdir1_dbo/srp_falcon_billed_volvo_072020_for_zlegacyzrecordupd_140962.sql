CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zlegacyzrecordupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/14/2020 3:17:50 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Billed_TDIR1_ICCBS_sap_falcon_billed_volvo_072020_for:sap_falcon_billed_volvo_072020_for:zLegacyzRecord
*/
BEGIN
    UPDATE dswtdir1_dbo.srp_falcon_billed_volvo_072020_for_zlegacyzrecordupdsel
    SET zlegacyzrecord = zlegacyzrecordnew;
END;
$procedure$
