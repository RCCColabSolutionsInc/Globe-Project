CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_rates_syniv()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_rates_syniv;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_rates_syniv (mandt, gjahr, perio, month_name, usd_sdr, eur_sdr, gbp_sdr, hkd_sdr, chf_sdr, eur_usd, gbp_usd, chf_usd, hkd_usd)
    SELECT
        mandt, gjahr, perio, month_name, usd_sdr, eur_sdr, gbp_sdr, hkd_sdr, chf_sdr, eur_usd, gbp_usd, chf_usd, hkd_usd
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_rates_syniv;
END;
$procedure$
