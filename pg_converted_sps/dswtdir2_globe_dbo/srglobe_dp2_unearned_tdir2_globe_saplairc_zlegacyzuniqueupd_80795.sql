CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zlegacyzuniqueupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0022 ON: 11/19/2020 12:18:38 PM
Specification: cMap:TDIR2_Globe:stGlobe_DP2_Unearned_TDIR2_Globe_saplairc:saplairc:zLegacyzUnique
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zlegacyzuniqueupdsel
    SET zlegacyzunique = zlegacyzuniquenew;
END;
$procedure$
