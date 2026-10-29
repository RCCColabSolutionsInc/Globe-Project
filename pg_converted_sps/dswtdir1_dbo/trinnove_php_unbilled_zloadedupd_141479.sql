CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_unbilled_zloadedupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Pradeep Gupta 10/12/2020
Modified by: Pradeep Gupta 10/12/2020
Description:  Update zLoaded Flag
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_unbilled_zloadedupdsel
    SET zloaded = zloadednew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_unbilled main
    SET zloaded = 1
    FROM dswtdir1_dbo.zffi_report_odbc_latestlogs logs
    WHERE main.zdsp_order = logs.zdsp_order::integer 
      AND LOWER(main.zdsp_uniquekey::text) = LOWER(logs.zdsp_uniquekey::text)
      AND LOWER(main.zrecord::text) = LOWER('01'::text)
      AND (
          LOWER(logs.z_message::text) LIKE LOWER('%SUCCES%') OR 
          LOWER(logs.z_message::text) LIKE LOWER('%Posted%') OR 
          LOWER(logs.z_message::text) LIKE LOWER('%Generated%') OR 
          LOWER(logs.z_message::text) ~ SIMILAR_TO_ESCAPE(LOWER('%Records with Zero amount%')) OR 
          LOWER(logs.z_message::text) ~ SIMILAR_TO_ESCAPE(LOWER('%Not to be Posted%')) OR 
          LOWER(logs.z_message::text) ~ SIMILAR_TO_ESCAPE(LOWER('%No Posting Revenue Item Code%')) OR 
          LOWER(logs.z_message::text) ~ SIMILAR_TO_ESCAPE(LOWER('%Is Created%'))
      );
END;
$procedure$
