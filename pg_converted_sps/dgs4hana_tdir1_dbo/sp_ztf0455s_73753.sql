CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_ztf0455s()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.ztf0455s;
    INSERT INTO dgs4hana_tdir1_dbo.ztf0455s (mandt, bukrs, hkont, brand, wwspa, wwbrd, spb, wwst, pstky, gldef, intlind, taxrate, duom, exspb, averate, uli, subser)
    SELECT
        mandt, bukrs, hkont, brand, wwspa, wwbrd, spb, wwst, pstky, gldef, intlind, taxrate, duom, exspb, averate, uli, subser
        FROM dgs4hana_tdir1_dbo.vw_rt_ztf0455s;
END;
$procedure$
