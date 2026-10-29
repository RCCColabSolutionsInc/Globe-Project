CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemo_postload_zloaderror_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 07/07/2020
Modified by: Swetha Neha 07/07/2020
Description: Updating Load Error
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemo_postload_zloaderror_updsel
    SET zloaderror = zloaderrornew;
END;
$procedure$
