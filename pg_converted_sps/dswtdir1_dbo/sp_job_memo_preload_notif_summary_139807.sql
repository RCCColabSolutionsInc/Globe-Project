CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_job_memo_preload_notif_summary()
 LANGUAGE plpgsql
AS $procedure$
/* #region sp_Job_Memo_Preload_Notif_Summary */
DECLARE
    var_NoOfDiscre INTEGER DEFAULT 0;
    var_NoOfPrelaodErrors INTEGER DEFAULT 0;
    var_Subject VARCHAR(300) DEFAULT '';
    var_EmailBody VARCHAR(300) DEFAULT '';
    var_Deleted INTEGER DEFAULT 0;
    var_Profile VARCHAR(20) DEFAULT 'SSRS';
    var_MaxDate TIMESTAMP WITHOUT TIME ZONE DEFAULT clock_timestamp();
    var_dcMEMOAPPCnt INTEGER DEFAULT 0;
    var_xml TEXT;
    var_body TEXT;
    var_DataExportDate TIMESTAMP WITHOUT TIME ZONE;
    var_DataReportDate TIMESTAMP WITHOUT TIME ZONE;
    var_dt DATE DEFAULT clock_timestamp();
BEGIN
    SELECT
        etl_db_dbo.fn_getlatestproccesseddate('Memo', '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Export]')
        INTO var_DataExportDate;
    SELECT
        etl_db_dbo.fn_getlatestproccesseddate('Memo', '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Report_Send]')
        INTO var_DataReportDate;
    /* CREATE TABLE MemoMigratePreloadTemp(OrderNo INT,Process NVARCHAR(40),DateProcessed DATETIME,ProcessName NVARCHAR(500),RecordCount INT); */
    TRUNCATE TABLE dswtdir1_dbo.memomigratepreloadtemp;
    INSERT INTO dswtdir1_dbo.memomigratepreloadtemp
    SELECT
        1 AS seq, 'Preload', etl_db_dbo.fn_getlatestproccesseddate('Memo', '[dswTDIR1].[dbo].[sp_Memo_Preload_Line_Transform]') AS processeddate, 'Invalid Length: Deleted' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.memo_preload_line_report_prepare_04_invalidlength_cache
    UNION ALL
    /* SELECT 2 as Seq,'Preload',ActionOn as ProcessedDate,'Preload Count' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTarget] WHERE WaveProcessAreaObjectTargetID =  '61984996-e7bc-48a5-a07d-f3139fd671e9' */
    SELECT
        2 AS seq, 'Preload', var_DataReportDate AS processeddate, 'Preload Count' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.memo_preload_line_report_prepare_01_scn01to06_alldata_cache
    UNION ALL
    /* SELECT 3 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario1 No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = 'AE59DF47-CBAB-49E7-AC76-B4A1B44E5ABA' */
    SELECT
        3 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 1 No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario1_without_taxcodesel
    UNION ALL
    /* SELECT 4 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 2 To 5 With Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '3C956196-F4B7-4EE9-BF42-5DA65049B670' */
    SELECT
        4 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 2 To 5 With Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario2to5_with_taxcodesel
    UNION ALL
    /* SELECT 5 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 2 To 5 No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '0FAF964B-379C-449D-B15C-5FB51ABC8892' */
    SELECT
        5 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 2 To 5 No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario2to5_without_taxcodesel
    UNION ALL
    /* SELECT 6 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 6 Accrual 2 To 5A Reversal' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = 'CBB9C67A-818B-4A46-92A2-802065D196F9' */
    SELECT
        6 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 6 Accrual 2 To 5A Reversal' AS processname, 0 AS cnt
    UNION ALL
    /* SELECT 7 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 6 Accrual 2 To 5B NewAcc No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = 'B11E236C-8037-46C7-B5F0-B3674BFD56A1' */
    SELECT
        7 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 6 Accrual 2 To 5B NewAcc No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5b_newaccdoc_without_taxcodesel
    UNION ALL
    /* SELECT 8 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario6 Accrual2 To 5C Invoice With Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = 'D8466A79-D02B-4193-A928-378EC67D6326' */
    SELECT
        8 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 6 Accrual 2 To 5C Invoice With Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5c_invoice_with_taxcodesel
    UNION ALL
    /* SELECT 9 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 6 Accrual 2 To 5C Invoice No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '81F2BC4C-C5C2-4473-AD25-344C38682E4D' */
    SELECT
        9 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 6 Accrual 2 To 5C Invoice No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario6_accrual2to5c_invoice_without_taxcodesel
    UNION ALL
    /* SELECT 10 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 8M No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '040F2A98-A0FA-45A0-BA12-823CE655E558' */
    SELECT
        10 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 8M No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario8m_without_taxcodesel
    UNION ALL
    /* SELECT 11 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 8R No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '48EE880F-427B-4EC5-8E2A-26765BA9B152' */
    SELECT
        11 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 8R No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario8r_without_taxcodesel
    UNION ALL
    /* SELECT 12 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 9 No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = '99E2556B-02CB-4504-A25E-D023982F5940' */
    SELECT
        12 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 9 No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario9_without_taxcodesel
    UNION ALL
    /* SELECT 13 as Seq,'Preload',ActionOn as ProcessedDate,'Scenario 10 No Tax' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetExport] WHERE WaveProcessAreaObjectTargetExportID = 'F4860D6E-8111-40BE-A58E-00C55F5E8368' */
    SELECT
        13 AS seq, 'Preload', var_DataExportDate AS processeddate, 'Scenario 10 No Tax' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.txmemoapp_preload_openbal_scenario10_without_taxcodesel
    UNION ALL
    /* SELECT 14 as Seq,'Preload',ActionOn as ProcessedDate,'Preload Error - Added To Memo Error Page' as ProcessName,RecordCount as Cnt FROM DSW.[dbo].[ttWaveProcessAreaObjectTargetRule] WHERE WaveProcessAreaObjectTargetRuleID = 'E3E1F21B-474D-430A-BC68-D74F42E74BE2' */
    SELECT
        14 AS seq, 'Preload', var_DataReportDate AS processeddate, 'Failed Data Validation(NOT for SAP Posting): Added To Memo Error Page' AS processname, COUNT(1) AS cnt
        FROM dswtdir1_dbo.memo_preload_line_report_prepare_02_scn01to06_error_cache;
    INSERT INTO dswtdir1_dbo.memomigratepreloadtemp
    SELECT
        15, 'Preload', var_DataReportDate, 'Discrepancy of Preload Records vs Line Items', (SELECT
            recordcount
            FROM dswtdir1_dbo.memomigratepreloadtemp AS xx
            WHERE xx.orderno = 2) - (SELECT
            SUM(recordcount)
            FROM dswtdir1_dbo.memomigratepreloadtemp AS x
            WHERE x.orderno BETWEEN 3 AND 14);
    SELECT
        SUM(recordcount)
        INTO var_Deleted
        FROM dswtdir1_dbo.memomigratepreloadtemp AS x
        WHERE x.orderno = 1;
    SELECT
        SUM(recordcount)
        INTO var_NoOfDiscre
        FROM dswtdir1_dbo.memomigratepreloadtemp AS x
        WHERE x.orderno = 15;
    SELECT
        SUM(recordcount)
        INTO var_NoOfPrelaodErrors
        FROM dswtdir1_dbo.memomigratepreloadtemp AS x
        WHERE x.orderno = 14;

    IF (var_NoOfDiscre <> 0) THEN
        /* SET @Subject = '[Memo Migrate Preload] With Discrepancies/Error - ' + CONVERT(NVARCHAR,@NoOfPrelaodErrors) + ' preload errs ' + CONVERT(NVARCHAR,GETDATE(),0); */
        var_Subject := 'Report Notif: Memo RFP Completed w/ Discrepancies - Preload Transformation(Process Stage 2 of 3) ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    ELSE
        var_Subject := 'Report Notif: Memo RFP Successfully Processed - Preload Transformation(Process Stage 2 of 3) ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    END IF;
    CREATE TEMPORARY TABLE t$temp
    AS
    SELECT
        x.orderno AS "Row No", x.processname, x.dateprocessed AS endtime, x.recordcount AS recordswritten
        FROM dswtdir1_dbo.memomigratepreloadtemp AS x
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
	
	<body><H4>Please refer to the execution details below. NEXT PROCESS STAGE(3): SAP Posting and Postload Data Transformation..</H4>
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
$procedure$
