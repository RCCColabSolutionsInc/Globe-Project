CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_postload_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
/* EXEC sp_helptext 'sp_Memo_Postload_Line_LoadSapTables' */
BEGIN
    /*
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T007A];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_SKB1];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_SKA1];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_SKAT];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T030K];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T042Z];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T25A1];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T25A2];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T25A4];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_T25A9];
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_TVZBT];
    */
    CALL dgs4hana_tdir1_dbo.sp_zffi_report_odbc_delta();
    RAISE NOTICE 'TODO';
END;
$procedure$
