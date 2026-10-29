CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_unbilled_zload_message_zffi_report_odbc_z_message_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Elakki K 11/20/2020
Modified by: Elakki K 11/20/2020
Description: Update Load Log Message for 2nd Document Number
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_unbilled_zload_message_zffi_report_odbc_z_message_2nddocumentupdsel
    SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_unbilled main
    SET zload_message = (COALESCE(main.zload_message, ''::character varying)::text || ','::text) || COALESCE(logs.z_message, ''::character varying)::text
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE main.zdsp_order::character varying(255)::text = logs.zdsp_order::text
      AND LOWER(main.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text)
      AND LOWER(main.zload_message::text) <> LOWER(logs.z_message::text);
END;
$procedure$
