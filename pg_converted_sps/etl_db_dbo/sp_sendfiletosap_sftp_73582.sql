CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_sendfiletosap_sftp()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		<Author,,Name> */
/* Create date: <Create Date,,> */
/* Description:	<Description,,> */
/* ============================================= */
/* @SourceFileDir NVARCHAR(500), */
/* @SourceFileName NVARCHAR(500), */
/* @DestFileDir NVARCHAR(500), */
/* @DestFileName NVARCHAR(500) */
DECLARE
    var_BatchFileLocation VARCHAR(500);
    var_cmd VARCHAR(1000);
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* SET @BatchFileLocation = 'F:\admin_folder\test.bat'; */
    var_BatchFileLocation := E'F:\\Scripts\\SFTP\\sftp_push.bat test01';
    SELECT
        CONCAT('CMD /C ', var_BatchFileLocation)
        INTO var_cmd;
    CALL xp_cmdshell(var_cmd);
END;
$procedure$
