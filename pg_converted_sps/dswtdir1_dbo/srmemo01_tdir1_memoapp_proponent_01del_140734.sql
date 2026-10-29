CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 7/23/2020 2:10:00 AM
Description: Insert Prop01_GL into ttMEMO01
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srmemo01_tdir1_memoapp_proponent_01delsel;
END;
$procedure$
