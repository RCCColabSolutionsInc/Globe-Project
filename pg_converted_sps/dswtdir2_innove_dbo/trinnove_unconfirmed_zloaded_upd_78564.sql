CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.trinnove_unconfirmed_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 04/19/2021
Modified by: Pradeep Gupta 04/19/2021
Description: updating loaded flag
*/
BEGIN
    UPDATE dswtdir2_innove_dbo.trinnove_unconfirmed_zloaded_updsel
    SET zloaded = zloadednew;
END;
$procedure$
