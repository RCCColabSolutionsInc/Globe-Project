CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_phpins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/1/2020 2:14:03 AM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Deferred
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttbayan_php_deferred (zlegacyzdsp_order, zlegacyzrecord, zsource)
    SELECT
        zlegacyzdsp_order, zlegacyzrecord, zsource
        FROM dswtdir1_dbo.srp_bdef_phpinssel;
END;
$procedure$
