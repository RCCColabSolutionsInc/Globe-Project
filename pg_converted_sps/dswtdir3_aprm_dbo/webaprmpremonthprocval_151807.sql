CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.webaprmpremonthprocval(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        *
        FROM (SELECT
            CASE
                WHEN date_part('day', clock_timestamp()::TIMESTAMP) <> 28 THEN clock_timestamp()
            END AS currentdatetime) AS v
        WHERE currentdatetime IS NOT NULL;
END;
$procedure$
