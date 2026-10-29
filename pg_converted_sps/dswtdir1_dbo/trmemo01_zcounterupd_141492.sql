CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemo01_zcounterupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0017 ON: 7/9/2020 10:33:44 PM
Specification: cMap:{Target Rules}::TargetTable:zCounter
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemo01_zcounterupdsel
    SET zcounter = zcounternew;
END;
$procedure$
