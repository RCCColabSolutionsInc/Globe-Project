CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.trbayan_unbilled_adj_zloaded_upd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Debojit Roy 03/26/2021
Modified by: Debojit Roy 03/26/2021
Description: Loaded Records
*/
/*BEGIN
    UPDATE dswtdir2_bayan_dbo.trbayan_unbilled_adj_zloaded_updsel
    SET zloaded = zloadednew;
END;*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.ttbayan_unbilled_adj tt
    SET zloaded = 1  -- Sets as a numeric value, fixing the type mismatch
    FROM dswtdir2_bayan_dbo.zffi_report_odbc_latestlogs odbc
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
