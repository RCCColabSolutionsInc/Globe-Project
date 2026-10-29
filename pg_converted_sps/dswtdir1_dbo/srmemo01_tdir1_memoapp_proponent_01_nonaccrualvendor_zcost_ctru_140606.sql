CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zcost_ctru()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 ON: 7/23/2020 11:14:54 PM
Specification: cMap:TDIR1_MemoApp:stMEMO01_TDIR1_MemoApp_Proponent_01_NonAccrualVendor:Proponent_01_NonAccrualVendor:zCost_ctr
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendor_zcost_ctrupdsel
    SET zcost_ctr = zcost_ctrnew;
END;
$procedure$
