CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_postload_report_export(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
/* ex: EOC1 to EOC11 */
DECLARE
    var_Keyword_SSRS VARCHAR(20);
    var_SubsID UUID;
    var_SubsName VARCHAR(300);
    cursor_job CURSOR FOR
    SELECT
        x.SubscriptionID, x.Description
        FROM reportserver$dacprd_dbo.subscriptions AS x
        WHERE x.Description IN (SELECT
            d.subname
            FROM t$ds AS d);
    var_HousekeepCmd VARCHAR(1000);
    var_Cnt INTEGER;
    var_Iteration INTEGER;
BEGIN
    SELECT
        x.keyword_ssrs
        INTO var_Keyword_SSRS
        FROM dswtdir2_innove_dbo.billcycles AS x
        WHERE LOWER(x.cyclecode) = LOWER(par_CycleCode);
    CREATE TEMPORARY TABLE t$ds
    (subname VARCHAR(500));
    INSERT INTO t$ds (subname)
    SELECT
        'Inov_Billed_Postload_DP1' || var_Keyword_SSRS || '_Valid'
    UNION ALL
    SELECT
        'Inov_Billed_Postload_DP1' || var_Keyword_SSRS || '_Error';
    OPEN cursor_job;
    FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName;

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Delete previous file */
        var_HousekeepCmd := E'del /Q F:\\BOA\\Transform\\Report\\TDIR2-MyBSS\\Innove\\ttInnove_Billed_SSRS\\' || var_SubsName || '.xlsx';
        var_Iteration := 1;
        var_Cnt := 0;
        CALL xp_cmdshell(var_HousekeepCmd);
        /* Trigger SSRS export to excel */
        CALL reportserver$dacprd_dbo.addevent(par_EventType := 'TimedSubscription', par_EventData := var_SubsID);
        SELECT
            COUNT(1)
            INTO var_Cnt
            FROM reportserver$dacprd_dbo.event AS x
            WHERE x.eventdata = var_SubsID;
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
                WHERE x.eventdata = var_SubsID;
            RAISE NOTICE '%', 'Iteration No : ' || CAST (var_Iteration AS VARCHAR(20));
            var_Iteration := (var_Iteration + 1)::INT;
        END LOOP;
        FETCH NEXT FROM cursor_job INTO var_SubsID, var_SubsName;
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
