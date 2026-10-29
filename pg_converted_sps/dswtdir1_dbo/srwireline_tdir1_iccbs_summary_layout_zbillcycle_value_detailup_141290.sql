CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbillcycle_value_detailup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:28:21 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_Summary_Layout:Summary_Layout:zBillCycle_Value_Detail
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zbillcycle_value_detailupdsel
    SET zbillcycle_value_detail = zbillcycle_value_detailnew;
END;
$procedure$
