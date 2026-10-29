CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_postload_zloaded_pipe_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/08/2020
Modified by: Elakki K 09/08/2020
Description: With Pipe
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_postload_zloaded_pipe_updsel
    SET zloaded = zloadednew;
END;
$procedure$
