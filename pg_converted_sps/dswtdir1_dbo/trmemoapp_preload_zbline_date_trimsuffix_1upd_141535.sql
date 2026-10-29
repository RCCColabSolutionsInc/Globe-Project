CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zbline_date_trimsuffix_1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/03/2020
Modified by: Elakki K 09/03/2020
Description: Remove the Suffix "Space 1" - Length of date considered the Timestamp value also in Source Rule
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zbline_date_trimsuffix_1updsel
    SET zbline_date = zbline_datenew;
END;
$procedure$
