CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 7/16/2020 1:44:00 AM
Description: Insert TDIR1_MemoApp into ttMEMO_Postload
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemo_postload_tdir1_memoapp_ttmemo01delsel;
END;
$procedure$
