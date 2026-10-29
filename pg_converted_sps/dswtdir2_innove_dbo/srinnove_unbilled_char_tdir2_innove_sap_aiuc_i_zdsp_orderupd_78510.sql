CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zdsp_orderupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:20:37 AM
Specification: cMap:TDIR2_Innove:stInnove_Unbilled_Char_TDIR2_Innove_sap_aiuc_I:sap_aiuc_I:zDSP_Order
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
