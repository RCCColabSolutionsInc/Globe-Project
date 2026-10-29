CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp5_unconfirmed_adj_report_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_MonthYearKeyword VARCHAR(20);
    var_SubscriptionID UUID;
    var_SubscriptionName VARCHAR(300);
    var_DynamicSubscriptionName VARCHAR(200);
    var_FileDirectory VARCHAR(1000);
    cursor_subscription CURSOR FOR
    SELECT DISTINCT
        subscriptions.SubscriptionID, subscriptions.Description, temptable.dynamicsubscriptionpattern
        FROM reportserver$dacprd_dbo.subscriptions AS subscriptions
        INNER JOIN t$temptable AS temptable
            ON temptable.subscriptionpattern = subscriptions.Description;
    var_DeleteCommand VARCHAR(1000);
    var_EventCount INTEGER;
    var_Iteration INTEGER;
BEGIN
    /* dynamic name */
    var_FileDirectory := E'F:\\BOA\\Transform\\Report\\TDIR2-MyBSS\\Globe\\ttGlobe_DP5_Unconfirmed_ALL_SSRS';
    /* Previous month MMYY */
    
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT @MonthYearKeyword = FORMAT(DATEADD(MONTH, -1, GETDATE()), 'MMyy');
    */
    /* Create temporary table and insert predefined string patterns */
    CREATE TEMPORARY TABLE t$temptable
    (subscriptionpattern VARCHAR(500),
        dynamicsubscriptionpattern VARCHAR(500) NULL);
    INSERT INTO t$temptable (subscriptionpattern)
    SELECT
        'Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Error'
    UNION ALL
    SELECT
        'Glob_Unconfirmed_Adj_Postload_DP5_MMYY_Valid';
    /* Replace template with dynamic name */
    UPDATE t$temptable
    SET dynamicsubscriptionpattern = regexp_replace(subscriptionpattern, '_MMYY', '_' || var_MonthYearKeyword, 'gi')
        WHERE LOWER(subscriptionpattern) LIKE LOWER('%_MMYY%');
    /* Declare cursor for specific subscription patterns */
    OPEN cursor_subscription;
    FETCH NEXT FROM cursor_subscription INTO var_SubscriptionID, var_SubscriptionName, var_DynamicSubscriptionName;
    /* Loop through the selected subscriptions */

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Delete previous file */
        var_DeleteCommand := 'del /Q ' || var_FileDirectory || E'\\' || var_DynamicSubscriptionName || '.xlsx';
        var_Iteration := 1;
        var_EventCount := 0;
        CALL xp_cmdshell(var_DeleteCommand);
        /* Trigger SSRS export to excel */
        CALL reportserver$dacprd_dbo.addevent(par_EventType := 'TimedSubscription', par_EventData := var_SubscriptionID);
        /* Count events related to the current subscription */
        SELECT
            COUNT(1)
            INTO var_EventCount
            FROM reportserver$dacprd_dbo.event AS event
            WHERE event.eventdata = var_SubscriptionID;
        /* Continuously check if the export process is completed. 3 seconds waiting time per iteration. */
        /* If it reached 25 iteration and not yet finished then end the process. */

        WHILE var_EventCount > 0 LOOP
            IF var_Iteration = 25 THEN
                RAISE NOTICE 'Breaking - reached maximum iteration.';
                EXIT;
            END IF;
            PERFORM aws_sqlserver_ext.waitfor_delay('00:00:03');
            /* wait for 3 seconds for the processing */
            /* Update the event count */
            SELECT
                COUNT(1)
                INTO var_EventCount
                FROM reportserver$dacprd_dbo.event AS event
                WHERE event.eventdata = var_SubscriptionID;
            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20));
            var_Iteration := (var_Iteration + 1)::INT;
        END LOOP;
        FETCH NEXT FROM cursor_subscription INTO var_SubscriptionID, var_SubscriptionName, var_DynamicSubscriptionName;
    END LOOP;
    /* Close and deallocate the cursor */
    CLOSE cursor_subscription;
    /*
    
    DROP TABLE IF EXISTS t$temptable;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
