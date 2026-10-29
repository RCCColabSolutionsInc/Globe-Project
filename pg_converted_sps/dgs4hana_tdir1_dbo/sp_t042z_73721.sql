CREATE OR REPLACE PROCEDURE dgs4hana_tdir1_dbo.sp_t042z()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    TRUNCATE TABLE dgs4hana_tdir1_dbo.t042z;
    INSERT INTO dgs4hana_tdir1_dbo.t042z (mandt, land1, zlsch, text1, xbkkt, xstra, xeinz, xesrd, xpgir, xezer, xschk, progn, xzwhr, xeuro, formi, formz, xwech, xwanf, xpskt, xwecs, blart, blarv, umskz, xswec, txtsl, zlstn, wlstn, xzanf, xaktz, weart, xnopo, xorb, xiban, xno_accno, xsepa)
    SELECT
        mandt, land1, zlsch, text1, xbkkt, xstra, xeinz, xesrd, xpgir, xezer, xschk, progn, xzwhr, xeuro, formi, formz, xwech, xwanf, xpskt, xwecs, blart, blarv, umskz, xswec, txtsl, zlstn, wlstn, xzanf, xaktz, weart, xnopo, xorb, xiban, xno_accno, xsepa
        FROM dgs4hana_tdir1_dbo.vw_rt_t042z;
END;
$procedure$
