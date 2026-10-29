CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_zload_message_zffi_report_odbc_z_messageupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Elakki K 10/15/2020
Modified by: Pradeep Gupta 10/15/2020
Description: Update Load Log Message
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_zload_message_zffi_report_odbc_z_messageupdsel*/
    /*SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_php AS target_table
    SET zload_message = logs.z_message::character varying(510)
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs AS logs
    WHERE target_table.zdsp_order::character varying(255)::text = logs.zdsp_order::text
      AND LOWER(target_table.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text);
END;
$procedure$
