CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layoutdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 9/8/2020 11:28:19 PM
Description: Insert TDIR1_ICCBS into ttWireline
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srwireline_tdir1_iccbs_summary_layoutdelsel;
END;
$procedure$
