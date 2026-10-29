CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_zloadedupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 10/12/2020
Modified by: Pradeep Gupta 10/12/2020
Description:  Update zLoaded Flag
*/
BEGIN
    /*PDATE dswtdir1_dbo.trinnove_php_zloadedupdsel*/
    /*SET zloaded = zloadednew;*/
	UPDATE dswtdir1_dbo.ttinnove_php AS target_table
    SET zloaded = 1
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs AS logs
    WHERE target_table.zdsp_order = logs.zdsp_order::integer
      AND LOWER(target_table.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text)
      AND LOWER(target_table.zrecord::text) = '01'
      AND (
          LOWER(logs.z_message::text) LIKE '%succes%'
          OR LOWER(logs.z_message::text) LIKE '%posted%'
          OR LOWER(logs.z_message::text) LIKE '%generated%'
          OR LOWER(logs.z_message::text) LIKE '%records with zero amount%'
          OR LOWER(logs.z_message::text) LIKE '%not to be posted%'
          OR LOWER(logs.z_message::text) LIKE '%no posting revenue item code%'
          OR LOWER(logs.z_message::text) LIKE '%is created%'
      );
END;
$procedure$
