CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zdataupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:55 AM
Specification: cMap:TDIR2_Globe:stGlobe_DP2_Unearned_TDIR2_Globe_saplairc:saplairc:Data
*/
BEGIN
    -- Fixed: Updating the base table directly using a FROM clause
    UPDATE dswtdir2_globe_dbo.stglobe_dp2_unearned_tdir2_globe_saplairc AS base
    SET zdata = map.zdatanew
    FROM dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zdataupdsel AS map
    WHERE base.id = map.id; -- Replace 'id' with your actual primary key / join column
END;
$procedure$
