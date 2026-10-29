CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_zffi_ubadj_sbp()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.zffi_ubadj_sbp;
    INSERT INTO dgs4hana_tdir1_dbo.zffi_ubadj_sbp (mandt, z_adj_tax_code, z_adj_reason, hkont, wwspb, z_vat_rate)
    SELECT
        mandt, z_adj_tax_code, z_adj_reason, hkont, wwspb, z_vat_rate
        FROM dgs4hana_tdir1_dbo.vw_rt_zffi_ubadj_sbp;
END;
$procedure$
