CREATE OR REPLACE PROCEDURE sdbtdir1_prepaid_dbo.sp_job_prepaid_reclass_sourcefilescount()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_NoOfErrors INTEGER DEFAULT 0;
    var_Subject VARCHAR(300) DEFAULT '[SQL Prepaid] Successfully processed: Collect - ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    var_EmailBody VARCHAR(300) DEFAULT 'The Prepaid Collect was completed successfully. If you have any concerns about the files processed, please contact application support.';
    var_Profile VARCHAR(20) DEFAULT 'DSP';
    var_xml TEXT;
    var_body TEXT;
BEGIN
    /*
    TRUNCATE TABLE Memo_SourceFilesRaw;
    EXEC [sp_xp_cmdshell_Memo_SourceFilesRaw];
    */
    SELECT
        COUNT(1)
        INTO var_NoOfErrors
        FROM sdbtdir1_prepaid_dbo.sourcefiles AS x
        LEFT OUTER JOIN sdbtdir1_prepaid_dbo.vw_sourcefilecount AS y
            ON LOWER(x.filename) = LOWER(y.filename) AND LOWER(x."Table") = LOWER(y."Table")
        WHERE y.cnt = 0;

    IF (var_NoOfErrors > 0) THEN
        var_Subject := '[SQL Preapaid] Failures in processing: Collect ' || CAST (var_NoOfErrors AS VARCHAR(3)) || ' job(s) failed ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
        var_EmailBody := 'The Prepaid Collect recently failed to complete successfully. The support team will investigate and advise.';
        var_Profile := 'DSP Alert';
    END IF;
    /* EXEC sp_TK_Files_Load; */
    /*
    SELECT ROW_NUMBER() OVER(ORDER BY x.zInputFileName) as [Row No],
    x.zInputFileName as [SourceFileName],
    FORMAT(ISNULL(MAX(y.DateRead),GETDATE()),'MMM dd, yyyy') as [FileDate],
    COUNT(1) as [RecordsWritten],
    CONVERT(NVARCHAR,ISNULL(MAX(y.DateRead),GETDATE()),0) as [EndTime],
    'Completed' as [Status]
    INTO #Temp
    FROM [sdbTDIR1_MemoApp].[dbo].[MemoApp_Source_AllProponents] x
    LEFT JOIN [sdbTDIR1_MemoApp].[dbo].[vw_MemoApp_Source_AllProponents_ssis] y ON x.zInputFileName = y.zInputFileName AND x.zRowNumber = y.zRowNumber
    GROUP BY x.zInputFileName
    ORDER BY 1,4
    */
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT ROW_NUMBER() OVER(ORDER BY x.[Table],x.[FileName]) as [Row No],
    CONCAT(x.[Table],' ',x.[FileName]) as [SourceFileName],
    FORMAT(ISNULL(y.DateRead,GETDATE()),'MMM dd, yyyy') as [FileDate],
    y.Cnt as [RecordsWritten],
    	CONVERT(NVARCHAR,ISNULL(y.DateRead,GETDATE()),0) as [EndTime],
    CASE WHEN y.Cnt = 0 THEN 'Failed' ELSE 'Completed' END as [Status]
    INTO #Temp
    FROM SourceFiles x
    LEFT JOIN vw_SourceFileCount y
    ON x.[FileName] = y.[FileName]
    AND x.[Table] = y.[Table]
    */
    /*
    SELECT
    DISTINCT ROW_NUMBER() OVER(ORDER BY x.FileName) as [Row No],
    x.FileName as [SourceFileName],
    (SELECT MAX(xx.FileDate) FROM TempDSPNewFiles xx WHERE xx.FileName = x.FileName) as [FileDate],
    x.RecordsWritten,
    x.EndTime,
    x.Status
    INTO #Temp
    FROM [ESTSS].[dbo].[vw_memo_collect_today] x
    ORDER BY 5,x.FileName
    */
    /*
    [9996 - Severity CRITICAL - Transformer error occurred in statement. Please submit report to developers.]
    SET @xml = CAST(( SELECT [Row No] AS 'td','',[SourceFileName] AS 'td','',[FileDate] AS 'td','',[RecordsWritten] AS 'td','',[EndTime] AS 'td','',[Status] AS 'td'
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
	
	<body><H4>Please refer to the execution details below. If you have any concerns about the files processed, please contact application support.</H4>
	<table> 
	<tr>
	<th> # </th> <th> File Name </th> <th> File Date </th> <th> Records Written </th> <th> Execution Date </th> <th> Status </th></tr>';
    var_body := var_body || var_xml || '</table>
	<h4>Thanks</h4>
	</body></html>';
    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_Profile::character varying, par_recipients := 'wmadiano@globe.com.ph'::text, par_subject := var_Subject::character varying, par_body := var_body::text, par_body_format := 'HTML'::character varying)
    /* @recipients = 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph', */
    /* @copy_recipients = 'wmadiano@globe.com.ph;kfzaguirre@globe.com.ph;neevangelista@globe.com.ph;zmbhamlag@globe.com.ph', */
    /* @blind_copy_recipients ='wmadiano20@gmail.com', */
    ;
    DROP TABLE t$temp;
    /*
    
    DROP TABLE IF EXISTS t$temp;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /* EXEC [sdbTDIR1_MemoApp].[dbo].[sp_MemoRFP_Job_SourceFilesCount]; */
END;
$procedure$
