CREATE OR REPLACE PROCEDURE etl_db_dbo.sp_listdateofmonth(IN par_date date DEFAULT NULL::date, INOUT p_refcur refcursor DEFAULT NULL::refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    IF par_Date IS NULL THEN
        par_Date := clock_timestamp();
    END IF;
    OPEN p_refcur FOR
    WITH daterange
    AS (SELECT
        CAST (0 + (aws_sqlserver_ext.datediff('month', 0::TIMESTAMP, par_Date::TIMESTAMP)::NUMERIC || ' MONTH')::INTERVAL AS DATE) AS startdate, CAST (- 1 + (aws_sqlserver_ext.datediff('month', - 1::TIMESTAMP, par_Date::TIMESTAMP)::NUMERIC || ' MONTH')::INTERVAL AS DATE) AS enddate)
    SELECT
        startdate + (number::NUMERIC || ' DAY')::INTERVAL AS datevalue
        FROM daterange
        CROSS JOIN master_dbo.spt_values
        WHERE LOWER(type) = LOWER('P') AND startdate + (number::NUMERIC || ' DAY')::INTERVAL <= enddate;
END;
$procedure$
