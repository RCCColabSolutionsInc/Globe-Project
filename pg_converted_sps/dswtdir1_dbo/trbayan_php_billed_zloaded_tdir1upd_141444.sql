CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_billed_zloaded_tdir1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 11/03/2020
Modified by: Elakki K 11/03/2020
Description: Update zLoaded Flag - TDIR1
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_billed_zloaded_tdir1updsel
    SET zloaded = zloadednew;
END;
$procedure$
