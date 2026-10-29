CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eom_preload_unbilled_char_report_export_pg()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_MonthYearKeyword VARCHAR(20);
    var_SubscriptionID UUID;
    var_SubscriptionName VARCHAR(300);
    var_DynamicSubscriptionName VARCHAR(200);
    var_FileDirectory VARCHAR(1000);
    cursor_subscription CURSOR FOR
        SELECT DISTINCT s.SubscriptionID, s.Description, t.dynamicsubscriptionpattern
        FROM reportserver_dacprd_dbo.subscriptions s
        INNER JOIN t_temptable t
            ON t.subscriptionpattern = s.Description;
BEGIN
    var_MonthYearKeyword := to_char(current_date - interval '1 month', 'MMYY');

    CREATE TEMP TABLE t_temptable (
        subscriptionpattern VARCHAR(500),
        dynamicsubscriptionpattern VARCHAR(500)
    );

    INSERT INTO t_temptable (subscriptionpattern)
    VALUES
        ('Inov_UC_Preload_DP3_MMYY_SubsTypeMissing'),
        ('Inov_UC_Preload_DP3_MMYY_ChargeCodeMissing'),
        ('Inov_UC_Preload_DP3_MMYY'),
        ('Inov_UC_Preload_DP3_MMYY_VarianceInTotalAmount');

    UPDATE t_temptable
    SET dynamicsubscriptionpattern = regexp_replace(subscriptionpattern, '_MMYY', '_' || var_MonthYearKeyword, 'gi');

    OPEN cursor_subscription;
    LOOP
        FETCH cursor_subscription INTO var_SubscriptionID, var_SubscriptionName, var_DynamicSubscriptionName;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Processing subscription: %', var_DynamicSubscriptionName;

    END LOOP;
    CLOSE cursor_subscription;

    DROP TABLE IF EXISTS t_temptable;
END;
$procedure$
