CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allpropdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 3/21/2021 1:10:36 PM
Description: Insert TDIR2_MemoApp into ttMEMOAPP_Scenario
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allpropdelsel;
END;
$procedure$
