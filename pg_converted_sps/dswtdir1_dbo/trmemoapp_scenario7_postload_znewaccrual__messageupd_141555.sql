CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_scenario7_postload_znewaccrual__messageupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/09/2020
Modified by: Elakki K 09/09/2020
Description: New Accrual Message Update
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_scenario7_postload_znewaccrual__messageupdsel
    SET znewaccrual_message = znewaccrual_messagenew;
END;
$procedure$
