CREATE OR REPLACE PROCEDURE sdbtdir2_globe_dbo.webfebeoc_procval(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        CASE
            WHEN date_part('day', clock_timestamp()::TIMESTAMP) = 23 THEN clock_timestamp()
        END AS currentdatetime;
END;
$procedure$
