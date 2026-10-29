CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_message_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Elakki K 11/19/2020
Modified by: Elakki K 11/19/2020
Description: Update Load Log Message for 2nd Document Number
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupdsel
    SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_deferred t
    SET zload_message = COALESCE(t.zload_message, '') || ',' || COALESCE(l.z_message, '')
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs l
    WHERE t.zdsp_order::character varying(255)::text = l.zdsp_order::text
      AND lower(t.zdsp_uniquekey::text) = lower(l.zdsp_uniquekey::text)
      AND lower(t.zload_message::text) <> lower(l.z_message::text);
END;
$procedure$
