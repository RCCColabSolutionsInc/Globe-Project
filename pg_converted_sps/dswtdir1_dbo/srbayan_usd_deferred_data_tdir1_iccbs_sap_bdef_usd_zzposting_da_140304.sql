CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zzposting_da()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/3/2020 2:01:28 AM
Specification: cMap:TDIR1_ICCBS:stBayan_USD_Deferred_Data_TDIR1_ICCBS_sap_bdef_USD:sap_bdef_USD:zPosting_Date
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zzposting_dateupdsel
    SET zzposting_date = zzposting_datenew;
END;
$procedure$
