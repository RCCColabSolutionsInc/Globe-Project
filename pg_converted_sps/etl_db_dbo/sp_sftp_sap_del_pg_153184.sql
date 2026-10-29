CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_sftp_sap_del_pg(IN par_filekeyword character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_BatchFileLocation VARCHAR(500) DEFAULT E'F:\\Scripts\\SFTP\\sftp_del.bat';
    var_cmd VARCHAR(1000);
BEGIN
    -- Build the command string
    var_cmd := var_BatchFileLocation || ' ' || par_filekeyword;

    -- PostgreSQL cannot run xp_cmdshell; log the command instead
    RAISE NOTICE 'SFTP delete command would be: %', var_cmd;

    -- Optionally insert into a log table for external execution
    -- INSERT INTO etl_db_dbo.sftp_command_log(command_text, created_on)
    -- VALUES (var_cmd, now());
END;
$procedure$
