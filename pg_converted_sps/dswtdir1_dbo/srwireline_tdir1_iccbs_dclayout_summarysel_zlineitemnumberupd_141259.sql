CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zlineitemnumberupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 8/21/2020 5:29:25 PM
Specification: cMap:TDIR1_ICCBS:stWireline_TDIR1_ICCBS_dcLayout_SummarySel:dcLayout_SummarySel:zLineItemNumber
*/
BEGIN
    UPDATE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summarysel_zlineitemnumberupdsel
    SET zlineitemnumber = zlineitemnumbernew;
END;
$procedure$
