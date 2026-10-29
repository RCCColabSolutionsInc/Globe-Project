CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eom_postload_dp2_transform()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Winston Madiano */
/* Create date: January 21, 2023 */
/* Description: Transform postload data */
/* ============================================= */
BEGIN
    /* EXEC [dbo].trGlobe_DP2_Unearned_zLoaded_1Upd -- 	Loaded Records */
    /* EXEC [dbo].trGlobe_DP2_Unearned_zLoaded_0_Error_LineUpd --	Update all records as not loaded if any error */
    /* Custom implementation */
    /* SELECT * INTO #LATEST_ODBC FROM [dgS4HANA_TDIR1].[dbo].[vw_ZFFI_REPORT_ODBC_LATESTLOGS] x; */
    /* EXEC [dbo].trGlobe_DP2_Unearned_zLoaded_1Upd -- Loaded Records. recoded below */
    UPDATE dswtdir2_globe_dbo.ttglobe_dp2_unearned
    SET zloaded = '1'
    FROM dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
    /* #LATEST_ODBC x */
        WHERE LOWER(ttglobe_dp2_unearned.zdsp_order) = LOWER(x.zdsp_order) AND LOWER(ttglobe_dp2_unearned.zdsp_uniquekey) = LOWER(x.zdsp_uniquekey) AND LOWER(z_message) NOT SIMILAR TO LOWER('%is not found%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%requires an assignment to a CO object%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%does not exist in chart of accounts%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%Error in document%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%not defined in chart of accounts%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%not allowed for characteristic%') AND LOWER(z_message) NOT SIMILAR TO LOWER('%Balance in Transaction Currency%') AND LOWER(data) = LOWER('01');
    /* EXEC [dbo].trGlobe_DP2_Unearned_zLoaded_0_Error_LineUpd --	Update all records as not loaded if any error */
    CREATE TEMPORARY TABLE t$error
    AS
    SELECT
        zsource, COUNT(z_message) AS error_count
        FROM dswtdir2_globe_dbo.ttglobe_dp2_unearned
        INNER JOIN dgs4hana_tdir1_dbo.vw_zffi_report_odbc_latestlogs AS x
        /* #LATEST_ODBC x */
            ON LOWER(ttglobe_dp2_unearned.zdsp_order) = LOWER(x.zdsp_order) AND LOWER(ttglobe_dp2_unearned.zdsp_uniquekey) = LOWER(x.zdsp_uniquekey)
        WHERE (LOWER(z_message) SIMILAR TO LOWER('%is not found%') OR LOWER(z_message) SIMILAR TO LOWER('%requires an assignment to a CO object%') OR LOWER(z_message) SIMILAR TO LOWER('%does not exist in chart of accounts%') OR LOWER(z_message) SIMILAR TO LOWER('%Error in document%') OR LOWER(z_message) SIMILAR TO LOWER('%not defined in chart of accounts%') OR LOWER(z_message) SIMILAR TO LOWER('%not allowed for characteristic%') OR LOWER(z_message) SIMILAR TO LOWER('%Balance in Transaction Currency%')) AND LOWER(data) = LOWER('01')
        GROUP BY
        /* ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_ORDER,ZFFI_REPORT_ODBC_LATESTLOGS.ZDSP_UNIQUEKEY */
        zsource
        HAVING COUNT(z_message) > 0;
    UPDATE dswtdir2_globe_dbo.ttglobe_dp2_unearned
    SET zloaded = '0'
        WHERE zsource IN (SELECT
            e.zsource
            FROM t$error AS e);
    /*
    
    DROP TABLE IF EXISTS t$error;
    */
    /*
    
    Temporary table must be removed before end of the function.
    */
END;
$procedure$
