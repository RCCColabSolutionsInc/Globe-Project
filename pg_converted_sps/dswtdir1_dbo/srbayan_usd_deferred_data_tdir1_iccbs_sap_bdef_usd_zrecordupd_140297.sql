CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zrecordupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/24/2020 7:22:22 PM
Specification: cMap:TDIR1_ICCBS:stBayan_USD_Deferred_Data_TDIR1_ICCBS_sap_bdef_USD:sap_bdef_USD:zRecord
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zrecordupdsel
    SET zrecord = zrecordnew;
END;
$procedure$
