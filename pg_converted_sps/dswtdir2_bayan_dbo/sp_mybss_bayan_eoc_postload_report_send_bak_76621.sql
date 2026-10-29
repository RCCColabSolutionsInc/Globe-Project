CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_report_send_bak(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: February 9, 2023 */
/* Description: Report */
/* ============================================= */
/* ex: EOC1 to EOC11 */
DECLARE
    var_BillCycle VARCHAR(5);
    var_SubscriptionID UUID;
    var_ReportName VARCHAR(300);
    cursor_data CURSOR FOR
    SELECT
        x.subscriptionid, x.reportname
        FROM etl_db_dbo.vw_reportsubcriptions AS x
        WHERE x.reportname IN (SELECT
            d.reportname
            FROM t$ds AS d
            WHERE d.recordcount > 0) AND LOWER(x.sub_desc) = LOWER(par_CycleCode);
BEGIN
    SELECT
        billcycle
        INTO var_BillCycle
        FROM dswtdir2_bayan_dbo.billcycles
        WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
    /* POSTLOAD REPORTS */
    /* Loop from the table and process based on conditions */
    CREATE TEMPORARY TABLE t$ds
    (reportname VARCHAR(500),
        recordcount INTEGER);
    /* used to check and send only if there is a data */
    INSERT INTO t$ds (reportname, recordcount)
    SELECT
        'Bayan_Billed_Postload_Error', COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_error_cache
        WHERE LOWER(billcycle) = LOWER(var_BillCycle)
    UNION ALL
    SELECT
        'Bayan_Billed_Postload_Valid', COUNT(1)
        FROM dswtdir2_bayan_dbo.rpt_postload_report_prepare_dp1_billed_valid_cache
        WHERE LOWER(billcycle) = LOWER(var_BillCycle);
    /* AND x.[Parameters] LIKE '%<Value>' +@CycleCode+'</Value>%' -- get related reports by cycle code */
    OPEN cursor_data;
    FETCH NEXT FROM cursor_data INTO var_SubscriptionID, var_ReportName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* EXEC [dbo].[sp_RunSubcription] @reportID */
        /* EXEC msdb.dbo.sp_start_job @job_name = @reportID */
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
