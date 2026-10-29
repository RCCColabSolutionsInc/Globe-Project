CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eom_preload_unbilled_adj_report_export_b4_refact()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_Keyword_SSRS VARCHAR(20);
    var_SubsID UUID;
    var_SubsName VARCHAR(300);
    var_Dyn_subname VARCHAR(200);
    var_Path VARCHAR(1000);
    cursor_job CURSOR FOR
    SELECT DISTINCT
        x.SubscriptionID, x.Description, d.dyn_subname
        FROM reportserver$dacprd_dbo.subscriptions AS x
        INNER JOIN t$ds AS d
            ON d.subname = x.Description;
    var_HousekeepCmd VARCHAR(1000);
    var_Cnt INTEGER;
    var_Iteration INTEGER;
BEGIN
    /* TODO */
    /* dunamic name */
    var_Path := E'F:\\BOA\\Transform\\Report\\TDIR2-MyBSS\\Bayan\\ttBayan_Unbilled_Adj_SSRS';
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT @Keyword_SSRS = FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy');
    */
    /* Previous month MMYY */
    CREATE TEMPORARY TABLE t$ds
    (subname VARCHAR(500),
        dyn_subname VARCHAR(500) NULL);
    INSERT INTO t$ds (subname)
    SELECT
        'Bayn_UA_Preload_DP4_MMYY_SubsTypeMissing'
    UNION ALL
    SELECT
        'Bayn_UA_Preload_DP4_MMYY_ChargeCodeMissing'
    UNION ALL
    SELECT
        'Bayn_UA_Preload_DP4_MMYY'
    UNION ALL
    SELECT
        'Bayn_UA_Preload_DP4_MMYY_VarianceInTotalAmount';
    /* get the dynamic name from template */
    UPDATE t$ds
    SET dyn_subname = regexp_replace(subname, '_MMYY', '_' || var_Keyword_SSRS, 'gi')
        WHERE LOWER(subname) LIKE LOWER('%_MMYY%');
    /* WHERE x.[Description] IN(SELECT d.subname FROM #Ds d) */
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_Dyn_subname;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Delete previous file */
        var_HousekeepCmd := 'del /Q ' || var_Path || E'\\' || var_Dyn_subname || '.xlsx';
        var_Iteration := 1;
        var_Cnt := 0;
        CALL xp_cmdshell(var_HousekeepCmd);
        /* Trigger SSRS export to excel */
        CALL reportserver$dacprd_dbo.addevent(par_EventType := 'TimedSubscription', par_EventData := var_SubsID);
        SELECT
            COUNT(1)
            INTO var_Cnt
            FROM reportserver$dacprd_dbo.event AS x
            WHERE x.EventData = var_SubsID;
        /* Continous checking if the export process is completed. 3 seconds waiting time per iteration. */
        /* If it reached 25 iteration and not yet finished then end the process. */

        WHILE var_Cnt > 0 LOOP
            IF var_Iteration = 25 THEN
                RAISE NOTICE 'Breaking - reached maximum iteration.';
                EXIT;
            END IF;
            PERFORM aws_sqlserver_ext.waitfor_delay('00:00:03');
            /* wait for 3 seconds for the processing */
            SELECT
                COUNT(1)
                INTO var_Cnt
                FROM reportserver$dacprd_dbo.event AS x
                WHERE x.EventData = var_SubsID;
            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20));
            var_Iteration := (var_Iteration + 1)::INT;
        END LOOP;
        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName, var_Dyn_subname;
    END LOOP;
    CLOSE cursor_job;
    /*
    
    DROP TABLE IF EXISTS t$ds;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
