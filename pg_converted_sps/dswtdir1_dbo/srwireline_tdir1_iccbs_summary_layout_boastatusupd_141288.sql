CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_boastatusupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/9/2020 12:15:24 AM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_Summary_Layout:#SOURCEDATABASEOBJECT#:boaStatus
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_boastatusupdsel
    SET boastatus = boastatusnew;
END;
$procedure$
