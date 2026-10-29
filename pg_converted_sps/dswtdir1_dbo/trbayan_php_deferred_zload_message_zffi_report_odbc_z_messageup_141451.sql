CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_deferred_zload_message_zffi_report_odbc_z_messageup()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 10/15/2020
Modified by: Pradeep Gupta 10/15/2020
Description: Update Load Log Message
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_deferred_zload_message_zffi_report_odbc_z_messageupdsel
    SET zload_message = zload_messagenew;
END;
$procedure$
