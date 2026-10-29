CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendordel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 7/23/2020 11:14:18 PM
Description: Insert Prop01_NAV into ttMEMO01
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_nonaccrualvendordelsel;
END;
$procedure$
