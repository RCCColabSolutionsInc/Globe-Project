CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_tcurt()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.tcurt;
    INSERT INTO dgs4hana_tdir1_dbo.tcurt (mandt, spras, waers, ltext, ktext)
    SELECT
        mandt, spras, waers, ltext, ktext
        FROM dgs4hana_tdir1_dbo.vw_rt_tcurt;
END;
$procedure$
