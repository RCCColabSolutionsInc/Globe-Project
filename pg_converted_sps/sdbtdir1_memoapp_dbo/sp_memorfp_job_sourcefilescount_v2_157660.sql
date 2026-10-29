CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_memorfp_job_sourcefilescount_v2()
 LANGUAGE plpgsql
AS $procedure$
/* #region sp_MemoRFP_Job_SourceFilesCount_V2 */
/* do not include users to the notification */
DECLARE
    var_NoOfErrors INTEGER DEFAULT 0;
    var_Subject VARCHAR(300) DEFAULT 'Report Notif: Memo RFP Successfully Processed - Extraction(Process Stage 1 of 3)  - ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
    var_EmailBody VARCHAR(1000) DEFAULT 'The source file extraction was completed successfully. If you have any concerns about the processed files, please contact application support. NEXT PROCESS STAGE(2): Preload Data Transformation..';
    var_Profile VARCHAR(20) DEFAULT 'SSRS';
    var_xml TEXT;
    var_body TEXT;
    var_DuplicateCount INTEGER;
BEGIN
    /* DECLARE @Subject NVARCHAR(300) = 'Report Notif: Memo RFP Successfully Processed - Extraction(Process Stage 1 of 3)  - ' + CONVERT(NVARCHAR, GETDATE(), 0); */
    SELECT
        COUNT(1)
        INTO var_NoOfErrors
        FROM sdbtdir1_memoapp_dbo.paymentrequests_failed AS x
        WHERE CAST (x.dateprocessed AS DATE) = CAST (clock_timestamp() AS DATE);

    IF (var_NoOfErrors > 0) THEN
        var_Subject := 'Report Notif: Memo RFP Completed with ' || CAST (var_NoOfErrors AS VARCHAR(3)) || ' Failure(s) - Extraction(Process Stage 1 of 3) ' || aws_sqlserver_ext.conv_datetime_to_string('NVARCHAR', 'DATETIME', clock_timestamp(), 0);
        /* SET @Subject = 'Report Notif: Memo RFP Completed with ' + CAST(@NoOfErrors AS NVARCHAR(3)) + ' Failure(s) - Extraction(Process Stage 1 of 3) ' + CONVERT(NVARCHAR, GETDATE(), 0); */
        var_EmailBody := 'The recent extraction process partially completed, with some files failing to process successfully. The successfully processed files will proceed to the next step. 
							Meanwhile, our support team will investigate the issues with the failed files and will provide further updates. NEXT PROCESS STAGE(2): Preload Data Transformation..';
        var_Profile := 'SSRS';
    END IF;
    /* duplicate checking */
    SELECT
        COUNT(1)
        INTO var_DuplicateCount
        FROM sdbtdir1_memoapp_dbo.temp_vw_memoapp_source_allproponents_ssis_duplicates;
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT ROW_NUMBER() OVER (
    				ORDER BY [SourceFileName]
    				) AS [Row No],
    			[SourceFileName],
    			[FileDate],
    			[RecordsWritten],
    			[EndTime],
    			[Status]
    		INTO #Temp
    		FROM (
    			SELECT x.zInputFileName + '.xlsx' AS [SourceFileName],
    				FORMAT(ISNULL(MAX(y.DateRead), GETDATE()), 'MMM dd, yyyy') AS [FileDate],
    				COUNT(1) AS [RecordsWritten],
    				CONVERT(NVARCHAR, ISNULL(MAX(y.DateRead), GETDATE()), 0) AS [EndTime],
    				'Completed' AS [Status]
    			FROM [sdbTDIR1_MemoApp].[dbo].[MemoApp_Source_AllProponents] x
    			LEFT JOIN [sdbTDIR1_MemoApp].[dbo].[vw_MemoApp_Source_AllProponents_ssis] y ON x.zInputFileName = y.zInputFileName
    				AND x.zRowNumber = y.zRowNumber
    			GROUP BY x.zInputFileName
    
    			UNION ALL
    
    			SELECT i.[FileName],
    				FORMAT(i.DateProcessed, 'MMM dd, yyyy'),
    				0,
    				CONVERT(NVARCHAR, i.DateProcessed, 0),
    				'Failed'
    			FROM [PaymentRequests_Failed] i
    			WHERE CAST(i.DateProcessed AS DATE) = CAST(GETDATE() AS DATE)
    			) AS xx
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
    SET @xml = CAST((
    					SELECT [Row No] AS 'td',
    						'',
    						[SourceFileName] AS 'td',
    						'',
    						[FileDate] AS 'td',
    						'',
    						[RecordsWritten] AS 'td',
    						'',
    						[EndTime] AS 'td',
    						'',
    						[Status] AS 'td'
    					FROM #Temp
    					ORDER BY 1
    					FOR XML PATH('tr'),
    						ELEMENTS
    					) AS NVARCHAR(MAX))
    */
    /*
    SET @body ='<html>
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
    
    <body><H4>'+ @EmailBody +'.</H4>
    <table>
    <tr>
    <th> # </th> <th> File Name </th> <th> File Date </th> <th> Records Written </th> <th> Execution Date </th> <th> Status </th></tr>'
    
    SET @body = @body + @xml +'</table>
    
    
    <table>
    <tr>
    <th> # </th> <th>  </th> <th> Deleted duplicate rows </th> <th> '+ @DuplicateCount +' </th></tr>
    
    
    </table>
    
    <h4>Thanks</h4>
    </body></html>'
    */
    var_body := '<html>
    <head>
        <title>Title of the document</title>
        <style>
            table, th, td {
                padding: 10px;
                border: 1px solid black;
                border-collapse: collapse;
            }
        </style>
    </head>
    <body>
        <h4>' || var_EmailBody || '.</h4>
        <table> 
            <tr>
                <th> # </th> 
                <th> File Name </th> 
                <th> File Date </th> 
                <th> Records Written </th> 
                <th> Execution Date </th> 
                <th> Status </th>
            </tr>';
    var_body := var_body || var_xml;
    var_body := var_body || '</table>
    <br/>
    <table> 
        <tr>
            <th> # </th> 
            <th> Deleted duplicate rows </th> 
            <th>' || CAST (var_DuplicateCount AS VARCHAR(10)) || '</th>
        </tr>
    </table>
    <h4>Thanks</h4>
    </body>
    </html>';
    PERFORM aws_sqlserver_ext.SP_SEND_DBMAIL(par_profile_name := var_Profile::character varying, par_recipients := 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph;jsshernandez@globe.com.ph;emmerioles@globe.com.ph;michelle.oliveras@gsupport.com.ph;paula.villafranca@gsupport.com.ph'::text, par_copy_recipients := 'wmadiano@globe.com.ph;neevangelista@globe.com.ph;isg-eso-support@globe.com.ph'::text, par_subject := var_Subject::character varying, par_body := var_body::text, par_body_format := 'HTML'::character varying)
    /* @recipients = 'wmadiano@globe.com.ph' */
    /* ,@recipients = 'zredevera@globe.com.ph;zcgramos@globe.com.ph;zmdeocampo@globe.com.ph;zrnfajardo@globe.com.ph;ndsales@globe.com.ph;jsshernandez@globe.com.ph;emmerioles@globe.com.ph;michelle.oliveras@gsupport.com.ph;paula.villafranca@gsupport.com.ph' */
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
