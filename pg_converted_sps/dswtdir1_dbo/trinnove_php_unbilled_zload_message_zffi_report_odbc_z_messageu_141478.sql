CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_unbilled_zload_message_zffi_report_odbc_z_messageu()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 10/15/2020
Modified by: Pradeep Gupta 10/15/2020
Description: Update Load Log Message
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_unbilled_zload_message_zffi_report_odbc_z_messageupdsel
    SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_unbilled main
    SET zload_message = logs.z_message::character varying(510)
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE main.zdsp_order::character varying(255)::text = logs.zdsp_order::text
      AND LOWER(main.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text);
END;
$procedure$
