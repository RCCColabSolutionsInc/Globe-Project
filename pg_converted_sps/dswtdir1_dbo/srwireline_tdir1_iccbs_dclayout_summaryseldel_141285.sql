CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summaryseldel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 8/21/2020 5:29:23 PM
Description: Insert TDIR1_ICCBS into ttWireline
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srwireline_tdir1_iccbs_dclayout_summaryseldelsel;
END;
$procedure$
