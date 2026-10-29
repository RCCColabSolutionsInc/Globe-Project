CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_sftp_sap_pull(IN par_filekeyword character varying)
 LANGUAGE plpgsql
AS $procedure$
/* Creating stored procedure to delete files using SFTP */
/* keyword to identify the file */
DECLARE
    var_BatchFileLocation VARCHAR(500) DEFAULT E'F: & cd F:\\Scripts\\SFTP\\ & sftp_pull.bat';
    var_cmd VARCHAR(1000);
BEGIN
    /* Enabling NOCOUNT to stop the message */
    /* that shows the count of number of rows affected */
    /* Constants */
    /* DECLARE @BatchFileLocation NVARCHAR(500) = 'F:\Scripts\SFTP\sftp_del.bat'; */
    /* Variable to hold the command */
    /* Creating the command by combining the batch file location and keyword */
    var_cmd := var_BatchFileLocation || ' ' || par_fileKeyword;
    /* Executing the shell command */
    CALL xp_cmdshell(var_cmd);
END;
$procedure$
