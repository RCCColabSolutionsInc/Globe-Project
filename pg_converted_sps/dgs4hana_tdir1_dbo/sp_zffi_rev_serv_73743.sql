CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_rev_serv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_rev_serv;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_rev_serv (mandt, ric_st, revenue_itemcode, revenue_type)
    SELECT
        mandt, ric_st, revenue_itemcode, revenue_type
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_rev_serv;
END;
$procedure$
