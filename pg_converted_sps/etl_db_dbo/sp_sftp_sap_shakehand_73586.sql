CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_sftp_sap_shakehand()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_BatchFileLocation VARCHAR(500);
BEGIN
    /* Suppresses the display of the count of rows affected. */
    /* Declare and initialize constants */
    var_BatchFileLocation := E'F: & cd F:\\Scripts\\SFTP\\ & handshake-PRD.bat';
    /* Execute shell command using the batch file location */
    CALL xp_cmdshell(var_BatchFileLocation);
END;
$procedure$
