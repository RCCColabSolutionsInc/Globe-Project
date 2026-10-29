CREATE OR REPLACE PROCEDURE sdbtdir1_prepaid_dbo.billadjustment_pivot_test(IN par_table_name1 character varying, IN par_table_name2 character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_SQL TEXT;
    var_cycle_code TEXT DEFAULT '%' || 'Cycle Code' || '%';
    var_cycle_year TEXT DEFAULT '%' || 'Cycle Year' || '%';
    var_cycle_Instance TEXT DEFAULT '%' || 'Cycle Instance' || '%';
    var_cycle TEXT DEFAULT '%' || 'Cycle' || '%';
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    var_SQL := 'SELECT MAX(CASE WHEN LOWER(COLUMN1) LIKE LOWER(var_cycle_code) THEN COLUMN2 END) AS cycle_code, MAX(CASE WHEN LOWER(COLUMN1) LIKE LOWER(var_cycle_year) THEN COLUMN2 END) AS cycle_year, MAX(CASE WHEN LOWER(COLUMN1) LIKE LOWER(var_cycle_Instance) THEN COLUMN2 END) AS cycle_instance FROM par_TABLE_NAME1 WHERE LOWER(Column1) LIKE LOWER(var_cycle)';
    OPEN p_refcur FOR
    EXECUTE var_SQL;
END;
$procedure$
