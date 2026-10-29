CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zzvalue_03_inputupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 8/21/2020 3:07:18 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_dcLayout_SummarySel:dcLayout_SummarySel:zValue_03_Input
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zzvalue_03_inputupdsel
    SET zzvalue_03_input = zzvalue_03_inputnew;
END;
$procedure$
