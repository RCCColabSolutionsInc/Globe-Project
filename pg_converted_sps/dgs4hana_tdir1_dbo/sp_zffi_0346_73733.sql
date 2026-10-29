CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_0346()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_0346;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_0346 (mandt, bukrs, zccode, zwaers, zpk_debit, zgl_debit, zpk_credit, zgl_credit, zter_flag, zter_pk_debit, zter_gl_debit, zter_pk_credit, zter_gl_credit, zdiscount_flag, zvat_oct_flg, zvat_gl_debit, zvat_gl_credit, zoct_rate, zvatinc_flg, zvatinc_gl_debit, zvatinc_gl_credit, zvat_rate, zwrite_off_flg, zwrite_gl_debit, zwrite_gl_credit, zunbil_gl_debit, zunbil_gl_credit, zdef_gl_debit, zdef_gl_credit, datbu, uzeit, uname)
    SELECT
        mandt, bukrs, zccode, zwaers, zpk_debit, zgl_debit, zpk_credit, zgl_credit, zter_flag, zter_pk_debit, zter_gl_debit, zter_pk_credit, zter_gl_credit, zdiscount_flag, zvat_oct_flg, zvat_gl_debit, zvat_gl_credit, zoct_rate, zvatinc_flg, zvatinc_gl_debit, zvatinc_gl_credit, zvat_rate, zwrite_off_flg, zwrite_gl_debit, zwrite_gl_credit, zunbil_gl_debit, zunbil_gl_credit, zdef_gl_debit, zdef_gl_credit, datbu, uzeit, uname
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_0346;
END;
$procedure$
