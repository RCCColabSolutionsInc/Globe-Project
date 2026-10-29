CREATE OR REPLACE PROCEDURE sdbtdir2_globe_dbo.web_febeoc_proc(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        CASE
            WHEN date_part('day', clock_timestamp()::TIMESTAMP) = 23 THEN 'RUN'
        END AS event_date;
END;
$procedure$
