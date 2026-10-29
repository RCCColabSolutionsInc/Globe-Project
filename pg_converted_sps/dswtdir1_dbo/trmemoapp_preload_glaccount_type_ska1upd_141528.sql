CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_glaccount_type_ska1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Elakki K 03/25/2021
Description: GLAccount Type for Revenue GL Account  #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_glaccount_type_ska1updsel
    SET zglaccount_type_ska1 = zglaccount_type_ska1new;
END;
$procedure$
