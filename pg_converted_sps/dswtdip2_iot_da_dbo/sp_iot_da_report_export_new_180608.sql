CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_report_export_new()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_cache_count INT := 0;
BEGIN
    -- =========================================================================
    -- 0. MISSING DEPENDENCY SAFEGUARD (Self-Healing)
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS dswtdip2_iot_da_dbo.rpt_iot_da_report_prepare_cache (
        column1 VARCHAR(200), column2 VARCHAR(1000), column3 VARCHAR(1000), column4 VARCHAR(4000), 
        column5 VARCHAR(263), column6 VARCHAR(4000), column7 VARCHAR(1000), column8 VARCHAR(4000), 
        column9 VARCHAR(4000), column10 VARCHAR(200), column11 VARCHAR(200), column12 VARCHAR(200), 
        column13 VARCHAR(4000), column14 VARCHAR(200), column15 VARCHAR(257), column16 VARCHAR(200), 
        column17 VARCHAR(200), column18 VARCHAR(200), column19 VARCHAR(200), column20 VARCHAR(200), 
        column21 VARCHAR(200), column22 VARCHAR(200), column23 VARCHAR(200), column24 VARCHAR(200), 
        column25 VARCHAR(200), column26 VARCHAR(200), column27 VARCHAR(300), column28 VARCHAR(300), 
        column29 VARCHAR(300), column30 VARCHAR(300), column31 VARCHAR(300), column32 VARCHAR(300), 
        column33 VARCHAR(300), column34 VARCHAR(200), column35 VARCHAR(200), column36 VARCHAR(257), 
        column37 VARCHAR(292), column38 VARCHAR(300), column39 VARCHAR(300), column40 VARCHAR(255), 
        column41 VARCHAR(255), column42 VARCHAR(300), column43 VARCHAR(300), column44 VARCHAR(300), 
        column45 VARCHAR(200), column46 VARCHAR(300), column47 VARCHAR(300), column48 VARCHAR(300), 
        column49 VARCHAR(300), column50 VARCHAR(300), column51 VARCHAR(300), column52 VARCHAR(300), 
        column53 VARCHAR(300), column54 VARCHAR(300), column55 VARCHAR(300), column56 VARCHAR(200), 
        column57 VARCHAR(300), column58 VARCHAR(300), column59 VARCHAR(300), column60 VARCHAR(300), 
        column61 VARCHAR(300), column62 VARCHAR(300), column63 VARCHAR(150), column64 VARCHAR(200), 
        column65 VARCHAR(200), column66 VARCHAR(140), column67 VARCHAR(200), column68 VARCHAR(300), 
        column69 VARCHAR(100), column70 VARCHAR(120), column71 VARCHAR(130), column72 VARCHAR(300), 
        column73 VARCHAR(400), accountgroup VARCHAR(35)
    );

    -- =========================================================================
    -- 1. VERIFICATION LOGIC
    -- =========================================================================
    SELECT COUNT(1) INTO v_cache_count
    FROM dswtdip2_iot_da_dbo.rpt_iot_da_report_prepare_cache;

    IF v_cache_count = 0 THEN
        RAISE NOTICE 'WARNING: rpt_iot_da_report_prepare_cache is empty. If running standalone tests, ensure the Report Prepare dummy or actual SP has run prior.';
    END IF;

    -- The actual Excel generation is handled natively by the PySpark AWS Glue Job 
    -- using the --EXPORT and --LOAD_TABLE parameters.
    
    RAISE NOTICE 'ISMS IOT DA Report Export Hook executed successfully. AWS Glue FileExporter will now pull % records.', v_cache_count;

END;
$procedure$
