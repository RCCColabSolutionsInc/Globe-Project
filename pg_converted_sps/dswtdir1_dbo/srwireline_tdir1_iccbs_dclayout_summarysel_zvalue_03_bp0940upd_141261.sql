CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zvalue_03_bp0940upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/21/2020 1:04:50 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_dcLayout_SummarySel:dcLayout_SummarySel:zValue_03_BP0940
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zvalue_03_bp0940updsel
    SET zvalue_03_bp0940 = zvalue_03_bp0940new;
END;
$procedure$
