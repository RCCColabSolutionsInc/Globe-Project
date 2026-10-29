CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_billed_zload_message_zffi_report_odbc_z_message_tdi()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 11/03/2020
Modified by: Elakki K 11/03/2020
Description: Update Load Log Message - TDIR1
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_billed_zload_message_zffi_report_odbc_z_message_tdir1updsel
    SET zload_message = zload_messagenew;
END;
$procedure$
