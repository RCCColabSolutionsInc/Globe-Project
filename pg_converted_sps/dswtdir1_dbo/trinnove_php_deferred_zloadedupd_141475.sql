CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_deferred_zloadedupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 10/12/2020
Modified by: Elakki K 11/19/2020
Description:  Update zLoaded Flag
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_deferred_zloadedupdsel
    SET zloaded = zloadednew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_deferred target
    SET zloaded = 1
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE target.zdsp_order = logs.zdsp_order::integer 
      AND lower(target.zdsp_uniquekey::text) = lower(logs.zdsp_uniquekey::text)
      AND lower(target.zrecord::text) = lower('01'::text)
      AND (
          lower(logs.z_message::text) LIKE lower('%SUCCES%')
          OR lower(logs.z_message::text) LIKE lower('%Posted%')
          OR lower(logs.z_message::text) LIKE lower('%Generated%')
          OR lower(logs.z_message::text) ~* 'Records with Zero amount'
          OR lower(logs.z_message::text) ~* 'Not to be Posted'
          OR lower(logs.z_message::text) ~* 'No Posting Revenue Item Code'
          OR lower(logs.z_message::text) ~* 'Is Created'
      );
END;
$procedure$
