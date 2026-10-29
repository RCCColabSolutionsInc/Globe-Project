CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_report_prepare_d()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    CREATE TABLE IF NOT EXISTS dswtdir2_globe_dbo.dummy_execution_log (
        procedure_name VARCHAR(255),
        execution_time TIMESTAMP
    );

    INSERT INTO dswtdir2_globe_dbo.dummy_execution_log (procedure_name, execution_time)
    VALUES ('sp_mybss_globe_eom_preload_dp5_unconfirmed_adj_report_prepare_d', NOW());

END;
$procedure$
