CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp4_unbilled_adj_zloaded_0_error_lineupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 04/16/2021
Modified by: Pradeep Gupta 04/16/2021
Description: Update all records as not loaded if any error
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp4_unbilled_adj_zloaded_0_error_lineupdsel
    SET zloaded = zloadednew;
END;
$procedure$
