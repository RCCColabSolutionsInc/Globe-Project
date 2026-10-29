CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_export_new(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- In the legacy architecture, this procedure triggered SSRS subscriptions 
    -- and used xp_cmdshell to delete old local files.
    -- In the new AWS Glue architecture, PySpark's FileExporter.py handles the actual 
    -- Excel file generation and S3 upload natively. 
    -- This procedure acts purely as a successful validation hook to keep the Glue pipeline moving.
    
    RAISE NOTICE 'Postload Report Export hook executed successfully for Innove cycle: %. AWS Glue will now take over file generation and S3 upload.', par_cyclecode;
END;
$procedure$
