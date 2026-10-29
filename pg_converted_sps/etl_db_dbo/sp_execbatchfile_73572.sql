CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_execbatchfile(IN par_filepath character varying, IN par_filename character varying)
 LANGUAGE plpgsql
AS $procedure$
/* Creating stored procedure to delete files using SFTP */
DECLARE
    var_BatchFile VARCHAR(1000);
    var_cmd VARCHAR(1000);
BEGIN
    /* Enabling NOCOUNT to stop the message */
    /* that shows the count of number of rows affected */
    /* Constants */
    /* DECLARE @BatchFileLocation NVARCHAR(500) = 'F:\Scripts\SFTP\sftp_del.bat'; */
    /* SET @BatchFileLocation = 'F: & cd F:\Scripts\SFTP\ & sftp_del.bat'; */
    var_BatchFile := 'F: & cd ' || par_FilePath || ' & ' || par_FileName;
    /* Variable to hold the command */
    /* Creating the command by combining the batch file location and keyword */
    var_cmd := var_BatchFile;
    /* Executing the shell command */
    CALL xp_cmdshell(var_cmd);
END;
$procedure$
