CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/16/2020 1:44:00 AM
Description: Insert TDIR1_MemoApp into ttMEMO_Postload
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttmemo_postload (zlegacyzreference, zlegacyzdoc_date, zlegacyzpk, zlegacyztext, zlegacyzgl_created, zlegacyzgl_acct, zlegacyzposting_date, zloaderror, zspoolmessage, zsource)
    SELECT
        zlegacyzreference, zlegacyzdoc_date, zlegacyzpk, zlegacyztext, zlegacyzgl_created, zlegacyzgl_acct, zlegacyzposting_date, zloaderror, zspoolmessage, zsource
        FROM dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01inssel;
END;
$procedure$
