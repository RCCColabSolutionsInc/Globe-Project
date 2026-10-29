CREATE OR REPLACE PROCEDURE sdbtdip2_actualization_dbo.sp_isms_ibobactualization_job_sourcefilecount()
 LANGUAGE plpgsql
AS $procedure$
/* use sdbTDIP2_Actualization */
DECLARE
    var_NoOfErrors INTEGER DEFAULT 0;
    var_Subject VARCHAR(300) DEFAULT 'Report Notif: ISMS Actualization Status - Extraction(Process Stage 1 of 3)  - ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    var_EmailBody VARCHAR(1000) DEFAULT 'The source file extraction was completed successfully. If you have any concerns about the processed files, please contact application support. NEXT PROCESS STAGE(2): Preload Data Transformation..';
    var_JobCount INTEGER DEFAULT 0;
    var_Profile VARCHAR(20) DEFAULT 'SSRS';
    var_xml TEXT;
    var_body TEXT;
BEGIN
    CREATE TEMPORARY TABLE t$temp
    AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY x.filename, x.targettable) AS "Row No", x.targettable, x.filename, COALESCE(dd.dateread, clock_timestamp()) AS dateread, COALESCE(dd.recordswritten, 0) AS recordswritten, COALESCE(dd.dateread, clock_timestamp()) AS endtime, COALESCE(dd.status, 'No Data') AS status
        FROM sdbtdip2_actualization_dbo.sourcefiles AS x
        LEFT OUTER JOIN (SELECT
            targettable, filename, MAX(dateread) AS dateread, COUNT(1) AS recordswritten, 'Completed' AS status
            FROM (SELECT
                'APMI_RAW' AS targettable, filename, dateread
                FROM sdbtdip2_actualization_dbo.apmi_raw
            UNION ALL
            SELECT
                'SUMMARY_ACCRUAL_OB' AS targettable, filename, dateread
                FROM sdbtdip2_actualization_dbo.summary_accrual_ob
            UNION ALL
            SELECT
                'SUMMARY_OF_INVOICE_INBOUND' AS targettable, filename, dateread
                FROM sdbtdip2_actualization_dbo.summary_of_invoice_inbound
            UNION ALL
            SELECT
                'SUMMARY_OF_INVOICE_OUTBOUND' AS targettable, filename, dateread
                FROM sdbtdip2_actualization_dbo.summary_of_invoice_outbound) AS xx
            GROUP BY targettable, filename) AS dd
            ON dd.filename = x.filename::VARCHAR AND dd.targettable = x.targettable::VARCHAR;
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in statement. Please submit report to developers.]
    SET @xml = CAST(( SELECT [Row No] AS 'td','',[FileName] AS 'td','',[TargetTable] as 'td','',[RecordsWritten] AS 'td','',[EndTime] AS 'td','',[Status] AS 'td'
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
	
	<body><H4>Please refer to the execution details below.</H4>
	<table> 
	<tr>
	<th> # </th> <th> File Name </th> <th> Target Table </th><th> Records Written </th> <th> Execution Date </th> <th> Status </th></tr>';
    var_body := var_body || var_xml || '</table>
	<h4>Thanks</h4>
	</body></html>';
    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_Profile::character varying, par_recipients := 'rnvillar@globe.com.ph;jenerose.dominguez@globe.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph;rosoldevilla@globe.com.ph'::text, par_subject := var_Subject::character varying, par_body := var_body::text, par_body_format := 'HTML'::character varying)
    /* @recipients = 'wmadiano@globe.com.ph', */
    /* @recipients = 'wmadiano@globe.com.ph', */
    ;
    DROP TABLE t$temp;
    /*
    
    DROP TABLE IF EXISTS t$temp;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
