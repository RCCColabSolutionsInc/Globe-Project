CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layoutdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 9/8/2020 11:25:16 PM
Description: Insert TDIR1_ICCBS into ttWireline_BT
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srwireline_bt_tdir1_iccbs_bt_layoutdelsel;
END;
$procedure$
