CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_i_zdsp_orderu()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:21:11 AM
Specification: cMap:TDIR2_Innove:stInnove_Unconfirmed_TDIR2_Innove_sap_aiuc_unconf_I:sap_aiuc_unconf_I:zDSP_Order
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unconfirmed_tdir2_innove_sap_aiuc_unconf_i_zdsp_orderupdsel
    SET zdsp_order = zdsp_ordernew;
END;
$procedure$
