CREATE OR REPLACE PROCEDURE sdbtdir1_iccbs_dbo.sp_sourcefilecount(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CREATE TEMPORARY TABLE t$data
    AS
    SELECT
        a.tablename, yy.filename, yy.recordswritted, yy.dateread
        FROM sdbtdir1_iccbs_dbo.table_eoc_dest AS a
        LEFT OUTER JOIN (SELECT
            'AA0850_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.aa0850_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'AA0861_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.aa0861_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'AA0891_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.aa0891_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'AA0892_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.aa0892_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'BP0940_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.bp0940_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'BP0970_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.bp0970_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_BDEF_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_bdef_all_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_BLCB_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_blcb_all_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_BLCB_PHP_mmdd_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_blcb_php_mmdd_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_BLCU_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_blcu_all_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_BLCB_USD_mmdd_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_blcb_usd_mmdd_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_FDEF_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_fdef_all_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_FLCB_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_flcb_all_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_FLCB_PHP_mmdd_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_flcb_php_mmdd_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_FLCB_USD_mmdd_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_flcb_usd_mmdd_ssis AS x
            GROUP BY x.filename
        UNION ALL
        SELECT
            'SAP_FLCU_ALL_ssis' AS tablename, x.filename, COUNT(1) AS recordswritted, MAX(x.dateread) AS dateread
            FROM sdbtdir1_iccbs_dbo.sap_flcu_all_ssis AS x
            GROUP BY x.filename) AS yy
            ON LOWER(a.tablename) = LOWER(yy.tablename)
        ORDER BY 1 NULLS FIRST, 2 NULLS FIRST;
    /*
    [7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function., 7811 - Severity CRITICAL - PostgreSQL doesn't support the FORMAT(VARCHAR,VARCHAR) function. DMS SC skips this unsupported function in the converted code. Create a user-defined function to replace the unsupported function.]
    SELECT
    	x.zBillMonth,
    	x.zBillRunDate,
    	y.BillCycelCode as [zBillCycle],
    	x.TableName,
    	x.[FileName],
    	x.RecordsWritted,
    	x.DateRead
    	FROM
    	(
    		SELECT xx.*,
    		FORMAT(xx.ExtractedDate,'MM') as [zBillMonth],
    		FORMAT(xx.ExtractedDate,'dd') as [zBillRunDate]
    		FROM
    		(
    			SELECT *,
    				CONVERT(DATE,
    							   CAST(YEAR(GETDATE()) AS NVARCHAR(4)) + '-' +
    							   SUBSTRING([FileName], LEN([FileName]) - CHARINDEX('_', REVERSE([FileName])) + 2, 2) + '-' +
    							   SUBSTRING([FileName], LEN([FileName]) - CHARINDEX('_', REVERSE([FileName])) + 4, 2)) AS ExtractedDate
    			FROM [#Data] x
    			-- WHERE LEN(x.[FileName]) = 21
    		) as xx
    	) as x
    	LEFT JOIN BillCycleMapping y ON y.RunDate = x.zBillRunDate
    */
    /*
    
    DROP TABLE IF EXISTS t$data;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
