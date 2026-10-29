CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_delta_globe_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  filedelkey VARCHAR(200);
  filekey VARCHAR(200);
BEGIN
-- File 1
	filedelkey := '03_ICEXT_Voice_Globe_Delta_PosAmnt_Del';
	filekey := '01_ICEXT_Voice_Globe_Delta_PosAmnt_Push';

	-- Delete previous files and push new file
	CALL "etl_db"."dbo"."sp_sftp_sap_del"(filedelkey);
	CALL "etl_db"."dbo"."sp_sftp_sap_push"(filekey);  -- Execute export file

	-- File 2
	filedelkey := '03_ICEXT_Voice_Globe_Delta_NegAmnt_Del';
	filekey := '01_ICEXT_Voice_Globe_Delta_NegAmnt_Push';

	-- Delete previous files and push new file
	CALL "etl_db"."dbo"."sp_sftp_sap_del"(filedelkey);
	CALL "etl_db"."dbo"."sp_sftp_sap_push"(filekey);  -- Execute export file
END;
$procedure$
