CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_filedos2unix(IN par_file character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		<Author,,Name> */
/* Create date: <Create Date,,> */
/* Description:	<Description,,> */
/* ============================================= */
DECLARE
    var_BatchFileLocation VARCHAR(500) DEFAULT E'F: & cd F:\\Scripts\\SFTP\\ & dos2unix.exe';
    var_cmd VARCHAR(1000);
BEGIN
    /* Enabling NOCOUNT to stop the message */
    /* that shows the count of number of rows affected */
    /* DECLARE @File NVARCHAR(1000) = 'F:\BOA\Temp\TesDos\CNTEXT_I_06.TXT' */
    /* Constants */
    /* DECLARE @BatchFileLocation NVARCHAR(500) = 'F:\Scripts\SFTP\sftp_del.bat'; */
    /* Variable to hold the command */
    /* Creating the command by combining the batch file location and keyword */
    var_cmd := var_BatchFileLocation || ' ' || par_File;
    /* Executing the shell command */
    CALL xp_cmdshell(var_cmd);
END;
$procedure$
