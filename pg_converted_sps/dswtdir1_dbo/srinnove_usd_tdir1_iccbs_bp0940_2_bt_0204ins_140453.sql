CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_tdir1_iccbs_bp0940_2_bt_0204ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/3/2020 10:56:15 PM
Description: Insert TDIR1_ICCBS into ttInnove_USD
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttinnove_usd (zlegacyztest1, ztest1, ztest2, ztest3, zactive, zsource, zduplicate)
    SELECT
        zlegacyztest1, ztest1, ztest2, ztest3, zactive, zsource, zduplicate
        FROM dswtdir1_dbo.srinnove_usd_tdir1_iccbs_bp0940_2_bt_0204inssel;
END;
$procedure$
