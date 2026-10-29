CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_export_loadfilesel(INOUT p_refcur refcursor, INOUT p_refcur_2 refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_RowCount INTEGER;
BEGIN
    /* Chec the count of the detail('01'), if record count is 0 then return an empty table to prevent the genereation of export file. */
    SELECT
        COUNT(1)
        INTO var_RowCount
        FROM dswtdir3_aprm_dbo.txaprm_content_1st_exportsel AS x
        WHERE LOWER(x.column1) = LOWER('01');

    IF var_RowCount < 1 THEN
        OPEN p_refcur FOR
        SELECT
            NULL AS dummy
            LIMIT 0;
        /* return empty table */
        RETURN;
    END IF;
    OPEN p_refcur_2 FOR
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17
        FROM dswtdir3_aprm_dbo.txaprm_content_1st_exportsel;
END;
$procedure$
