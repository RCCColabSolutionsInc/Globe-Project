CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zainvupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/11/2020 2:46:52 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP2_Unearned_TDIR2_Globe_saplairc:saplairc:AINV
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zainvupdsel
    SET zainv = zainvnew;
END;
$procedure$
