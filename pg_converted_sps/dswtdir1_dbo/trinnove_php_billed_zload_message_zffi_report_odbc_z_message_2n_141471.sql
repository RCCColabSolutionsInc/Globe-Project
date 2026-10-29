CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_billed_zload_message_zffi_report_odbc_z_message_2n()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Elakki K 11/20/2020
Modified by: Elakki K 11/20/2020
Description: Update Load Log Message for 2nd Document Number
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_billed_zload_message_zffi_report_odbc_z_message_2nddocumentupdsel*/
    /*SET zload_message = zload_messagenew;*/
	UPDATE dswtdir1_dbo.ttinnove_php AS target_table
    SET zload_message = COALESCE(target_table.zload_message, ''::character varying)::text 
                        || ',' 
                        || COALESCE(logs.z_message, ''::character varying)::text
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs AS logs
    WHERE target_table.zdsp_order::character varying(255)::text = logs.zdsp_order::text
      AND LOWER(target_table.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text)
      AND LOWER(COALESCE(target_table.zload_message, ''::character varying)::text) <> LOWER(COALESCE(logs.z_message, ''::character varying)::text);
END;
$procedure$
