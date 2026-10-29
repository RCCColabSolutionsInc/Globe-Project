CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.trbayan_unbilled_char_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 03/26/2021
Modified by: Debojit Roy 03/26/2021
Description: Loaded Records
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.trbayan_unbilled_char_zloaded_updsel
    SET zloaded = zloadednew;
END;
$procedure$
