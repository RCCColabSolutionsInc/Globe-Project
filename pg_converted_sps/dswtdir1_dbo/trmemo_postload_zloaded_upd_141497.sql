CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemo_postload_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 07/07/2020
Modified by: Swetha Neha 07/07/2020
Description: Updating Loaded to 1 when matching data found in  BKPF
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemo_postload_zloaded_updsel
    SET zloaded = zloadednew;
END;
$procedure$
