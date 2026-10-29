CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_scenario_loadsaptables()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dgs4hana_tdir1_dbo.sp_t007a();
    CALL dgs4hana_tdir1_dbo.sp_skb1();
    CALL dgs4hana_tdir1_dbo.sp_ska1();
    CALL dgs4hana_tdir1_dbo.sp_skat();
    CALL dgs4hana_tdir1_dbo.sp_t030k();
    CALL dgs4hana_tdir1_dbo.sp_t042z();
    CALL dgs4hana_tdir1_dbo.sp_t25a1();
    CALL dgs4hana_tdir1_dbo.sp_t25a2();
    CALL dgs4hana_tdir1_dbo.sp_t25a4();
    CALL dgs4hana_tdir1_dbo.sp_t25a9();
    CALL dgs4hana_tdir1_dbo.sp_tvzbt();
    CALL dgs4hana_tdir1_dbo.sp_lfb1();
    CALL dgs4hana_tdir1_dbo.sp_csks();
    CALL dgs4hana_tdir1_dbo.sp_aufk();
    CALL dgs4hana_tdir1_dbo.sp_lfbw();
    /* the following are long running. Please schedule them off peak hours */
    
    /*
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_PRPS]; -- 6,537,724 approximate records
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_BSAK]; -- 15,788,298 approximate records
    EXEC [dgS4HANA_TDIR1].[dbo].[sp_BSIK]; -- 48,951,763 approximate records
    */
END;
$procedure$
