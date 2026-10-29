CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.trbayan_billed_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Description: Update zloaded directly on the base table using a JOIN (UPDATE ... FROM)
*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.ttbayan_billed AS tt
    SET zloaded = 1 -- Assumes zloaded is numeric based on previous error
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs AS odbc
    WHERE lower(tt.zdsp_order::text) = lower(odbc.zdsp_order::text) 
      AND lower(tt.zdsp_uniquekey::text) = lower(odbc.zdsp_uniquekey::text)
      AND lower(odbc.z_message::text) !~ similar_to_escape(lower('%does not exist for%'::text)) 
      AND lower(odbc.z_message::text) !~ similar_to_escape(lower('%is not allowed for characteristic%'::text)) 
      AND lower(odbc.z_message::text) !~ similar_to_escape(lower('%requires an assignment to a CO object%'::text)) 
      AND lower(odbc.z_message::text) !~ similar_to_escape(lower('%Error in document%'::text)) 
      AND lower(odbc.z_message::text) !~ similar_to_escape(lower('%is not found in table%'::text)) 
      AND lower(tt.column01::text) = lower('01'::text);
END;
$procedure$
