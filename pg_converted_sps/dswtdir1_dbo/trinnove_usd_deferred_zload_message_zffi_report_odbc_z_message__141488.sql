CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_message_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Elakki K 11/20/2020
Modified by: Elakki K 11/20/2020
Description: Update Load Log Message for 2nd Document Number
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_usd_deferred_zload_message_zffi_report_odbc_z_message_2nddocumentupdsel
    SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_usd_deferred target
    SET zload_message = (COALESCE(target.zload_message, ''::character varying)::text || ','::text) || COALESCE(logs.z_message, ''::character varying)::text
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE target.zdsp_order::character varying(255)::text = logs.zdsp_order::text
      AND lower(target.zdsp_uniquekey::text) = lower(logs.zdsp_uniquekey::text)
      AND lower(target.zload_message::text) <> lower(logs.z_message::text);
END;
$procedure$
