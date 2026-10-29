CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srlfa1_tdir1_iccbs_bp0940_2_gt_0204ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/3/2020 11:41:17 PM
Description: Insert TDIR1_ICCBS into ttLFA1
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttlfa1 (zlegacymandt, zlegacylifnr, zlegacyland1, mandt, lifnr, land1, name1, name2, name3, zactive, zsource, zduplicate)
    SELECT
        zlegacymandt, zlegacylifnr, zlegacyland1, mandt, lifnr, land1, name1, name2, name3, zactive, zsource, zduplicate
        FROM dswtdir1_dbo.srlfa1_tdir1_iccbs_bp0940_2_gt_0204inssel;
END;
$procedure$
