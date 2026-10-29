CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_transform_pg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- Transform postload data logic here
    
    -- CORRECTED INTERNAL CALL: Replaced 'dbo.' with 'dswtdir2_globe_dbo.'
    CALL dswtdir2_globe_dbo.trGlobe_DP1_Billed_zLoaded_0_CycleCodeUpd();
    
    -- (Optional) Call the second procedure if required by your workflow
    CALL dswtdir2_globe_dbo.trGlobe_DP1_Billed_zLoaded_1Upd();
    
    COMMIT;
END;
$procedure$
