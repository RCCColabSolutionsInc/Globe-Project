CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_column05_batch()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 12/17/2020
Modified by: Debojit Roy 12/17/2020
Description:
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp3_unbilled_char_tdir2_globe_sap_aiuc_g_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;
$procedure$
