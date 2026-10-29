CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo_dcoutput_tdir1_memoapp_ttmemo01del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 7/9/2020 9:18:39 PM
Description: Insert TDIR1_MemoApp into ttMemo_dcOutput
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemo_dcoutput_tdir1_memoapp_ttmemo01delsel;
END;
$procedure$
