CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zfco_udt_map()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- 1. Clear destination staging table
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zfco_udt_map;
    
    -- 2. Explicitly select and insert matching columns
    INSERT INTO dgs4hana_tdir1_dbo.zfco_udt_map (
        mandt, 
        dimension, 
        from_system, 
        to_system, 
        event, 
        bukrs, 
        source_val, 
        target_val, 
        usnam, 
        cpudt, 
        cputm
    )
    SELECT 
		mandt, 
        dimension, 
        from_system, 
        to_system, 
        event, 
        bukrs, 
        source_val, 
        target_val, 
        usnam, 
        cpudt, 
        cputm
    FROM dgs4hana_tdir1_dbo.vw_rt_zfco_udt_map;
    
END;
$procedure$
