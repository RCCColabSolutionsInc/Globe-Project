CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.trglobe_dp2_unearned_zloaded_1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/12/2021
Modified by: Elakki K 03/12/2021
Description: Loaded Records
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.trglobe_dp2_unearned_zloaded_1updsel
    SET zloaded = zloadednew;
END;
$procedure$
