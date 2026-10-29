CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zamount_in_doc_curr_absupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 09/07/2020
Modified by: Elakki K 09/07/2020
Description: Absolute of Amount in Doc Curr
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zamount_in_doc_curr_absupdsel
    SET zamount_in_doc_curr = zamount_in_doc_currnew;
END;
$procedure$
