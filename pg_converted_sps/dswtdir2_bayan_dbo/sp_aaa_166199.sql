CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_aaa(INOUT p_cursor refcursor DEFAULT 'rs_result'::refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_cursor FOR 
        SELECT * 
        FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
   		ORDER BY "billcycle" ASC, "zdsp_order"::INTEGER ASC;
END;
$procedure$
