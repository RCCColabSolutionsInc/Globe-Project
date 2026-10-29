CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_globe_postload_report_send_bak()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_SubscriptionID UUID;
    var_ReportName VARCHAR(300);
    cursor_data CURSOR FOR
    SELECT
        x.subscriptionid, x.reportname
        FROM etl_db_dbo.vw_reportsubcriptions AS x
        WHERE x.reportname IN (SELECT
            d.reportname
            FROM t$ds AS d
            WHERE d.recordcount > 0);
BEGIN
    CREATE TEMPORARY TABLE t$ds
    (reportname VARCHAR(500),
        recordcount INTEGER);
    INSERT INTO t$ds (reportname, recordcount)
    SELECT
        'Delta_Globe_Postload_Comparison_Output', COUNT(1)
        FROM dswtdir3_aprm_dbo.rpt_voice_delta_globe_postload_report_comparison_output_cache;
    /* PRELOAD REPORTS */
    /* Loop from the table and process based on conditions */
    OPEN cursor_data;
    FETCH NEXT FROM cursor_data INTO var_SubscriptionID, var_ReportName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* EXEC [etl_db].[dbo].[sp_RunSubcription] @reportID */
        /* EXEC msdb.dbo.sp_start_job @job_name = @SubscriptionID */
        CALL reportserver$dacprd_dbo.addevent(par_EventType := 'TimedSubscription', par_EventData := var_SubscriptionID);
        FETCH NEXT FROM cursor_data INTO var_SubscriptionID, var_ReportName;
    END LOOP;
    CLOSE cursor_data;
    /*
    
    DROP TABLE IF EXISTS t$ds;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
