CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_transform_pgxxx(IN target_status character varying, INOUT total_rows integer DEFAULT 0)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- Count rows matching the condition and store it into the INOUT parameter
    SELECT COUNT(*) 
    FROM dswtdir2_bayan_dbo.stbayan_billed_tdir2_bayan_sapglbilled 
    INTO total_rows;
END;
$procedure$
