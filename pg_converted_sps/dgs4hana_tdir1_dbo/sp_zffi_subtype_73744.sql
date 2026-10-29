CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_subtype()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_subtype;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_subtype (mandt, zbukrs, zsubtype, zprofit_center, zwwpdt_pa, zwwspa_pa, zwwspb_pa, zwwfra_pa, zwwbuc_pa, zwwsr_pa, zwwst_pa, zwwseg_pa, zwwthn_pa, zwwbrd_pa, zwwmvn_pa, zwwcpd_pa, zwwpty_pa, zwwrit_pa, datbu, uzeit, uname)
    SELECT
        mandt, zbukrs, zsubtype, zprofit_center, zwwpdt_pa, zwwspa_pa, zwwspb_pa, zwwfra_pa, zwwbuc_pa, zwwsr_pa, zwwst_pa, zwwseg_pa, zwwthn_pa, zwwbrd_pa, zwwmvn_pa, zwwcpd_pa, zwwpty_pa, zwwrit_pa, datbu, uzeit, uname
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_subtype;
END;
$procedure$
