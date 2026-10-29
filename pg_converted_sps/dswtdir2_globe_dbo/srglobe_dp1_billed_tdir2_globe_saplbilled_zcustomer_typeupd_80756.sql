CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zcustomer_typeupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/20/2020 3:51:25 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:Customer_Type
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zcustomer_typeupdsel
    SET zcustomer_type = zcustomer_typenew;
END;
$procedure$
