CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_export_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- =========================================================================
    -- SSRS EXPORT SIMULATION
    -- In the legacy MSSQL architecture, this SP triggered SQL Server Reporting 
    -- Services (SSRS) to generate Excel files on a local Windows drive.
    -- 
    -- In PostgreSQL/AWS Glue, this procedure simply acts as a fast-executing 
    -- placeholder. The actual generation of the Excel/CSV files is handled 
    -- natively by the AWS Glue PySpark script immediately after this SP returns.
    -- =========================================================================
    
    RAISE NOTICE 'Postload Report Export procedure successfully executed for cycle %. AWS Glue will now take over file generation and S3 upload.', par_cyclecode;

END;
$procedure$
