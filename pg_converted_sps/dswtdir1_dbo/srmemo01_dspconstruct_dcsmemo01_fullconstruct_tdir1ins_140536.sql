CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_dspconstruct_dcsmemo01_fullconstruct_tdir1ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/5/2020 8:05:32 PM
Description: Insert DSPConstruct into ttMEMO01
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttmemo01 (zsource)
    SELECT
        zsource
        FROM dswtdir1_dbo.srMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1InsSel;
END;
$procedure$
