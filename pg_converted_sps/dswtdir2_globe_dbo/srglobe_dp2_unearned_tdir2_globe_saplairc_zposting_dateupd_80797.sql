CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zposting_dateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 ON: 2/1/2021 4:19:55 AM
Specification: cMap:TDIR2_Globe:stGlobe_DP2_Unearned_TDIR2_Globe_saplairc:saplairc:Posting_Date
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zposting_dateupdsel
    SET zposting_date = zposting_datenew;
END;
$procedure$
