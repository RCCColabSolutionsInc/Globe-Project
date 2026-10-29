CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_subscribe()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* SELECT * INTO #ZFFI_SUBTYPE FROM  [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_SUBTYPE]; */
    TRUNCATE TABLE dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca;
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca ("subscriber_type")
    SELECT DISTINCT
        column05 AS "Subscriber Type"
        FROM dswtdir2_innove_dbo.ttinnove_billed
        LEFT OUTER JOIN dswtdir2_innove_dbo.zffi_subtype
        /* #ZFFI_SUBTYPE -- [dgS4HANA_TDIR1].[dbo].[vw_RT_ZFFI_SUBTYPE] */
            ON LOWER(column05) = LOWER(zsubtype) AND (LOWER(zbukrs) = LOWER('INOV')) AND LOWER(mandt) = LOWER('300')
        WHERE (LOWER(column01) = LOWER('01'))
		AND (zsubtype IS NULL);
    /*
    SELECT DISTINCT Column05 as [Subscriber Type]
      FROM   dbo.ttInnove_Billed
    		 LEFT OUTER JOIN dbo.ZFFI_SUBTYPE
    					  ON Column05 = ZSUBTYPE
    	   AND ( ZBUKRS = N'INOV' )
      WHERE  ( Column01 = N'01' )
    		 AND ( ZSUBTYPE IS NULL );
    */
END;
$procedure$
