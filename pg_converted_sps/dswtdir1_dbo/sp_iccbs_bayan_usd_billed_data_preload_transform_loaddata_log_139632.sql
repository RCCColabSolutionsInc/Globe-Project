CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_usd_billed_data_preload_transform_loaddata_log()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* -- declare a date variable to bu used a postfix for the log table yyyymmdd_hhmmss remove dashs and spaces and colons */
    /* DECLARE @logDate VARCHAR(15) */
    /* SET @logDate = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120), '-', ''), ' ', '_'), ':', '') */
    /* -- create a log table with the name format: sp_ICCBS_Bayan_USD_Billed_Data_Preload_Transform_LoadData_Log_yyyymmdd_hhmmss */
    /* Drop the following tables if they exist. SQL Server 2012 syntax. */
    
    /*
    bl_act_trans_ext_BT_ssis_temp_20260429
            bl_act_trans_ext_BT_AllFiles_Union_temp_20260429
    		bl_act_trans_ext_BT_AllFiles_Union1_temp_20260429
    		bl_act_trans_ext_BT_AllFiles_Union2_temp_20260429
    		bl_act_trans_ext_BT_AllFiles_USD_temp_20260429
    		bl_act_trans_ext_BT_AllFiles_USD_Billed_temp_20260429
    */
    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_ssis_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_ssis_temp_20260429;
    END IF;

    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_AllFiles_Union_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union_temp_20260429;
    END IF;

    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_AllFiles_Union1_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union1_temp_20260429;
    END IF;

    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_AllFiles_Union2_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union2_temp_20260429;
    END IF;

    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_AllFiles_USD_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_temp_20260429;
    END IF;

    IF aws_sqlserver_ext.object_id('dbo.bl_act_trans_ext_BT_AllFiles_USD_Billed_temp_20260429', 'U') IS NOT NULL THEN
        DROP TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_billed_temp_20260429;
    END IF;
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_ssis_temp_20260429
    AS
    SELECT
        *, clock_timestamp() AS loaddatetime
        FROM sdbtdir1_iccbs_dbo.bl_act_trans_ext_bt_ssis;
    /* bl_act_trans_ext_BT_AllFiles_Union_temp_20260429 */
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union_temp_20260429
    AS
    SELECT
        filename, zbillmonth, zbillrundate,
        CASE zbillrundate
            WHEN '03' THEN 'C01'
            WHEN '05' THEN 'C02'
            WHEN '06' THEN 'C03'
            WHEN '08' THEN 'C04'
            WHEN '12' THEN 'C05'
            WHEN '15' THEN 'C06'
            WHEN '16' THEN 'C07'
            WHEN '21' THEN 'C08'
            WHEN '26' THEN 'C09'
            WHEN '28' THEN 'C10'
            WHEN '29' THEN 'C10'
            WHEN '30' THEN 'C10'
            WHEN '31' THEN 'C10'
            ELSE NULL
        END AS zbillcycle, zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30, column31, column32, column33, column34, column35, column36, column37
        FROM (SELECT
            filename, SUBSTR(filename, aws_sqlserver_ext.patindex('%[0-9][0-9][0-9][0-9].txt%', filename), 2) AS zbillmonth, SUBSTR(filename, aws_sqlserver_ext.patindex('%[0-9][0-9].txt%', filename), 2) AS zbillrundate, zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30, column31, column32, column33, column34, column35, column36, column37
            FROM sdbtdir1_iccbs_dbo.bl_act_trans_ext_bt_ssis) AS xx;
    /* bl_act_trans_ext_BT_AllFiles_Union1_temp_20260429 */
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union1_temp_20260429
    AS
    SELECT
        zbillmonth, zbillrundate, zbillcycle, zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30, column31, column32, column33, column34, column35, column36, column37
        FROM dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union_temp_20260429
        WHERE (zrownumber > 2) AND (LOWER(column3) LIKE LOWER('%I')) OR (LOWER(column3) LIKE LOWER('%A'));
    /* bl_act_trans_ext_BT_AllFiles_Union2_temp_20260429 */
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union2_temp_20260429
    AS
    SELECT
        union1.zbillmonth, union1.zbillrundate, union1.zbillcycle, union1.zrownumber, union1.column1, union1.column2, union1.column3, union1.column4, union1.column5, union1.column6, union1.column7, union1.column8, union1.column9, union1.column10, union1.column11, union1.column12, union1.column13, union1.column14, union1.column15, union1.column16, union1.column17, union1.column18, union1.column19, union1.column20, union1.column21, union1.column22, union1.column23, union1.column24, union1.column25, union1.column26, union1.column27, union1.column28, union1.column29, union1.column30, union1.column31, union1.column32, union1.column33, union1.column34, union1.column35, union1.column36, union1.column37,
        CASE
            WHEN LOWER(COALESCE(cust.customer_account, '')) = LOWER('') THEN LEFT(union1.column9, 3)
            ELSE LEFT(cust.service_type, 3)
        END AS correct_service_type, aws_sqlserver_ext.conv_date_to_string('VARCHAR', (date_trunc('MONTH', aws_sqlserver_ext.conv_string_to_datetime('DATETIME', union1.column4)) + INTERVAL '1 MONTH - 1 day')::DATE, 101) AS posting_date,
        CASE
            WHEN zbillmonth = '12' THEN 'JAN'
            ELSE SUBSTR('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (CAST (union1.zbillmonth AS INTEGER) + 1) * 4 - 3, 3)
        END AS enddate
        FROM dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union1_temp_20260429 AS union1
        LEFT OUTER JOIN dswtdir1_dbo.zffi_cust_serv AS cust
            ON COALESCE(union1.column6, '') = cust.customer_account::VARCHAR
        WHERE (union1.zbillmonth IN (SELECT
            LEFT(column2, 2) AS zbillmonth
            FROM sdbtdir1_iccbs_dbo.sap_blcb_php_ssis
            WHERE (LOWER(column1) = LOWER('01'))
            LIMIT 1));
    /* bl_act_trans_ext_BT_AllFiles_USD_temp_20260429 */
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_temp_20260429
    AS
    SELECT
        zbillmonth, zbillrundate, zbillcycle, zrownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, column20, column21, column22, column23, column24, column25, column26, column27, column28, column29, column30, column31, column32, column33, column34, column35, column36, column37, correct_service_type, posting_date,
        CASE
            WHEN column7 = 'B' THEN '21'
            WHEN column7 = 'C' THEN '15'
        END AS market_segment, enddate
        FROM dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_union2_temp_20260429
        WHERE (column33 = 'USD');
    /* bl_act_trans_ext_BT_AllFiles_USD_Billed_temp_20260429 */
    CREATE TABLE dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_billed_temp_20260429
    AS
    SELECT
        column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, column11, column12, column13, zrownumber
        FROM (SELECT
            column1, column2, column3, 'BNB2' AS column4, column5, column6, column7, '' AS column8, '' AS column9, '' AS column10, '' AS column11, '' AS column12, '' AS column13, '1' AS zrownumber
            FROM sdbtdir1_iccbs_dbo.sap_blcb_usd_ssis
            WHERE LOWER(column1) = LOWER('00')
        UNION
        SELECT
            '01' AS column1, posting_date AS column2, column7 AS column3, column8 AS column4, column24 AS column5, column12 AS column6, correct_service_type AS column7, '21' AS column8, column18 AS column9, column33 AS column10, regexp_replace(column35, ',', '', 'gi') AS column11, '' AS column12, '' AS column13, (ROW_NUMBER() OVER (ORDER BY zrownumber, zbillcycle)) + 1 AS zrownumber
            FROM dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_temp_20260429
        UNION
        SELECT
            '99' AS column1, 'USD' AS column2, CAST (COUNT(*) AS VARCHAR(30)) AS column3, CAST (SUM(CAST (regexp_replace(column35, ',', '', 'gi') AS NUMERIC(15, 2))) AS VARCHAR(30)) AS column4, '' AS column5, '' AS column6, '' AS column7, '' AS column8, '' AS column9, '' AS column10, '' AS column11, '' AS column12, '' AS column13, '1000000' AS zrownumber
            FROM dswtdir1_dbo.bl_act_trans_ext_bt_allfiles_usd_temp_20260429) AS bl_act_trans_ext_bt_allfiles_usd_billed;
    /* SELECT zrownumber,Column1, Column2, Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10,Column11,Column12,Column13 */
    /* FROM #bl_act_trans_ext_BT_AllFiles_USD_Billed x ORDER BY Column1,TRY_CAST(zrownumber as INT) */
END;
$procedure$
