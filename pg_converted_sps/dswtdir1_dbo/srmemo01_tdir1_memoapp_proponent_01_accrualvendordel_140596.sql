CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendordel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0019 7/23/2020 11:13:35 PM
Description: Insert Prop01_AV into ttMEMO01
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01_accrualvendordelsel;
END;
$procedure$
