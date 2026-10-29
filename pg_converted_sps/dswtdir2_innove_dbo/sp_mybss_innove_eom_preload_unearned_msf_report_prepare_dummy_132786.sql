CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unearned_msf_report_prepare_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    CREATE TABLE IF NOT EXISTS dswtdir2_innove_dbo.dummy_execution_log (
        procedure_name VARCHAR(255),
        execution_time TIMESTAMP
    );

    INSERT INTO dswtdir2_innove_dbo.dummy_execution_log (procedure_name, execution_time)
    VALUES ('sp_mybss_innove_eom_preload_unearned_msf_report_prepare_dummy', NOW());

END;
$procedure$
