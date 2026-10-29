CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_usd_deferred_zloadedupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 10/12/2020
Modified by: Pradeep Gupta 10/12/2020
Description:  Update zLoaded Flag
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_usd_deferred_zloadedupdsel
    SET zloaded = zloadednew;*/
	UPDATE dswtdir1_dbo.ttinnove_usd_deferred target
    SET zloaded = 1
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE target.zdsp_order = logs.zdsp_order::integer 
      AND lower(target.zdsp_uniquekey::text) = lower(logs.zdsp_uniquekey::text)
      AND lower(target.zrecord::text) = lower('01'::text)
      AND (
          lower(logs.z_message::text) LIKE '%succes%'
          OR lower(logs.z_message::text) LIKE '%posted%'
          OR lower(logs.z_message::text) LIKE '%generated%'
          OR lower(logs.z_message::text) LIKE '%records with zero amount%'
          OR lower(logs.z_message::text) LIKE '%not to be posted%'
          OR lower(logs.z_message::text) LIKE '%no posting revenue item code%'
          OR lower(logs.z_message::text) LIKE '%is created%'
      );
END;
$procedure$
