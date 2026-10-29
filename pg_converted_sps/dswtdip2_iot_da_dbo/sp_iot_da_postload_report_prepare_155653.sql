CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_postload_report_prepare()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_AccountGroup VARCHAR(255);
    account_cursor CURSOR FOR
    SELECT
        account_group
        FROM dswtdip2_iot_da_dbo.vw_rpt_actgroup;
BEGIN
    TRUNCATE TABLE dswtdip2_iot_da_dbo.rpt_iot_da_postload_report_prepare_cache;
    /* Declare variables */
    /* Declare the cursor */
    /* Open the cursor */
    OPEN account_cursor;
    /* Fetch the first row from the cursor */
    FETCH NEXT FROM account_cursor INTO var_AccountGroup;
    /* Loop through the rows */

    WHILE (CASE FOUND::INT
        WHEN 0 THEN - 1
        ELSE 0
    END) = 0 LOOP
        /* Execute the stored procedure for each account group */
        CALL dswtdip2_iot_da_dbo.sp_iot_da_postload_report_prepare_load(var_AccountGroup);
        /* Fetch the next row from the cursor */
        FETCH NEXT FROM account_cursor INTO var_AccountGroup;
    END LOOP;
    /* Close and deallocate the cursor */
    CLOSE account_cursor;
END;
$procedure$
