CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zbatch_numberupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/19/2020 5:25:16 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP1_Billed_TDIR2_Globe_saplbilled:saplbilled:Batch_Number
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp1_billed_tdir2_globe_saplbilled_zbatch_numberupdsel
    SET zbatch_number = zbatch_numbernew;
END;
$procedure$
