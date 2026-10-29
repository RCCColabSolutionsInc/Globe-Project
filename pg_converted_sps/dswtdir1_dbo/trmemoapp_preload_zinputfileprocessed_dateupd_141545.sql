CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_dateupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0013 ON: 8/17/2020 11:09:38 AM
Specification: cMap:{Target Rules}::TargetTable:zInputFileProcessed_Date
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_dateupdsel
    SET zinputfileprocessed_date = zinputfileprocessed_datenew;
END;
$procedure$
