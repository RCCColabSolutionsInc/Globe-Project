CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_usd_billed_zload_message_zffi_report_odbc_z_message_2n()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 11/20/2020
Modified by: Elakki K 11/20/2020
Description: Update Load Log Message for 2nd Document Number
*/
BEGIN
    UPDATE dswtdir1_dbo.trinnove_usd_billed_zload_message_zffi_report_odbc_z_message_2nddocumentupdsel
    SET zload_message = zload_messagenew;
END;
$procedure$
