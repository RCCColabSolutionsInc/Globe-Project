CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_job_aprm_voice_accrual_globe_preload_sftp()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  filedelkey VARCHAR(200);
  filekey VARCHAR(200);
BEGIN
filedelkey := '03_ICEXT_Voice_Globe_Accrual_Del';
	filekey := '01_ICEXT_Voice_Globe_Accrual_Push';

	-- delete previous files
	CALL etl_db_dbo.sp_sftp_sap_del(filedelkey);
	CALL etl_db_dbo.sp_sftp_sap_push(filekey);  -- Execute export file
END;
$procedure$
