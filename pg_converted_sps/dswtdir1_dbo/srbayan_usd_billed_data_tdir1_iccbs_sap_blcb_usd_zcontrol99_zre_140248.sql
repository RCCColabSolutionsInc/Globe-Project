CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zre()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/24/2020 11:39:55 PM
Specification: cMap:TDIR1_ICCBS:stBayan_USD_Billed_Data_TDIR1_ICCBS_sap_blcb_USD:sap_blcb_USD:zControl99_zRecord
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zcontrol99_zrecordupdsel
    SET zcontrol99_zrecord = zcontrol99_zrecordnew;
END;
$procedure$
