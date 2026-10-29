CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zzuniqueupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/6/2020 7:51:48 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:zUnique
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srGlobe_DP1_Billed_TDIR2_Globe_saplbilled_zzUniqueUpdSel
    SET zzUnique = zzUniqueNew;
END;
$procedure$
