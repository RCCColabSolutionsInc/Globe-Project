CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_bayan_usd_billed_data_preload_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_zffi_prod_serv();
    CALL dgs4hana_tdir1_dbo.sp_zffi_cust_serv();
    CALL dgs4hana_tdir1_dbo.sp_zffi_rev_serv();
    CALL dgs4hana_tdir1_dbo.sp_ztf0001();
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta();
    /* TODO */
    /* [ZFFI_FLCN_PRDG] */
    /* [ZFFI_CUST_MKTSEG] */
END;
$procedure$
