CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier3upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 9/8/2020 11:28:21 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_Summary_Layout:Summary_Layout:zValue_Cuml_Tier3
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layout_zvalue_cuml_tier3updsel
    SET zvalue_cuml_tier3 = zvalue_cuml_tier3new;
END;
$procedure$
