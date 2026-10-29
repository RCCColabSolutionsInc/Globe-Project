CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_bdef_phpdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 9/1/2020 2:14:03 AM
Description: Insert TDIR1_ICCBS into ttBayan_PHP_Deferred
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srp_bdef_phpdelsel;
END;
$procedure$
