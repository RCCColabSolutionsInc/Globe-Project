CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_dcoutput_tdir1_memoapp_ttmemo01ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/9/2020 9:18:39 PM
Description: Insert TDIR1_MemoApp into ttMemo_dcOutput
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttmemo_dcoutput (zlegacyzdoc_date, zlegacyzreference, zlegacyzpk, zlegacyztext, zsource)
    SELECT
        zlegacyzdoc_date, zlegacyzreference, zlegacyzpk, zlegacyztext, zsource
        FROM dswtdir1_dbo.srmemo_dcoutput_tdir1_memoapp_ttmemo01inssel;
END;
$procedure$
