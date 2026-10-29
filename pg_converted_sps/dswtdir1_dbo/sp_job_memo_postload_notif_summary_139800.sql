CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_postload_notif_summary()
 LANGUAGE plpgsql
AS $procedure$
/* #region sp_Job_Memo_Postload_Notif_Summary */
DECLARE
    var_NoOfDiscre INTEGER DEFAULT 0;
    var_NoOfPostloadErrors INTEGER DEFAULT 0;
    var_Subject VARCHAR(300) DEFAULT '';
    var_EmailBody VARCHAR(300) DEFAULT '';
    var_MaxDate DATE DEFAULT clock_timestamp();
    var_dcMEMOAPPCnt INTEGER DEFAULT 0;
    var_Profile VARCHAR(20) DEFAULT 'SSRS';
    var_xml TEXT;
    var_body TEXT;
    var_DataReportDate TIMESTAMP WITHOUT TIME ZONE;
    var_dt DATE DEFAULT clock_timestamp();
BEGIN
    SELECT
        etl_db_dbo.fn_getlatestproccesseddate('Memo', '[dswTDIR1].[dbo].[sp_Memo_Postload_Report_Send]')
        INTO var_DataReportDate;
    /* CREATE TABLE MemoMigratePostloadTemp(OrderNo INT,Process NVARCHAR(40),DateProcessed DATETIME,ProcessName NVARCHAR(500),RecordCount INT); */
    TRUNCATE TABLE dswtdir1_dbo.memomigratepostloadtemp;
    INSERT INTO dswtdir1_dbo.memomigratepostloadtemp
    /* SELECT 1 as Seq,'Postload',ActionOn as ProcessedDate,'Postload Count' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTarget] WHERE WaveProcessAreaObjectTargetID =  '9031546B-9FD2-406B-BE22-F5351D9EDAF3' */
    SELECT
        1 AS seq, 'Postload', COALESCE(var_DataReportDate, var_dt) AS processeddate, 'Postload Count' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.ttmemoapp_postload
    UNION ALL
    /* SELECT 2 as Seq,'Postload',ActionOn as ProcessedDate,'Successful Posting Count' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetRule] WHERE WaveProcessAreaObjectTargetRuleID ='42D1CC77-1E8D-42D8-9BD2-864D1378D0F3' */
    SELECT
        2 AS seq, 'Postload', COALESCE(var_DataReportDate, var_dt) AS processeddate, 'Successfully Posted in SAP' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.memo_postload_line_report_prepare_success_cache
    UNION ALL
    /* SELECT 3 as Seq,'Postload',ActionOn as ProcessedDate,'Failed Posting Counting - Inserted to Error Page' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetRule] WHERE WaveProcessAreaObjectTargetRuleID ='44B895D0-8BBF-472B-9560-14E0954573D9' */
    SELECT
        3 AS seq, 'Postload', COALESCE(var_DataReportDate, var_dt) AS processeddate, 'Failed to Post in SAP: Added To Memo Error Page' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.memo_postload_line_report_prepare_failed_cache;
    /*
    UNION ALL
    -- trMEMOAPP_Postload_Insert_Into_DcMemoApp_InsSel
    SELECT 4 as Seq,'Postload',ActionOn as ProcessedDate,'Failed_Input_File_Records_Inserted_To_Error_Page' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetRule] WHERE WaveProcessAreaObjectTargetRuleID ='0FD0F959-E8D0-4D1D-862D-BCA6D24CD132'
    */
    INSERT INTO dswtdir1_dbo.memomigratepostloadtemp
    SELECT
        4, 'Postload', COALESCE(var_DataReportDate, var_dt), 'Discrepancy of Postload Records vs Line Items', (SELECT
            recordcount
            FROM dswtdir1_dbo.memomigratepostloadtemp AS xx
            WHERE xx.orderno = 1) - (SELECT
            SUM(recordcount)
            FROM dswtdir1_dbo.memomigratepostloadtemp AS x
            WHERE x.orderno BETWEEN 2 AND 3);
    SELECT
        SUM(recordcount)
        INTO var_NoOfDiscre
        FROM dswtdir1_dbo.memomigratepostloadtemp AS x
        WHERE x.orderno = 4;
    SELECT
        SUM(recordcount)
        INTO var_NoOfPostloadErrors
        FROM dswtdir1_dbo.memomigratepostloadtemp AS x
        WHERE x.orderno = 3;

    IF (var_NoOfDiscre <> 0) THEN
        var_Subject := 'Report Notif: Memo RFP Completed w/ Discrepancies - Postload Transformation(Process Stage 3 of 3) ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    ELSE
        var_Subject := 'Report Notif: Memo RFP Successfully Processed - Postload Transformation(Process Stage 3 of 3) ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    END IF;
    CREATE TEMPORARY TABLE t$temp
    AS
    SELECT
        x.orderno AS "Row No", x.processname, x.dateprocessed AS endtime,
        CASE
            WHEN (LOWER(x.processname) = LOWER('Discrepancy of Postload records vs Line items') AND x.recordcount = 0) THEN '-'
            ELSE CAST (x.recordcount AS VARCHAR(25))
        END AS recordswritten
        FROM dswtdir1_dbo.memomigratepostloadtemp AS x
        ORDER BY orderno NULLS FIRST;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in statement. Please submit report to developers.]
    SET @xml = CAST(( SELECT [Row No] AS 'td','',[ProcessName] AS 'td','',[EndTime] AS 'td','',[RecordsWritten] AS 'td'
    	FROM #Temp
    	ORDER BY 1
    	FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))
    */
    var_body := '<html>
	 <head>
		<title>Title of the document</title>
		<style>
		  table,
		  th,
		  td {
			padding: 10px;
			border: 1px solid black;
			border-collapse: collapse;
		  }
		</style>
	  </head>
	
	<body><H4>Please refer to the execution details below. ALL PROCESS STAGES COMPLETED.</H4>
	<table> 
	<tr>
	<th> # </th> <th> Process </th> <th> Execution Date </th> <th> Records Written </th></tr>';
    var_body := var_body || var_xml || '</table>
	<h4>Thanks</h4>
	</body></html>';
    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_Profile::character varying, par_recipients := 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph;jsshernandez@globe.com.ph;emmerioles@globe.com.ph;michelle.oliveras@gsupport.com.ph;paula.villafranca@gsupport.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'::text, par_subject := var_Subject::character varying, par_body := var_body::text, par_body_format := 'HTML'::character varying)
    /* @recipients = 'wmadiano@globe.com.ph', */
    /* @blind_copy_recipients ='wmadiano20@gmail.com', */
    ;
    DROP TABLE t$temp;
    /*
    
    DROP TABLE IF EXISTS t$temp;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
/* #endregion */
/* #region sp_Job_Memo_Preload_SFTP */
/* - do not push sftp for test runs */
$procedure$
