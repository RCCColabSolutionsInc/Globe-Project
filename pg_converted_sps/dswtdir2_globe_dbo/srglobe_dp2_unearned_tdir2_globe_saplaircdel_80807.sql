CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0021 2/1/2021 4:19:54 AM
Description: Insert TDIR2_Globe into ttGlobe_DP2_Unearned
*/
BEGIN
    DELETE FROM dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplaircdelsel;
END;
$procedure$
