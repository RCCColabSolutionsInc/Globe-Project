CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zduration_with()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE t$sap_blcb_usd_duration_010
    AS
    SELECT
        column3, column4, column6, column9, SUM(CAST (column12 AS NUMERIC(38, 2))) AS duration
        FROM sdbtdir1_iccbs_dbo.sap_blcb_usd_ssis
        WHERE (LOWER(column1) = LOWER('01')) AND (LOWER(column9) = LOWER('N650'))
        GROUP BY column3, column4, column6, column9;
    CREATE TEMPORARY TABLE t$srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zduration_010updsel
    AS
    SELECT
        a.zcust_class_code, a.zaccount_category, a.zproduct_group, MIN(a.zdsp_order) AS expr1, b.duration
        FROM dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd AS a
        INNER JOIN t$sap_blcb_usd_duration_010 AS b
            ON LOWER(a.zcust_class_code) = LOWER(b.column3) AND LOWER(a.zaccount_category) = LOWER(b.column4) AND LOWER(a.zproduct_group) = LOWER(b.column6) AND LOWER(a.zrevenue_item_code) = LOWER(b.column9)
        WHERE (LOWER(a.zrevenue_item_code) = LOWER('N650')) AND (a.zactive = '1')
        GROUP BY a.zcust_class_code, a.zaccount_category, a.zproduct_group, b.duration;
    /* SELECT        a.zDuration, b.duration AS zDurationNew, a.zUnit_of_measurement, 'MBPS' AS zUnit_of_measurementNew */
    UPDATE dswtdir1_dbo.stbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd AS a
    SET zduration = b.duration, zunit_of_measurement = 'MBPS'
    FROM t$srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zduration_010updsel AS b
        WHERE a.zdsp_order = b.expr1;
    /*
    
    DROP TABLE IF EXISTS t$sap_blcb_usd_duration_010;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /*
    
    DROP TABLE IF EXISTS t$srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zduration_010updsel;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
    /* #srBayan_USD_Billed_Data_TDIR1_ICCBS_sap_blcb_USD_zDuration_withzActiveUpdSel */
    
    /*
    Update [dbo].[srBayan_USD_Billed_Data_TDIR1_ICCBS_sap_blcb_USD_zDuration_withzActiveUpdSel]
    SET [zDuration] = [zDurationNew],
        [zUnit_of_measurement] = [zUnit_of_measurementNew]
    */
END;
$procedure$
