CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.trinnove_billed_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Debojit Roy 03/26/2021
Modified by: Debojit Roy 03/26/2021
Description: Updates zloaded
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.trinnove_billed_zloaded_updsel
    SET zloaded = CAST(zloadednew AS INTEGER);
END;
$procedure$
