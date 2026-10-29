CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspbupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/23/2020
Modified by: Pradeep Gupta 11/23/2020
Description: Sub Product B
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zspbupdsel
    SET zspb = zspbnew;
END;
$procedure$
